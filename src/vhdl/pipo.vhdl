library IEEE;
use IEEE.std_logic_1164.all;



--------------------------------------------------------------------------------
--
-- Parallel-in parallel-out (PIPO) register to store an n-Bit value.
--
-- @in in_clock   - Used to trigger value write.
-- @in in_reset   - Synchronous reset.
-- @in in_value   - n-Bit value to store on next clock tick.
--
-- @out out_value - Stored n-Bit value.
--
-- @complexity    10n + 1
-- @runtime       6
--
--------------------------------------------------------------------------------

entity Pipo is
	generic(
		INPUT_BITS : positive
	);
    port(
        in_clock  : in  std_logic;
        in_reset  : in  std_logic;
        in_value  : in  std_logic_vector(INPUT_BITS-1 downto 0);
        out_value : out std_logic_vector(INPUT_BITS-1 downto 0)
    );
end Pipo;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of Pipo is

	component D_Flip_Flop is
        port(
            in_resetNot : in  std_logic;
            in_value    : in  std_logic;
            in_write    : in  std_logic;
            out_value   : out std_logic
        );
    end component;
	
	signal resetNot : std_logic;

begin

    -- Invert in_reset to save a few NOT-gates
    resetNot <= (NOT in_reset);
    
    -- Generate and connect D-FlipFlops
    genFlipFlops:
    for i in INPUT_BITS-1 downto 0 generate
        d_flip_flop_0 : D_Flip_Flop
        port map(
            in_resetNot => resetNot,
            in_value    => in_value(i),
            in_write    => in_clock,
            out_value   => out_value(i)
        );
    end generate;

end arch;
