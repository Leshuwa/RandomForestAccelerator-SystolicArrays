library IEEE;
use IEEE.std_logic_1164.all;



--------------------------------------------------------------------------------
--
-- Compares given input bit against the threshold bit and determines whether
--  it is greater than, equal to, or less than the threshold bit.
--
-- @in in_threshold - Threshold bit to compare against.
-- @in in_value     - Bit to compare.
--
-- @out out_equal   - '1' iff value = threshold; '0' else.
-- @out out_greater - '1' iff value > threshold; '0' else.
-- @out out_less    - '1' iff value < threshold; '0' else.
--
-- @runtimeOwn      4
-- @runtimeTotal    4
--
--------------------------------------------------------------------------------

entity Comparator_1_Bit is
    port(
		in_threshold : in  std_logic;
        in_value     : in  std_logic;
		out_equal    : out std_logic;
		out_greater  : out std_logic;
		out_less     : out std_logic
    );
end Comparator_1_Bit;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of Comparator_1_Bit is

	signal greater : std_logic;
	signal less    : std_logic;

begin

	greater <= (in_value AND (NOT in_threshold));
	less    <= ((NOT in_value) AND in_threshold);
	
	out_equal   <= ((NOT greater) AND (NOT less));
	out_greater <= greater;
	out_less    <= less;

end arch;
