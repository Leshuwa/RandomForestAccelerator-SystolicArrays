library IEEE;
use IEEE.std_logic_1164.all;



entity D_Flip_Flop_tb is
end D_Flip_Flop_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of D_Flip_Flop_tb is

    component D_Flip_Flop is
        port(
            in_resetNot : in  std_logic;
            in_value    : in  std_logic;
            in_write    : in  std_logic;
            out_value   : out std_logic
        );
    end component;
    
    signal in_resetNot : std_logic;
    signal in_value    : std_logic;
    signal in_write    : std_logic;
    signal out_value   : std_logic;

begin

    d_flip_flop_0 : D_Flip_Flop
    port map(
        in_resetNot => in_resetNot,
        in_value    => in_value,
        in_write    => in_write,
        out_value   => out_value
    );
    
    process begin
    
        -- Default value
        in_resetNot <= '0';
        in_value    <= '0';
        in_write    <= '1';
        wait for 0.5 ns;
        in_write    <= '0';
        wait for 0.5 ns;
        assert (out_value = '0')
         report "Error: 0x10"
         severity ERROR;
        
        -- Storing '1' and '0'
        in_resetNot <= '1';
        in_value    <= '1';
        in_write    <= '1';
        wait for 0.5 ns;
        in_write    <= '0';
        wait for 0.5 ns;
        assert (out_value = '1')
         report "Error: 0x20"
         severity ERROR;
        
        in_resetNot <= '1';
        in_value    <= '0';
        in_write    <= '1';
        wait for 0.5 ns;
        in_write    <= '0';
        wait for 0.5 ns;
        assert (out_value = '0')
         report "Error: 0x21"
         severity ERROR;
        
        -- Trying to store bit while write is '0'
        in_resetNot <= '1';
        in_value    <= '1';
        in_write    <= '0';
        wait for 0.5 ns;
        in_write    <= '0';
        wait for 0.5 ns;
        assert (out_value = '0')
         report "Error: 0x30"
         severity ERROR;
        
        in_resetNot <= '1';
        in_value    <= '1';
        in_write    <= '1';
        wait for 0.5 ns;
        in_write    <= '0';
        wait for 0.5 ns;
        assert (out_value = '1')
         report "Error: 0x31"
         severity ERROR;
        
        in_resetNot <= '1';
        in_value    <= '0';
        in_write    <= '0';
        wait for 0.5 ns;
        in_write    <= '0';
        wait for 0.5 ns;
        assert (out_value = '1')
         report "Error: 0x32"
         severity ERROR;
        
        -- Synchronous reset
        in_resetNot <= '0';
        in_value    <= '1';
        in_write    <= '0';
        wait for 1.0 ns;
        assert (out_value = '1')
         report "Error: 0x40"
         severity ERROR;
        
        -- Reset while input is set (overrides input bit)
        in_resetNot <= '0';
        in_value    <= '1';
        in_write    <= '1';
        wait for 0.5 ns;
        in_write    <= '0';
        wait for 0.5 ns;
        assert (out_value = '0')
         report "Error: 0x41"
         severity ERROR;
    
        wait;
    end process;

end test;
