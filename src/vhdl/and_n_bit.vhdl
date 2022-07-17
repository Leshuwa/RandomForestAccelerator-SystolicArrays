library IEEE;
use IEEE.std_logic_1164.all;



--------------------------------------------------------------------------------
--
-- Large AND-gate supporting n-Bit input that depends on two 1-Bit flags.
--
-- @in in_cond0  - First condition bit.
-- @in in_cond1  - Second condition bit.
-- @in in_vector - Input bit array.
--
-- @out out_vector - Output bit array.
--
-- @complexity    n + 1
-- @runtime       2
--
--------------------------------------------------------------------------------

entity And_n_Bit is
	generic(
		INPUT_BITS : integer := 4
	);
    port(
		in_cond0   : in  std_logic;
		in_cond1   : in  std_logic;
        in_vector  : in  std_logic_vector(INPUT_BITS-1 downto 0);
		out_vector : out std_logic_vector(INPUT_BITS-1 downto 0)
    );
end And_n_Bit;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of And_n_Bit is

	signal enable : std_logic;

begin

	-- Determine enable-signal from input conditions
	enable <= (in_cond0 AND in_cond1);

	-- Generate AND-gates for vector components
	genGates:
	for i in INPUT_BITS-1 downto 0 generate
		
		out_vector(i) <= (in_vector(i) AND enable);
		
	end generate genGates;

end arch;
