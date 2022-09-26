library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

library work;
use work.rf_types.all;



--------------------------------------------------------------------------------
--
-- Large multiplexer supporting n-Bit inputs.
-- Selects inputs corresponding to their position, i.e. selection mask 0x00
--  selects input at index 0, wheras 0xFF selects the last input.
--
-- @in in_select - Line selection bits.
-- @in in_values - Array of n-Bit input arrays.
--
-- @out out_value - Selected output bit array.
--
-- @complexity    2^m * (n + m) + m - 1    (n = input_bits; m = select_bits)
-- @runtime       2m + 1
--
--------------------------------------------------------------------------------

entity Mux_n_Bit is
	generic(
		INPUT_BITS  : positive;
		SELECT_BITS : positive
	);
    port(
		in_select  : in  std_logic_vector(SELECT_BITS-1 downto 0);
		in_values  : in  std_logic_matrix((2**SELECT_BITS)-1 downto 0)(INPUT_BITS-1 downto 0);
		out_value  : out std_logic_vector(INPUT_BITS-1 downto 0)
    );
end Mux_n_Bit;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of Mux_n_Bit is

	component And_n_Bit is
		generic(
			CONDITIONS : positive;
			INPUT_BITS : positive
		);
		port(
			in_conds   : in  std_logic_vector(CONDITIONS-1 downto 0);
			in_vector  : in  std_logic_vector(INPUT_BITS-1 downto 0);
			out_vector : out std_logic_vector(INPUT_BITS-1 downto 0)
		);
	end component;

	signal andGateInputs  : std_logic_matrix((2**SELECT_BITS)-1 downto 0)(SELECT_BITS-1 downto 0);
	signal andGateOutputs : std_logic_matrix((2**SELECT_BITS)-1 downto 0)(INPUT_BITS-1 downto 0);
	signal orGateOutputs  : std_logic_matrix((2**SELECT_BITS)-2 downto 0)(INPUT_BITS-1 downto 0);
	signal selectNot      : std_logic_vector(SELECT_BITS-1 downto 0);

begin

	-- Calculate negated selection bits
	genSelectionNotGates:
	for i in SELECT_BITS-1 downto 0 generate
	
		selectNot(i) <= (NOT in_select(i));
	
	end generate genSelectionNotGates;
	
	-- Generate condition assignments for each AND-gate
	genConditionsLines:
	for i in (2**SELECT_BITS)-1 downto 0 generate
	
		genConditionsLines_Inner:
		for j in SELECT_BITS-1 downto 0 generate
		
			genConditionsLines_Default:
			if ((i / (2**j)) mod 2) = 1 generate
				andGateInputs(i)(j) <= in_select(j);
			end generate genConditionsLines_Default;
			
			genConditionsLines_Negated:
			if ((i / (2**j)) mod 2) = 0 generate
				andGateInputs(i)(j) <= selectNot(j);
			end generate genConditionsLines_Negated;
		
		end generate genConditionsLines_Inner;
	end generate genConditionsLines;

	-- For each n-Bit input, generate AND-gate chain for output selection
	genAndGates:
	for i in (2**SELECT_BITS)-1 downto 0 generate
		
		and_n_bit_0 : And_n_Bit
		generic map(
			CONDITIONS => SELECT_BITS,
			INPUT_BITS => INPUT_BITS
		)
		port map(
			in_conds   => andGateInputs(i),
			in_vector  => in_values(i),
			out_vector => andGateOutputs(i)
		);
		
	end generate genAndGates;
	
	-- Merge all outputs through a series of OR-gates
	genOrGates:
	for i in SELECT_BITS-1 downto 0 generate
	
		genOrGatesIfInit:
		if i = SELECT_BITS-1 generate
		
			genOrGatesInit:
			for j in (2**i)-1 downto 0 generate
			
				genOrGateInitBits:
				for k in INPUT_BITS-1 downto 0 generate
					orGateOutputs((2**i) + j - 1)(k) <= (andGateOutputs((2 * j) + 1)(k) OR andGateOutputs(2 * j)(k));
				end generate genOrGateInitBits;
			
			end generate genOrGatesInit;
		
		end generate genOrGatesIfInit;
		
		genOrGatesIfLoop:
		if i < SELECT_BITS-1 generate
			
			genOrGatesLoop:
			for j in (2**i)-1 downto 0 generate
			
				genOrGateLoopBits:
				for k in INPUT_BITS-1 downto 0 generate
					orGateOutputs((2**i) + j - 1)(k) <= (orGateOutputs((2**(i+1)) + (2 * j))(k) OR orGateOutputs((2**(i+1)) + (2 * j) - 1)(k));
				end generate genOrGateLoopBits;
			
			end generate genOrGatesLoop;
			
		end generate genOrGatesIfLoop;
		
	end generate genOrGates;
	
	-- Assign output
	out_value <= orGateOutputs(0);

end arch;
