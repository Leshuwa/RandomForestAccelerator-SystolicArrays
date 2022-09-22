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
			CONDITIONS : positive;
			INPUT_BITS : positive
		);
		port(
			in_conds   : in  std_logic_vector(CONDITIONS-1 downto 0);
			in_vector  : in  std_logic_vector(INPUT_BITS-1 downto 0);
			out_vector : out std_logic_vector(INPUT_BITS-1 downto 0)
		);
	end component;
	
	-- 2-Bit inputs
	signal in_conds_1c_2i   : std_logic_vector(0 downto 0);
	signal in_vector_1c_2i  : std_logic_vector(1 downto 0);
	signal out_vector_1c_2i : std_logic_vector(1 downto 0);
	
	-- 4-Bit inputs
	signal in_conds_2c_4i   : std_logic_vector(1 downto 0);
	signal in_vector_2c_4i  : std_logic_vector(3 downto 0);
	signal out_vector_2c_4i : std_logic_vector(3 downto 0);
	
	signal in_conds_3c_4i   : std_logic_vector(2 downto 0);
	signal in_vector_3c_4i  : std_logic_vector(3 downto 0);
	signal out_vector_3c_4i : std_logic_vector(3 downto 0);
	
	-- 8-Bit inputs	
	signal in_conds_5c_8i   : std_logic_vector(4 downto 0);
	signal in_vector_5c_8i  : std_logic_vector(7 downto 0);
	signal out_vector_5c_8i : std_logic_vector(7 downto 0);
	
	signal in_conds_8c_8i   : std_logic_vector(7 downto 0);
	signal in_vector_8c_8i  : std_logic_vector(7 downto 0);
	signal out_vector_8c_8i : std_logic_vector(7 downto 0);

begin

    and_1c_2i : And_n_Bit
	generic map(
		CONDITIONS => 1,
		INPUT_BITS => 2
	)
	port map(
        in_conds   => in_conds_1c_2i,
		in_vector  => in_vector_1c_2i,
		out_vector => out_vector_1c_2i
	);
	
	and_2c_4i : And_n_Bit
	generic map(
		CONDITIONS => 2,
		INPUT_BITS => 4
	)
	port map(
        in_conds   => in_conds_2c_4i,
		in_vector  => in_vector_2c_4i,
		out_vector => out_vector_2c_4i
	);
	
	and_3c_4i : And_n_Bit
	generic map(
		CONDITIONS => 3,
		INPUT_BITS => 4
	)
	port map(
        in_conds   => in_conds_3c_4i,
		in_vector  => in_vector_3c_4i,
		out_vector => out_vector_3c_4i
	);
	
	and_5c_8i : And_n_Bit
	generic map(
		CONDITIONS => 5,
		INPUT_BITS => 8
	)
	port map(
        in_conds   => in_conds_5c_8i,
		in_vector  => in_vector_5c_8i,
		out_vector => out_vector_5c_8i
	);
	
	and_8c_8i : And_n_Bit
	generic map(
		CONDITIONS => 8,
		INPUT_BITS => 8
	)
	port map(
        in_conds   => in_conds_8c_8i,
		in_vector  => in_vector_8c_8i,
		out_vector => out_vector_8c_8i
	);

    process begin

		--------------------------------
		--  Tests for 2-Bit AND-gate  --
		--------------------------------
		
        in_conds_1c_2i  <= "0";
		in_vector_1c_2i <= "00";
		wait for 1 ns;
        assert (out_vector_1c_2i = "00")
	     report "Error: 0x10"
         severity ERROR;

		in_conds_1c_2i  <= "0";
		in_vector_1c_2i <= "11";
		wait for 1 ns;
        assert (out_vector_1c_2i = "00")
	     report "Error: 0x11"
         severity ERROR;
		
		in_conds_1c_2i  <= "1";
		in_vector_1c_2i <= "00";
		wait for 1 ns;
        assert (out_vector_1c_2i = "00")
	     report "Error: 0x12"
         severity ERROR;

		in_conds_1c_2i  <= "1";
		in_vector_1c_2i <= "01";
		wait for 1 ns;
        assert (out_vector_1c_2i = "01")
	     report "Error: 0x13"
         severity ERROR;

		in_conds_1c_2i  <= "1";
		in_vector_1c_2i <= "10";
		wait for 1 ns;
        assert (out_vector_1c_2i = "10")
	     report "Error: 0x14"
         severity ERROR;

		in_conds_1c_2i  <= "1";
		in_vector_1c_2i <= "11";
		wait for 1 ns;
        assert (out_vector_1c_2i = "11")
	     report "Error: 0x15"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_conds_1c_2i  <= "U";
		in_vector_1c_2i <= "UU";
		wait for 4 ns;
		
		
		--------------------------------
		--  Tests for 4-Bit AND-gate  --
		--------------------------------
		
        in_conds_2c_4i  <= "00";
		in_vector_2c_4i <= "1111";
		wait for 1 ns;
        assert (out_vector_2c_4i = "0000")
	     report "Error: 0x20"
         severity ERROR;
		
        in_conds_2c_4i  <= "01";
		in_vector_2c_4i <= "1111";
		wait for 1 ns;
        assert (out_vector_2c_4i = "0000")
	     report "Error: 0x21"
         severity ERROR;
		
        in_conds_2c_4i  <= "10";
		in_vector_2c_4i <= "1111";
		wait for 1 ns;
        assert (out_vector_2c_4i = "0000")
	     report "Error: 0x22"
         severity ERROR;
		
        in_conds_2c_4i  <= "11";
		in_vector_2c_4i <= "1111";
		wait for 1 ns;
        assert (out_vector_2c_4i = "1111")
	     report "Error: 0x23"
         severity ERROR;
		
        in_conds_2c_4i  <= "11";
		in_vector_2c_4i <= "1101";
		wait for 1 ns;
        assert (out_vector_2c_4i = "1101")
	     report "Error: 0x24"
         severity ERROR;
		
        in_conds_2c_4i  <= "11";
		in_vector_2c_4i <= "0010";
		wait for 1 ns;
        assert (out_vector_2c_4i = "0010")
	     report "Error: 0x25"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_conds_2c_4i  <= "UU";
		in_vector_2c_4i <= "UUUU";
		wait for 4 ns;
		
		
        in_conds_3c_4i  <= "000";
		in_vector_3c_4i <= "1101";
		wait for 1 ns;
        assert (out_vector_3c_4i = "0000")
	     report "Error: 0x30"
         severity ERROR;
		
        in_conds_3c_4i  <= "001";
		in_vector_3c_4i <= "1101";
		wait for 1 ns;
        assert (out_vector_3c_4i = "0000")
	     report "Error: 0x31"
         severity ERROR;
		
        in_conds_3c_4i  <= "010";
		in_vector_3c_4i <= "1101";
		wait for 1 ns;
        assert (out_vector_3c_4i = "0000")
	     report "Error: 0x32"
         severity ERROR;
		
        in_conds_3c_4i  <= "011";
		in_vector_3c_4i <= "1101";
		wait for 1 ns;
        assert (out_vector_3c_4i = "0000")
	     report "Error: 0x33"
         severity ERROR;
		
        in_conds_3c_4i  <= "100";
		in_vector_3c_4i <= "1101";
		wait for 1 ns;
        assert (out_vector_3c_4i = "0000")
	     report "Error: 0x34"
         severity ERROR;
		
        in_conds_3c_4i  <= "101";
		in_vector_3c_4i <= "1101";
		wait for 1 ns;
        assert (out_vector_3c_4i = "0000")
	     report "Error: 0x35"
         severity ERROR;
		
        in_conds_3c_4i  <= "111";
		in_vector_3c_4i <= "1101";
		wait for 1 ns;
        assert (out_vector_3c_4i = "1101")
	     report "Error: 0x36"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_conds_3c_4i  <= "UUU";
		in_vector_3c_4i <= "UUUU";
		wait for 3 ns;
		
		
		--------------------------------
		--  Tests for 8-Bit AND-gate  --
		--------------------------------
		
        in_conds_5c_8i  <= "00000";
		in_vector_5c_8i <= "11111111";
		wait for 1 ns;
        assert (out_vector_5c_8i = "00000000")
	     report "Error: 0x40"
         severity ERROR;
		
        in_conds_5c_8i  <= "01010";
		in_vector_5c_8i <= "11111111";
		wait for 1 ns;
        assert (out_vector_5c_8i = "00000000")
	     report "Error: 0x41"
         severity ERROR;
		
        in_conds_5c_8i  <= "10101";
		in_vector_5c_8i <= "11111111";
		wait for 1 ns;
        assert (out_vector_5c_8i = "00000000")
	     report "Error: 0x42"
         severity ERROR;
		
        in_conds_5c_8i  <= "11111";
		in_vector_5c_8i <= "11111111";
		wait for 1 ns;
        assert (out_vector_5c_8i = "11111111")
	     report "Error: 0x43"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_conds_5c_8i  <= "UUUUU";
		in_vector_5c_8i <= "UUUUUUUU";
		wait for 4 ns;
		
		
        in_conds_8c_8i  <= "00000000";
		in_vector_8c_8i <= "11011011";
		wait for 1 ns;
        assert (out_vector_8c_8i = "00000000")
	     report "Error: 0x50"
         severity ERROR;
		
        in_conds_8c_8i  <= "01010101";
		in_vector_8c_8i <= "11011011";
		wait for 1 ns;
        assert (out_vector_8c_8i = "00000000")
	     report "Error: 0x51"
         severity ERROR;
		
        in_conds_8c_8i  <= "10101010";
		in_vector_8c_8i <= "11011011";
		wait for 1 ns;
        assert (out_vector_8c_8i = "00000000")
	     report "Error: 0x52"
         severity ERROR;
		
        in_conds_8c_8i  <= "10011010";
		in_vector_8c_8i <= "11011011";
		wait for 1 ns;
        assert (out_vector_8c_8i = "00000000")
	     report "Error: 0x53"
         severity ERROR;
		
        in_conds_8c_8i  <= "11111111";
		in_vector_8c_8i <= "11011011";
		wait for 1 ns;
        assert (out_vector_8c_8i = "11011011")
	     report "Error: 0x54"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_conds_8c_8i  <= "UUUUUUUU";
		in_vector_8c_8i <= "UUUUUUUU";
		wait for 4 ns;
		
		wait;
    end process;

end test;
