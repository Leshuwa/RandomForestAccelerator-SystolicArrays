library IEEE;
use IEEE.std_logic_1164.all;



entity And_n_Bit_tb is
end And_n_Bit_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of And_n_Bit_tb is

    component And_n_Bit is
		generic(
			INPUT_BITS : integer := 4
		);
		port(
			in_cond0   : in  std_logic;
			in_cond1   : in  std_logic;
			in_vector  : in  std_logic_vector(INPUT_BITS-1 downto 0);
			out_vector : out std_logic_vector(INPUT_BITS-1 downto 0)
		);
	end component;
	
	signal in_cond0_2_bit   : std_logic;
	signal in_cond1_2_bit   : std_logic;
	signal in_vector_2_bit  : std_logic_vector(1 downto 0);
	signal out_vector_2_bit : std_logic_vector(1 downto 0);
	
	signal in_cond0_4_bit   : std_logic;
	signal in_cond1_4_bit   : std_logic;
	signal in_vector_4_bit  : std_logic_vector(3 downto 0);
	signal out_vector_4_bit : std_logic_vector(3 downto 0);
	
	signal in_cond0_8_bit   : std_logic;
	signal in_cond1_8_bit   : std_logic;
	signal in_vector_8_bit  : std_logic_vector(7 downto 0);
	signal out_vector_8_bit : std_logic_vector(7 downto 0);

begin

    and_2_bit : And_n_Bit
	generic map(
		INPUT_BITS => 2
	)
	port map(
        in_cond0   => in_cond0_2_bit,
		in_cond1   => in_cond1_2_bit,
		in_vector  => in_vector_2_bit,
		out_vector => out_vector_2_bit
	);
	
	and_4_bit : And_n_Bit
	generic map(
		INPUT_BITS => 4
	)
	port map(
        in_cond0   => in_cond0_4_bit,
		in_cond1   => in_cond1_4_bit,
		in_vector  => in_vector_4_bit,
		out_vector => out_vector_4_bit
	);
	
	and_8_bit : And_n_Bit
	generic map(
		INPUT_BITS => 8
	)
	port map(
        in_cond0   => in_cond0_8_bit,
		in_cond1   => in_cond1_8_bit,
		in_vector  => in_vector_8_bit,
		out_vector => out_vector_8_bit
	);

    process begin

		--------------------------------
		--  Tests for 2-Bit AND-gate  --
		--------------------------------
		
        in_cond0_2_bit  <= '0';
		in_cond1_2_bit  <= '0';
		in_vector_2_bit <= "00";
		wait for 1 ns;
        assert (out_vector_2_bit = "00")
	     report "Error: 0x10"
         severity ERROR;

		in_cond0_2_bit  <= '0';
		in_cond1_2_bit  <= '0';
		in_vector_2_bit <= "11";
		wait for 1 ns;
        assert (out_vector_2_bit = "00")
	     report "Error: 0x11"
         severity ERROR;

		in_cond0_2_bit  <= '1';
		in_cond1_2_bit  <= '0';
		in_vector_2_bit <= "11";
		wait for 1 ns;
        assert (out_vector_2_bit = "00")
	     report "Error: 0x12"
         severity ERROR;

		in_cond0_2_bit  <= '0';
		in_cond1_2_bit  <= '1';
		in_vector_2_bit <= "11";
		wait for 1 ns;
        assert (out_vector_2_bit = "00")
	     report "Error: 0x13"
         severity ERROR;

		in_cond0_2_bit  <= '1';
		in_cond1_2_bit  <= '1';
		in_vector_2_bit <= "11";
		wait for 1 ns;
        assert (out_vector_2_bit = "11")
	     report "Error: 0x14"
         severity ERROR;

		in_cond0_2_bit  <= '1';
		in_cond1_2_bit  <= '1';
		in_vector_2_bit <= "01";
		wait for 1 ns;
        assert (out_vector_2_bit = "01")
	     report "Error: 0x15"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_cond0_2_bit  <= 'U';
		in_cond1_2_bit  <= 'U';
		in_vector_2_bit <= "UU";
		wait for 4 ns;
		
		
		--------------------------------
		--  Tests for 4-Bit AND-gate  --
		--------------------------------
		
        in_cond0_4_bit  <= '0';
		in_cond1_4_bit  <= '0';
		in_vector_4_bit <= "0000";
		wait for 1 ns;
        assert (out_vector_4_bit = "0000")
	     report "Error: 0x10"
         severity ERROR;

		in_cond0_4_bit  <= '0';
		in_cond1_4_bit  <= '0';
		in_vector_4_bit <= "1111";
		wait for 1 ns;
        assert (out_vector_4_bit = "0000")
	     report "Error: 0x11"
         severity ERROR;

		in_cond0_4_bit  <= '1';
		in_cond1_4_bit  <= '0';
		in_vector_4_bit <= "1111";
		wait for 1 ns;
        assert (out_vector_4_bit = "0000")
	     report "Error: 0x12"
         severity ERROR;

		in_cond0_4_bit  <= '0';
		in_cond1_4_bit  <= '1';
		in_vector_4_bit <= "1111";
		wait for 1 ns;
        assert (out_vector_4_bit = "0000")
	     report "Error: 0x13"
         severity ERROR;

		in_cond0_4_bit  <= '1';
		in_cond1_4_bit  <= '1';
		in_vector_4_bit <= "1111";
		wait for 1 ns;
        assert (out_vector_4_bit = "1111")
	     report "Error: 0x14"
         severity ERROR;

		in_cond0_4_bit  <= '1';
		in_cond1_4_bit  <= '1';
		in_vector_4_bit <= "0101";
		wait for 1 ns;
        assert (out_vector_4_bit = "0101")
	     report "Error: 0x15"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_cond0_4_bit  <= 'U';
		in_cond1_4_bit  <= 'U';
		in_vector_4_bit <= "UUUU";
		wait for 4 ns;
		
		
		--------------------------------
		--  Tests for 8-Bit AND-gate  --
		--------------------------------
		
        in_cond0_8_bit  <= '0';
		in_cond1_8_bit  <= '0';
		in_vector_8_bit <= "00000000";
		wait for 1 ns;
        assert (out_vector_8_bit = "00000000")
	     report "Error: 0x10"
         severity ERROR;

		in_cond0_8_bit  <= '0';
		in_cond1_8_bit  <= '0';
		in_vector_8_bit <= "11111111";
		wait for 1 ns;
        assert (out_vector_8_bit = "00000000")
	     report "Error: 0x11"
         severity ERROR;

		in_cond0_8_bit  <= '1';
		in_cond1_8_bit  <= '0';
		in_vector_8_bit <= "11111111";
		wait for 1 ns;
        assert (out_vector_8_bit = "00000000")
	     report "Error: 0x12"
         severity ERROR;

		in_cond0_8_bit  <= '0';
		in_cond1_8_bit  <= '1';
		in_vector_8_bit <= "11111111";
		wait for 1 ns;
        assert (out_vector_8_bit = "00000000")
	     report "Error: 0x13"
         severity ERROR;

		in_cond0_8_bit  <= '1';
		in_cond1_8_bit  <= '1';
		in_vector_8_bit <= "11111111";
		wait for 1 ns;
        assert (out_vector_8_bit = "11111111")
	     report "Error: 0x14"
         severity ERROR;

		in_cond0_8_bit  <= '1';
		in_cond1_8_bit  <= '1';
		in_vector_8_bit <= "01010101";
		wait for 1 ns;
        assert (out_vector_8_bit = "01010101")
	     report "Error: 0x15"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_cond0_8_bit  <= 'U';
		in_cond1_8_bit  <= 'U';
		in_vector_8_bit <= "UUUUUUUU";
		wait for 4 ns;
		
		wait;
    end process;

end test;