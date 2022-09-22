library IEEE;
use IEEE.std_logic_1164.all;



entity Comparator_n_Bit_tb is
end Comparator_n_Bit_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of Comparator_n_Bit_tb is

    component Comparator_n_Bit is
		generic(
			INPUT_BITS : positive
		);
        port(
			in_threshold : in  std_logic_vector(INPUT_BITS-1 downto 0);
			in_value     : in  std_logic_vector(INPUT_BITS-1 downto 0);
			out_equal    : out std_logic;
			out_greater  : out std_logic;
			out_less     : out std_logic
        );
    end component;
	
	signal in_threshold_2_bit : std_logic_vector(1 downto 0);
	signal in_value_2_bit     : std_logic_vector(1 downto 0);
	signal out_equal_2_bit    : std_logic;
	signal out_greater_2_bit  : std_logic;
	signal out_less_2_bit     : std_logic;
	
	signal in_threshold_4_bit : std_logic_vector(3 downto 0);
	signal in_value_4_bit     : std_logic_vector(3 downto 0);
	signal out_equal_4_bit    : std_logic;
	signal out_greater_4_bit  : std_logic;
	signal out_less_4_bit     : std_logic;
	
	signal in_threshold_8_bit : std_logic_vector(7 downto 0);
	signal in_value_8_bit     : std_logic_vector(7 downto 0);
	signal out_equal_8_bit    : std_logic;
	signal out_greater_8_bit  : std_logic;
	signal out_less_8_bit     : std_logic;

begin

    comparator_2_bit : Comparator_n_Bit
	generic map(
		INPUT_BITS => 2
	)
	port map(
        in_threshold => in_threshold_2_bit,
		in_value     => in_value_2_bit,
		out_equal    => out_equal_2_bit,
		out_greater  => out_greater_2_bit,
		out_less     => out_less_2_bit
	);
	
	comparator_4_bit : Comparator_n_Bit
	generic map(
		INPUT_BITS => 4
	)
	port map(
        in_threshold => in_threshold_4_bit,
		in_value     => in_value_4_bit,
		out_equal    => out_equal_4_bit,
		out_greater  => out_greater_4_bit,
		out_less     => out_less_4_bit
	);
	
	comparator_8_bit : Comparator_n_Bit
	generic map(
		INPUT_BITS => 8
	)
	port map(
        in_threshold => in_threshold_8_bit,
		in_value     => in_value_8_bit,
		out_equal    => out_equal_8_bit,
		out_greater  => out_greater_8_bit,
		out_less     => out_less_8_bit
	);

    process begin

		----------------------------------
		--  Tests for 2-Bit comparator  --
		----------------------------------
		
        in_threshold_2_bit <= "00";
		in_value_2_bit     <= "00";
		wait for 1 ns;
        assert (out_greater_2_bit = '0') AND (out_equal_2_bit = '1') AND (out_less_2_bit = '0')
	     report "Error: 0x10"
         severity ERROR;

		in_threshold_2_bit <= "01";
		in_value_2_bit     <= "00";
		wait for 1 ns;
        assert (out_greater_2_bit = '0') AND (out_equal_2_bit = '0') AND (out_less_2_bit = '1')
	     report "Error: 0x11"
         severity ERROR;

		in_threshold_2_bit <= "00";
		in_value_2_bit     <= "01";
		wait for 1 ns;
        assert (out_greater_2_bit = '1') AND (out_equal_2_bit = '0') AND (out_less_2_bit = '0')
	     report "Error: 0x12"
         severity ERROR;

		in_threshold_2_bit <= "11";
		in_value_2_bit     <= "10";
		wait for 1 ns;
        assert (out_greater_2_bit = '0') AND (out_equal_2_bit = '0') AND (out_less_2_bit = '1')
	     report "Error: 0x13"
         severity ERROR;

		in_threshold_2_bit <= "10";
		in_value_2_bit     <= "11";
		wait for 1 ns;
        assert (out_greater_2_bit = '1') AND (out_equal_2_bit = '0') AND (out_less_2_bit = '0')
	     report "Error: 0x14"
         severity ERROR;

		in_threshold_2_bit <= "11";
		in_value_2_bit     <= "11";
		wait for 1 ns;
        assert (out_greater_2_bit = '0') AND (out_equal_2_bit = '1') AND (out_less_2_bit = '0')
	     report "Error: 0x15"
         severity ERROR;
		
		-- Reset and wait until next 10-nanosecond time slot.
		in_threshold_2_bit <= "UU";
		in_value_2_bit     <= "UU";
		wait for 4 ns;
		

		----------------------------------
		--  Tests for 4-Bit comparator  --
		----------------------------------
		
        in_threshold_4_bit <= "0000";
		in_value_4_bit     <= "0000";
		wait for 1 ns;
        assert (out_greater_4_bit = '0') AND (out_equal_4_bit = '1') AND (out_less_4_bit = '0')
	     report "Error: 0x20"
         severity ERROR;

		in_threshold_4_bit <= "0001";
		in_value_4_bit     <= "0000";
		wait for 1 ns;
        assert (out_greater_4_bit = '0') AND (out_equal_4_bit = '0') AND (out_less_4_bit = '1')
	     report "Error: 0x21"
         severity ERROR;

		in_threshold_4_bit <= "0000";
		in_value_4_bit     <= "0001";
		wait for 1 ns;
        assert (out_greater_4_bit = '1') AND (out_equal_4_bit = '0') AND (out_less_4_bit = '0')
	     report "Error: 0x22"
         severity ERROR;

		in_threshold_4_bit <= "1111";
		in_value_4_bit     <= "1110";
		wait for 1 ns;
        assert (out_greater_4_bit = '0') AND (out_equal_4_bit = '0') AND (out_less_4_bit = '1')
	     report "Error: 0x23"
         severity ERROR;

		in_threshold_4_bit <= "1110";
		in_value_4_bit     <= "1111";
		wait for 1 ns;
        assert (out_greater_4_bit = '1') AND (out_equal_4_bit = '0') AND (out_less_4_bit = '0')
	     report "Error: 0x24"
         severity ERROR;

		in_threshold_4_bit <= "1111";
		in_value_4_bit     <= "1111";
		wait for 1 ns;
        assert (out_greater_4_bit = '0') AND (out_equal_4_bit = '1') AND (out_less_4_bit = '0')
	     report "Error: 0x25"
         severity ERROR;

		in_threshold_4_bit <= "0101";
		in_value_4_bit     <= "0110";
		wait for 1 ns;
        assert (out_greater_4_bit = '1') AND (out_equal_4_bit = '0') AND (out_less_4_bit = '0')
	     report "Error: 0x26"
         severity ERROR;

		in_threshold_4_bit <= "1010";
		in_value_4_bit     <= "0110";
		wait for 1 ns;
        assert (out_greater_4_bit = '0') AND (out_equal_4_bit = '0') AND (out_less_4_bit = '1')
	     report "Error: 0x27"
         severity ERROR;
		
		-- Reset and wait until next 10-nanosecond time slot.
		in_threshold_4_bit <= "UUUU";
		in_value_4_bit     <= "UUUU";
		wait for 2 ns;
		

		----------------------------------
		--  Tests for 8-Bit comparator  --
		----------------------------------
		
        in_threshold_8_bit <= "00000000";
		in_value_8_bit     <= "00000000";
		wait for 1 ns;
        assert (out_greater_8_bit = '0') AND (out_equal_8_bit = '1') AND (out_less_8_bit = '0')
	     report "Error: 0x30"
         severity ERROR;

		in_threshold_8_bit <= "00000001";
		in_value_8_bit     <= "00000000";
		wait for 1 ns;
        assert (out_greater_8_bit = '0') AND (out_equal_8_bit = '0') AND (out_less_8_bit = '1')
	     report "Error: 0x31"
         severity ERROR;

		in_threshold_8_bit <= "00000000";
		in_value_8_bit     <= "00000001";
		wait for 1 ns;
        assert (out_greater_8_bit = '1') AND (out_equal_8_bit = '0') AND (out_less_8_bit = '0')
	     report "Error: 0x32"
         severity ERROR;

		in_threshold_8_bit <= "11111111";
		in_value_8_bit     <= "11111110";
		wait for 1 ns;
        assert (out_greater_8_bit = '0') AND (out_equal_8_bit = '0') AND (out_less_8_bit = '1')
	     report "Error: 0x33"
         severity ERROR;

		in_threshold_8_bit <= "11111110";
		in_value_8_bit     <= "11111111";
		wait for 1 ns;
        assert (out_greater_8_bit = '1') AND (out_equal_8_bit = '0') AND (out_less_8_bit = '0')
	     report "Error: 0x34"
         severity ERROR;

		in_threshold_8_bit <= "11111111";
		in_value_8_bit     <= "11111111";
		wait for 1 ns;
        assert (out_greater_8_bit = '0') AND (out_equal_8_bit = '1') AND (out_less_8_bit = '0')
	     report "Error: 0x35"
         severity ERROR;

		in_threshold_8_bit <= "01010101";
		in_value_8_bit     <= "01100110";
		wait for 1 ns;
        assert (out_greater_8_bit = '1') AND (out_equal_8_bit = '0') AND (out_less_8_bit = '0')
	     report "Error: 0x36"
         severity ERROR;

		in_threshold_8_bit <= "10101010";
		in_value_8_bit     <= "01100110";
		wait for 1 ns;
        assert (out_greater_8_bit = '0') AND (out_equal_8_bit = '0') AND (out_less_8_bit = '1')
	     report "Error: 0x37"
         severity ERROR;
		
		-- Reset and wait until next 10-nanosecond time slot.
		in_threshold_8_bit <= "UUUUUUUU";
		in_value_8_bit     <= "UUUUUUUU";
		wait for 2 ns;
		
		wait;
    end process;

end test;
