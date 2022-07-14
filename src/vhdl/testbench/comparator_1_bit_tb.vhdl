library IEEE;
use IEEE.std_logic_1164.all;



entity Comparator_1_Bit_tb is
end Comparator_1_Bit_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of Comparator_1_Bit_tb is

    component Comparator_1_Bit is
		port(
			in_threshold : in  std_logic;
			in_value     : in  std_logic;
			out_equal    : out std_logic;
			out_greater  : out std_logic;
			out_less     : out std_logic
		);
	end component;
	
	signal in_value     : std_logic;
	signal in_threshold : std_logic;
	signal out_equal    : std_logic;
	signal out_greater  : std_logic;
	signal out_less     : std_logic;

begin

    comparator0 : Comparator_1_Bit
	port map(
        in_threshold => in_threshold,
		in_value     => in_value,
		out_equal    => out_equal,
		out_greater  => out_greater,
		out_less     => out_less
	);

    process begin

        in_value     <= '0';
		in_threshold <= '0';
		wait for 1 ns;
        assert (out_greater = '0') AND (out_equal = '1') AND (out_less = '0')
	     report "Error: 0x01"
         severity ERROR;
		
		in_value     <= '0';
		in_threshold <= '1';
		wait for 1 ns;
        assert (out_greater = '0') AND (out_equal = '0') AND (out_less = '1')
	     report "Error: 0x02"
         severity ERROR;
		
		in_value     <= '1';
		in_threshold <= '1';
		wait for 1 ns;
        assert (out_greater = '0') AND (out_equal = '1') AND (out_less = '0')
	     report "Error: 0x03"
         severity ERROR;
		
		in_value     <= '1';
		in_threshold <= '0';
		wait for 1 ns;
        assert (out_greater = '1') AND (out_equal = '0') AND (out_less = '0')
	     report "Error: 0x04"
         severity ERROR;
		
		wait;
    end process;

end test;