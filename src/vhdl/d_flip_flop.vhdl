library IEEE;
use IEEE.std_logic_1164.all;



--------------------------------------------------------------------------------
--
-- D-Flip Flop offering one Bit storage with synchronous reset.
--
-- @in in_resetNot - Inverted reset bit; set to '0' to reset the stored gate.
-- @in in_value    - Input value to store.
-- @in in_write    - Write pulse; initiates storage of given input value bit.
--
-- @out out_value - Stored bit value.
--
-- @complexity    10
-- @runtime       5
--
--------------------------------------------------------------------------------

entity D_Flip_Flop is
    port(
        in_resetNot : in  std_logic;
        in_value    : in  std_logic;
        in_write    : in  std_logic;
        out_value   : out std_logic
    );
end D_Flip_Flop;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of D_Flip_Flop is

    signal valueToStore : std_logic;
    signal reset        : std_logic;
    signal set          : std_logic;
    signal storedBit    : std_logic;
    signal storedBitNot : std_logic;

begin

    -- Determine which value to store on write pulse
    valueToStore <= (in_value AND in_resetNot);
    
    -- First NAND-gate layer; determine set and reset bits
    reset <= (in_write AND (NOT valueToStore));
    set   <= (in_write AND valueToStore);

    -- Second NAND-gates; determine stored bit and return as output
    storedBit    <= (reset NOR storedBitNot);
    storedBitNot <= (set NOR storedBit);
    out_value    <= storedBit;

end arch;
