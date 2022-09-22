library IEEE;
use IEEE.std_logic_1164.all;



--------------------------------------------------------------------------------
--
-- Large AND-gate supporting n-Bit inputs that depend on an arbitrary number of
--  1-Bit flags. Outputs the input array iff all condition bits in the condition
--  mask are raised (i.e. set to '1').
--
-- @generic CONDITIONS - Number of one-bit conditions to evaluate.
-- @generic INPUT_BITS - Input bit vector length.
--
-- @in in_cond   - Conditional bit array.
-- @in in_vector - Input bit array.
--
-- @out out_vector - Output bit array.
--
-- @complexity    n + m - 1    (n = input_bits; m = conditions)
-- @runtime       m            (m = conditions)
--
--------------------------------------------------------------------------------

entity And_n_Bit is
	generic(
		CONDITIONS : positive;
		INPUT_BITS : positive
	);
    port(
		in_conds   : in  std_logic_vector(CONDITIONS-1 downto 0);
        in_vector  : in  std_logic_vector(INPUT_BITS-1 downto 0);
		out_vector : out std_logic_vector(INPUT_BITS-1 downto 0)
    );
end And_n_Bit;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of And_n_Bit is

	-- Intermediate result lines from conditions' AND-gates.
	signal andLines : std_logic_vector(CONDITIONS-1 downto 0);

begin

	andLines(CONDITIONS-1) <= in_conds(CONDITIONS-1);
	
	-- Generation of AND-gates for enable-line
	genEnableGates:
	for i in CONDITIONS-2 downto 0 generate
	
		andLines(i) <= (andLines(i+1) AND in_conds(i));
	
	end generate genEnableGates;

	-- Generate AND-gates for vector components
	genVectorGates:
	for i in INPUT_BITS-1 downto 0 generate
		
		out_vector(i) <= (in_vector(i) AND andLines(0));
		
	end generate genVectorGates;

end arch;
