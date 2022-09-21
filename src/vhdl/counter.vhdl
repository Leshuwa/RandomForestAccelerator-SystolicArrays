library IEEE;
use IEEE.std_logic_1164.all;



--------------------------------------------------------------------------------
--
-- Ripple-Carry-Adder based counter with synchronous reset.
--
--------------------------------------------------------------------------------
--
-- Increases its value by one for each clock tick. Resetting the counter sets
--  its value to zero. Utilises an RCA-like adder to increase the counter value.
-- First clock tick after reset outputs value zero (0).
--
--------------------------------------------------------------------------------
--
-- @in in_clock  - Updates the counter value on rising edge.
-- @in in_enable - While '1', clock ticks increase the counter value.
-- @in in_reset  - Reset the counter output to zero.
--
-- @out out_wrap  - Set to '1' after the counter has wrapped.
-- @out out_value - Counter value, ranging from 0 to 2^(OUTPUT_BITS)-1.
--
-- @complexity    15n + 6    (n = output_bits)
--
--------------------------------------------------------------------------------

entity Counter is
    generic(
        OUTPUT_BITS : integer := 2
    );
    port(
        in_clock  : in  std_logic;
        in_enable : in  std_logic;
        in_reset  : in  std_logic;
        out_wrap  : out std_logic;
        out_value : out std_logic_vector(OUTPUT_BITS-1 downto 0)
    );
end Counter;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of Counter is
    
    component D_Flip_Flop is
        port(
            in_resetNot : in  std_logic;
            in_value    : in  std_logic;
            in_write    : in  std_logic;
            out_value   : out std_logic
        );
    end component;
    
    signal carryBits  : std_logic_vector(OUTPUT_BITS-1 downto 0) := (others => '0');
    signal storedBits : std_logic_vector(OUTPUT_BITS   downto 0) := (others => '0');
    signal sumBits    : std_logic_vector(OUTPUT_BITS   downto 0) := (others => '0');
    
    signal resetNot        : std_logic;
    signal increaseCounter : std_logic;

begin

    -- Link reset-related flags.
    resetNot        <= (NOT (in_reset OR sumBits(OUTPUT_BITS)));
    increaseCounter <= in_enable AND (NOT in_reset);

    -- Generate the RCA-like component that increases counter value by one.
    genCounter:
    for i in 0 to OUTPUT_BITS generate
    
        -- Generate D-Flip-Flop for bit storage
        d_flip_flop_0 : D_Flip_Flop
        port map(
            in_resetNot => resetNot,
            in_value    => sumBits(i),
            in_write    => in_clock,
            out_value   => storedBits(i)
        );
    
        -- Generate the first half-adder
        genHalfAdderInit:
        if (i = 0) generate
        
            carryBits(i) <= (storedBits(i) AND increaseCounter);
            sumBits(i)   <= (storedBits(i) XOR increaseCounter) when rising_edge(in_clock);
            
        end generate;
        
        -- Generate other half-adders
        genHalfAdderLoop:
        if (i > 0 AND i < OUTPUT_BITS) generate
        
            carryBits(i) <= (storedBits(i) AND carryBits(i - 1));
            sumBits(i)   <= (storedBits(i) XOR carryBits(i - 1)) when rising_edge(in_clock);
            
        end generate;
        
        -- Generate final half-adder without carry bit
        genHalfAdderFinal:
        if (i = OUTPUT_BITS) generate
        
            sumBits(i)   <= (storedBits(i) XOR carryBits(i - 1)) when rising_edge(in_clock);
        
        end generate;
    
    end generate;
    
    -- Link output and wrap-flag to stored bit data.
    out_wrap   <= sumBits(OUTPUT_BITS) AND (NOT in_reset);
    out_value  <= storedBits(OUTPUT_BITS-1 downto 0);

end arch;
