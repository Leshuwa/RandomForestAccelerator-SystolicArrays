library IEEE;
use IEEE.std_logic_1164.all;



--------------------------------------------------------------------------------
--
-- Compares input values (features and thresholds) and decides whether the
--  value is greater than the threshold.
--
-- @in in_threshold - n-Bit threshold to compare against.
-- @in in_value     - n-Bit value to compare.
--
-- @out out_equal   - '1' iff value = threshold; '0' else.
-- @out out_greater - '1' iff value > threshold; '0' else.
-- @out out_less    - '1' iff value < threshold; '0' else.
--
-- @runtimeOwn      5 * (n - 1)
-- @runtimeTotal    9n - 5  =  (n * (4)) + (5 * (n - 1))
--
--------------------------------------------------------------------------------

entity Comparator_n_Bit is
	generic(
		INPUT_BITS : integer := 4
	);
    port(
        in_threshold : in  std_logic_vector(INPUT_BITS-1 downto 0);
        in_value     : in  std_logic_vector(INPUT_BITS-1 downto 0);
		out_equal    : out std_logic;
		out_greater  : out std_logic;
		out_less     : out std_logic
    );
end Comparator_n_Bit;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of Comparator_n_Bit is

	component Comparator_1_bit is
		port(
			in_threshold : in  std_logic;
			in_value     : in  std_logic;
			out_equal    : out std_logic;
			out_greater  : out std_logic;
			out_less     : out std_logic
		);
	end component;
	
	-- Signals connecting comparator outputs with their enabling AND-gates
	signal comparatorBitsEqual   : std_logic_vector(INPUT_BITS-1 downto 0);
	signal comparatorBitsGreater : std_logic_vector(INPUT_BITS-1 downto 0);
	signal comparatorBitsLess    : std_logic_vector(INPUT_BITS-1 downto 0);
	
	-- Signals connecting (enabled) AND-gate outputs with OR-gate inputs
	signal enabledBitsEqual   : std_logic_vector(INPUT_BITS-1 downto 0);
	signal enabledBitsGreater : std_logic_vector(INPUT_BITS-1 downto 0);
	signal enabledBitsLess    : std_logic_vector(INPUT_BITS-1 downto 0);
	
	-- Signals connecting bit components with each other
	signal resultBitsEqual   : std_logic_vector(INPUT_BITS-1 downto 0);
	signal resultBitsGreater : std_logic_vector(INPUT_BITS-1 downto 0);
	signal resultBitsLess    : std_logic_vector(INPUT_BITS-1 downto 0);

begin

	-- Generate bit components (i.e. 1-Bit comparator plus AND-/ OR-gates)
	genComparators:
	for i in INPUT_BITS-1 downto 0 generate
		
		-- Put 1-Bit comparator
		comparator_1_bit_0 : Comparator_1_bit
		port map(
			in_threshold => in_threshold(i),
			in_value     => in_value(i),
			out_equal    => comparatorBitsEqual(i),
			out_greater  => comparatorBitsGreater(i),
			out_less     => comparatorBitsLess(i)
		);
		
		-- Conjugate comparator outputs with enable-bit (previous equals-bit)
		genEnablersInit:
		if (i = INPUT_BITS-1) generate
			enabledBitsEqual(i)   <= comparatorBitsEqual(i);
			enabledBitsGreater(i) <= comparatorBitsGreater(i);
			enabledBitsLess(i)    <= comparatorBitsLess(i);
		end generate;
		
		genEnablersLoop:
		if (i < INPUT_BITS-1) generate
			enabledBitsEqual(i)   <= (resultBitsEqual(i + 1) AND comparatorBitsEqual(i));
			enabledBitsGreater(i) <= (resultBitsEqual(i + 1) AND comparatorBitsGreater(i));
			enabledBitsLess(i)    <= (resultBitsEqual(i + 1) AND comparatorBitsLess(i));
		end generate;
		
		-- Set result bits
		genResultsInit:
		if (i = INPUT_BITS-1) generate
			resultBitsEqual(i)   <= enabledBitsEqual(i);
			resultBitsGreater(i) <= enabledBitsGreater(i);
			resultBitsLess(i)    <= enabledBitsLess(i);
		end generate;
		
		genResultsLoop:
		if (i < INPUT_BITS-1) generate
			resultBitsEqual(i)   <= enabledBitsEqual(i);
			resultBitsGreater(i) <= (resultBitsGreater(i + 1) OR enabledBitsGreater(i));
			resultBitsLess(i)    <= (resultBitsLess(i + 1)    OR enabledBitsLess(i));
		end generate;
		
	end generate genComparators;
	
	-- Assign result bits to output.
	out_equal   <= resultBitsEqual(0);
	out_greater <= resultBitsGreater(0);
	out_less    <= resultBitsLess(0);

end arch;
