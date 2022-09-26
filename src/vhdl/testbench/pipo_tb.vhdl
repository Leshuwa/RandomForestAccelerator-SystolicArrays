library IEEE;
use IEEE.std_logic_1164.all;



entity Pipo_tb is
end Pipo_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of Pipo_tb is

    component Pipo is
	    generic(
		    INPUT_BITS : positive
	    );
        port(
            in_clock  : in  std_logic;
            in_reset  : in  std_logic;
            in_value  : in  std_logic_vector(INPUT_BITS-1 downto 0);
            out_value : out std_logic_vector(INPUT_BITS-1 downto 0)
        );
    end component;
	
	signal in_clock_4_bit  : std_logic;
    signal in_reset_4_bit  : std_logic;
	signal in_value_4_bit  : std_logic_vector(3 downto 0);
    signal out_value_4_bit : std_logic_vector(3 downto 0);
    
  	signal in_clock_7_bit  : std_logic;
    signal in_reset_7_bit  : std_logic;
	signal in_value_7_bit  : std_logic_vector(6 downto 0);
    signal out_value_7_bit : std_logic_vector(6 downto 0);

begin

    pipo_4_bit : Pipo
    generic map(
        INPUT_BITS => 4
    )
    port map(
        in_clock  => in_clock_4_bit,
        in_reset  => in_reset_4_bit,
        in_value  => in_value_4_bit,
        out_value => out_value_4_bit
    );
    
    pipo_7_bit : Pipo
    generic map(
        INPUT_BITS => 7    
    )
    port map(
        in_clock  => in_clock_7_bit,
        in_reset  => in_reset_7_bit,
        in_value  => in_value_7_bit,
        out_value => out_value_7_bit
    );

    process begin

		----------------------------
		--  Tests for 4-Bit PIPO  --
		----------------------------
		
        in_clock_4_bit <= '1';
        in_reset_4_bit <= '0';
        in_value_4_bit <= "0000";
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_4_bit = "0000")
	     report "Error: 0x10"
         severity ERROR;
		
        in_clock_4_bit <= '1';
        in_reset_4_bit <= '0';
        in_value_4_bit <= "1111";
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_4_bit = "1111")
	     report "Error: 0x11"
         severity ERROR;
		
        in_clock_4_bit <= '1';
        in_reset_4_bit <= '1';
        in_value_4_bit <= "0000";
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_4_bit = "0000")
	     report "Error: 0x12"
         severity ERROR;
		
        in_clock_4_bit <= '1';
        in_reset_4_bit <= '1';
        in_value_4_bit <= "1111";
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_4_bit = "0000")
	     report "Error: 0x13"
         severity ERROR;
		
        in_clock_4_bit <= '1';
        in_reset_4_bit <= '0';
        in_value_4_bit <= "0101";
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_4_bit = "0101")
	     report "Error: 0x14"
         severity ERROR;
		
        in_clock_4_bit <= '1';
        in_reset_4_bit <= '0';
        in_value_4_bit <= "1010";
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_4_bit = "1010")
	     report "Error: 0x15"
         severity ERROR;
		
        in_clock_4_bit <= '1';
        in_reset_4_bit <= '0';
        in_value_4_bit <= "1100";
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_4_bit = "1100")
	     report "Error: 0x16"
         severity ERROR;
		
        in_clock_4_bit <= '1';
        in_reset_4_bit <= '0';
        in_value_4_bit <= "0011";
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_4_bit = "0011")
	     report "Error: 0x17"
         severity ERROR;
		
		-- Reset and wait until next 10-nanosecond time slot.
        in_clock_4_bit <= 'U';
        in_reset_4_bit <= 'U';
        in_value_4_bit <= "UUUU";
		wait for 3 ns;
		

		----------------------------
		--  Tests for 7-Bit PIPO  --
		----------------------------
		
        in_clock_7_bit <= '1';
        in_reset_7_bit <= '0';
        in_value_7_bit <= "0000000";
		wait for 0.5 ns;
		in_clock_7_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_7_bit = "0000000")
	     report "Error: 0x20"
         severity ERROR;
		
        in_clock_7_bit <= '1';
        in_reset_7_bit <= '0';
        in_value_7_bit <= "1111111";
		wait for 0.5 ns;
		in_clock_7_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_7_bit = "1111111")
	     report "Error: 0x21"
         severity ERROR;
		
        in_clock_7_bit <= '1';
        in_reset_7_bit <= '1';
        in_value_7_bit <= "0000000";
		wait for 0.5 ns;
		in_clock_7_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_7_bit = "0000000")
	     report "Error: 0x22"
         severity ERROR;
		
        in_clock_7_bit <= '1';
        in_reset_7_bit <= '1';
        in_value_7_bit <= "1111111";
		wait for 0.5 ns;
		in_clock_7_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_7_bit = "0000000")
	     report "Error: 0x23"
         severity ERROR;
		
        in_clock_7_bit <= '1';
        in_reset_7_bit <= '0';
        in_value_7_bit <= "1010101";
		wait for 0.5 ns;
		in_clock_7_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_7_bit = "1010101")
	     report "Error: 0x24"
         severity ERROR;
		
        in_clock_7_bit <= '1';
        in_reset_7_bit <= '0';
        in_value_7_bit <= "0101010";
		wait for 0.5 ns;
		in_clock_7_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_7_bit = "0101010")
	     report "Error: 0x25"
         severity ERROR;
		
        in_clock_7_bit <= '1';
        in_reset_7_bit <= '0';
        in_value_7_bit <= "1001001";
		wait for 0.5 ns;
		in_clock_7_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_7_bit = "1001001")
	     report "Error: 0x26"
         severity ERROR;
		
        in_clock_7_bit <= '1';
        in_reset_7_bit <= '0';
        in_value_7_bit <= "0100101";
		wait for 0.5 ns;
		in_clock_7_bit <= '0';
		wait for 0.5 ns;
        assert (out_value_7_bit = "0100101")
	     report "Error: 0x27"
         severity ERROR;
		
		-- Reset and wait until next 10-nanosecond time slot.
        in_clock_7_bit <= 'U';
        in_reset_7_bit <= 'U';
        in_value_7_bit <= "UUUUUUU";
		wait for 3 ns;
		
		wait;
    end process;

end test;
