library IEEE;
use IEEE.math_real.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

library work;
use work.rf_types.all;



entity Mux_n_Bit_tb is
end Mux_n_Bit_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of Mux_n_Bit_tb is

	component Mux_n_Bit is
		generic(
			INPUT_BITS  : integer := 4;
			SELECT_BITS : integer := 2
		);
		port(
			in_select  : in  std_logic_vector(SELECT_BITS-1 downto 0);
			in_values  : in  std_logic_matrix((2**SELECT_BITS)-1 downto 0)(INPUT_BITS-1 downto 0);
			out_value  : out std_logic_vector(INPUT_BITS-1 downto 0)
		);
	end component;
	
	-- 1-Bit selection with 4-Bit inputs
	signal in_select_4i_1s : std_logic_vector(0 downto 0);
	signal in_values_4i_1s : std_logic_matrix(1 downto 0)(3 downto 0);
	signal out_value_4i_1s : std_logic_vector(3 downto 0);
	
	-- 2-Bit selection with 4-Bit inputs
	signal in_select_4i_2s : std_logic_vector(1 downto 0);
	signal in_values_4i_2s : std_logic_matrix(3 downto 0)(3 downto 0);
	signal out_value_4i_2s : std_logic_vector(3 downto 0);
	
	-- 2-Bit selection with 5-Bit inputs
	signal in_select_5i_2s : std_logic_vector(1 downto 0);
	signal in_values_5i_2s : std_logic_matrix(3 downto 0)(4 downto 0);
	signal out_value_5i_2s : std_logic_vector(4 downto 0);
	
	-- 5-Bit selection with 8-Bit inputs
	signal in_select_8i_5s : std_logic_vector(4 downto 0);
	signal in_values_8i_5s : std_logic_matrix(31 downto 0)(7 downto 0);
	signal out_value_8i_5s : std_logic_vector(7 downto 0);

begin

	mux_4i_1s : Mux_n_Bit
	generic map(
		INPUT_BITS  => 4,
		SELECT_BITS => 1
	)
	port map(
        in_select => in_select_4i_1s,
		in_values => in_values_4i_1s,
		out_value => out_value_4i_1s
	);
	
	mux_4i_2s : Mux_n_Bit
	generic map(
		INPUT_BITS  => 4,
		SELECT_BITS => 2
	)
	port map(
        in_select => in_select_4i_2s,
		in_values => in_values_4i_2s,
		out_value => out_value_4i_2s
	);
	
	mux_5i_2s : Mux_n_Bit
	generic map(
		INPUT_BITS  => 5,
		SELECT_BITS => 2
	)
	port map(
        in_select => in_select_5i_2s,
		in_values => in_values_5i_2s,
		out_value => out_value_5i_2s
	);
	
	mux_8i_5s : Mux_n_Bit
	generic map(
		INPUT_BITS  => 8,
		SELECT_BITS => 5
	)
	port map(
        in_select => in_select_8i_5s,
		in_values => in_values_8i_5s,
		out_value => out_value_8i_5s
	);
	
	process
	
		-- RNG variables
		variable ran      : real;
		variable ranInt   : integer range 0 to 256;
		variable ranSeed1 : positive := 69;
		variable ranSeed2 : positive := 420;
	
	begin

		------------------------------------------
		--  Tests for MUX with 1-Bit selection  --
		------------------------------------------
			
        in_select_4i_1s    <= "0";
		in_values_4i_1s(0) <= "0000";
		in_values_4i_1s(1) <= "0000";
		wait for 1 ns;
        assert (out_value_4i_1s = "0000")
	     report "Error: 0x10"
         severity ERROR;
		
		in_select_4i_1s    <= "0";
		in_values_4i_1s(0) <= "1101";
		in_values_4i_1s(1) <= "0101";
		wait for 1 ns;
        assert (out_value_4i_1s = "1101")
	     report "Error: 0x11"
         severity ERROR;
		
		in_select_4i_1s    <= "1";
		in_values_4i_1s(0) <= "1101";
		in_values_4i_1s(1) <= "0101";
		wait for 1 ns;
        assert (out_value_4i_1s = "0101")
	     report "Error: 0x12"
         severity ERROR;
		
		in_select_4i_1s    <= "1";
		in_values_4i_1s(0) <= "1101";
		in_values_4i_1s(1) <= "1001";
		wait for 1 ns;
        assert (out_value_4i_1s = "1001")
	     report "Error: 0x13"
         severity ERROR;
		
		in_select_4i_1s    <= "0";
		in_values_4i_1s(0) <= "1101";
		in_values_4i_1s(1) <= "1001";
		wait for 1 ns;
        assert (out_value_4i_1s = "1101")
	     report "Error: 0x14"
         severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_select_4i_1s <= "U";
		for i in 1 downto 0 loop
			in_values_4i_1s(i) <= "UUUU";
		end loop;
		wait for 5 ns;


		------------------------------------------
		--  Tests for MUX with 2-Bit selection  --
		------------------------------------------
			
        in_select_4i_2s    <= "00";
		in_values_4i_2s(0) <= "0000";
		in_values_4i_2s(1) <= "0000";
		in_values_4i_2s(2) <= "0000";
		in_values_4i_2s(3) <= "0000";
		wait for 1 ns;
        assert (out_value_4i_2s = "0000")
	     report "Error: 0x20"
		 severity ERROR;
			
        in_select_4i_2s    <= "00";
		in_values_4i_2s(0) <= "1001";
		in_values_4i_2s(1) <= "0110";
		in_values_4i_2s(2) <= "0100";
		in_values_4i_2s(3) <= "0011";
		wait for 1 ns;
        assert (out_value_4i_2s = "1001")
	     report "Error: 0x21"
		 severity ERROR;
			
        in_select_4i_2s    <= "01";
		in_values_4i_2s(0) <= "1001";
		in_values_4i_2s(1) <= "0110";
		in_values_4i_2s(2) <= "0100";
		in_values_4i_2s(3) <= "0011";
		wait for 1 ns;
        assert (out_value_4i_2s = "0110")
	     report "Error: 0x22"
		 severity ERROR;
			
        in_select_4i_2s    <= "10";
		in_values_4i_2s(0) <= "1001";
		in_values_4i_2s(1) <= "0110";
		in_values_4i_2s(2) <= "0100";
		in_values_4i_2s(3) <= "0011";
		wait for 1 ns;
        assert (out_value_4i_2s = "0100")
	     report "Error: 0x23"
		 severity ERROR;
			
        in_select_4i_2s    <= "11";
		in_values_4i_2s(0) <= "1001";
		in_values_4i_2s(1) <= "0110";
		in_values_4i_2s(2) <= "0100";
		in_values_4i_2s(3) <= "0011";
		wait for 1 ns;
        assert (out_value_4i_2s = "0011")
	     report "Error: 0x24"
		 severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_select_4i_2s <= "UU";
		for i in 3 downto 0 loop
			in_values_4i_2s(i) <= "UUUU";
		end loop;
		wait for 5 ns;


		------------------------------------------
		--  Tests for MUX with 2-Bit selection  --
		------------------------------------------
			
        in_select_5i_2s    <= "00";
		in_values_5i_2s(0) <= "11111";
		in_values_5i_2s(1) <= "00110";
		in_values_5i_2s(2) <= "01011";
		in_values_5i_2s(3) <= "10010";
		wait for 1 ns;
        assert (out_value_5i_2s = "11111")
	     report "Error: 0x30"
		 severity ERROR;
			
        in_select_5i_2s    <= "01";
		in_values_5i_2s(0) <= "11111";
		in_values_5i_2s(1) <= "00110";
		in_values_5i_2s(2) <= "01011";
		in_values_5i_2s(3) <= "10010";
		wait for 1 ns;
        assert (out_value_5i_2s = "00110")
	     report "Error: 0x31"
		 severity ERROR;
			
        in_select_5i_2s    <= "10";
		in_values_5i_2s(0) <= "11111";
		in_values_5i_2s(1) <= "00110";
		in_values_5i_2s(2) <= "01011";
		in_values_5i_2s(3) <= "10010";
		wait for 1 ns;
        assert (out_value_5i_2s = "01011")
	     report "Error: 0x32"
		 severity ERROR;
			
        in_select_5i_2s    <= "11";
		in_values_5i_2s(0) <= "11111";
		in_values_5i_2s(1) <= "00110";
		in_values_5i_2s(2) <= "01011";
		in_values_5i_2s(3) <= "10010";
		wait for 1 ns;
        assert (out_value_5i_2s = "10010")
	     report "Error: 0x33"
		 severity ERROR;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_select_5i_2s <= "UU";
		for i in 3 downto 0 loop
			in_values_5i_2s(i) <= "UUUUU";
		end loop;
		wait for 6 ns;


		------------------------------------------
		--  Tests for MUX with 5-Bit selection  --
		------------------------------------------
		
		-- Populate 8-Bit inputs with random values.
		in_select_8i_5s <= "00000";
		for i in 0 to 31 loop
			uniform(ranSeed1, ranSeed2, ran);
			ranInt := integer(trunc(ran * real(2**8)));
			in_values_8i_5s(i) <= std_logic_vector(to_unsigned(ranInt, 8));
		end loop;
		
		-- Assert selection of input X yields the same output.
		for i in 0 to 31 loop
			in_select_8i_5s <= std_logic_vector(to_unsigned(i, 5));
			wait for 1 ns;
			assert (out_value_8i_5s = in_values_8i_5s(i))
			 report "Error: 0x" & integer'image(40 + i) & " (in=" & to_string(in_values_8i_5s(i)) & " out=" & to_string(out_value_8i_5s) & ")"
			 severity ERROR;
		end loop;
		
		-- Reset inputs and wait until next 10-nanosecond time slot.
		in_select_8i_5s <= "UUUUU";
		for i in 31 downto 0 loop
			in_values_8i_5s(i) <= "UUUUUUUU";
		end loop;
		wait for 8 ns;
		
		wait;
	end process;

end test;