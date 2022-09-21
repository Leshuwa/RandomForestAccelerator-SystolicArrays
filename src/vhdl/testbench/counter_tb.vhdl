library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;



entity Counter_tb is
end Counter_tb;


--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of Counter_tb is

	component Counter is
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
	end component;
	
	-- 1-Bit counter signals
	signal in_clock_1_bit  : std_logic;
	signal in_enable_1_bit : std_logic;
	signal in_reset_1_bit  : std_logic;
	signal out_wrap_1_bit  : std_logic;
	signal out_value_1_bit : std_logic_vector(0 downto 0);
	
	-- 3-Bit counter signals
	signal in_clock_3_bit  : std_logic;
	signal in_enable_3_bit : std_logic;
	signal in_reset_3_bit  : std_logic;
	signal out_wrap_3_bit  : std_logic;
	signal out_value_3_bit : std_logic_vector(2 downto 0);
	
	-- 4-Bit counter signals
	signal in_clock_4_bit  : std_logic;
	signal in_enable_4_bit : std_logic;
	signal in_reset_4_bit  : std_logic;
	signal out_wrap_4_bit  : std_logic;
	signal out_value_4_bit : std_logic_vector(3 downto 0);
	
	-- 8-Bit counter signals
	signal in_clock_8_bit  : std_logic;
	signal in_enable_8_bit : std_logic;
	signal in_reset_8_bit  : std_logic;
	signal out_wrap_8_bit  : std_logic;
	signal out_value_8_bit : std_logic_vector(7 downto 0);

begin

	counter_1_bit : Counter
	generic map(
		OUTPUT_BITS => 1
	)
	port map(
		in_clock  => in_clock_1_bit,
		in_enable => in_enable_1_bit,
		in_reset  => in_reset_1_bit,
		out_wrap  => out_wrap_1_bit,
		out_value => out_value_1_bit
	);
	
	counter_3_bit : Counter
	generic map(
		OUTPUT_BITS => 3
	)
	port map(
		in_clock  => in_clock_3_bit,
		in_enable => in_enable_3_bit,
		in_reset  => in_reset_3_bit,
		out_wrap  => out_wrap_3_bit,
		out_value => out_value_3_bit
	);
	
	counter_4_bit : Counter
	generic map(
		OUTPUT_BITS => 4
	)
	port map(
		in_clock  => in_clock_4_bit,
		in_enable => in_enable_4_bit,
		in_reset  => in_reset_4_bit,
		out_wrap  => out_wrap_4_bit,
		out_value => out_value_4_bit
	);
	
	counter_8_bit : Counter
	generic map(
		OUTPUT_BITS => 8
	)
	port map(
		in_clock  => in_clock_8_bit,
		in_enable => in_enable_8_bit,
		in_reset  => in_reset_8_bit,
		out_wrap  => out_wrap_8_bit,
		out_value => out_value_8_bit
	);
	
	
	------------------------------------
	--  1-Bit counter test procedure  --
	------------------------------------
	
	process
	begin
	
		-- Initialise
		in_clock_1_bit  <= '1';
		in_enable_1_bit <= '1';
		in_reset_1_bit  <= '1';
		wait for 0.5 ns;
		in_clock_1_bit  <= '0';
		wait for 0.5 ns;
        assert (out_wrap_1_bit = '0') AND (out_value_1_bit = "0")
	     report "Error: 0x10 (val=" & to_string(out_value_1_bit) & ", wrap=" & to_string(out_wrap_1_bit) & ")"
         severity ERROR;
		
		-- Increase to maximum
		for i in 0 to 1 loop
		
			in_clock_1_bit <= '1';
			in_reset_1_bit <= '0';
			wait for 0.5 ns;
			in_clock_1_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_1_bit = '0') AND (out_value_1_bit = std_logic_vector(to_unsigned(i, 1)))
			 report "Error: 0x11 (t=" & integer'image(i) & ", val=" & to_string(out_value_1_bit) & ", wrap=" & to_string(out_wrap_1_bit) & ")"
			 severity ERROR;
		
		end loop;
		
		-- Wrap the counter
		in_clock_1_bit <= '1';
		in_reset_1_bit <= '0';
		wait for 0.5 ns;
		in_clock_1_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_1_bit = '1') AND (out_value_1_bit = "0")
	     report "Error: 0x12 (val=" & to_string(out_value_1_bit) & ", wrap=" & to_string(out_wrap_1_bit) & ")"
         severity ERROR;
		
		-- Increase to maximum without prior reset; no wrap
		for i in 1 to 1 loop
		
			in_clock_1_bit <= '1';
			in_reset_1_bit <= '0';
			wait for 0.5 ns;
			in_clock_1_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_1_bit = '0') AND (out_value_1_bit = std_logic_vector(to_unsigned(i, 1)))
			 report "Error: 0x13 (t=" & integer'image(i) & ", val=" & to_string(out_value_1_bit) & ", wrap=" & to_string(out_wrap_1_bit) & ")"
			 severity ERROR;
		
		end loop;
	
		-- Reset while wrapping
		in_clock_1_bit <= '1';
		in_reset_1_bit <= '1';
		wait for 0.5 ns;
		in_clock_1_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_1_bit = '0') AND (out_value_1_bit = "0")
	     report "Error: 0x14 (val=" & to_string(out_value_1_bit) & ", wrap=" & to_string(out_wrap_1_bit) & ")"
         severity ERROR;
	
		-- Extra tick while resetting
		in_clock_1_bit <= '1';
		in_reset_1_bit <= '1';
		wait for 0.5 ns;
		in_clock_1_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_1_bit = '0') AND (out_value_1_bit = "0")
	     report "Error: 0x15 (val=" & to_string(out_value_1_bit) & ", wrap=" & to_string(out_wrap_1_bit) & ")"
         severity ERROR;
		
		-- Unset
		in_clock_1_bit  <= 'U';
		in_enable_1_bit <= 'U';
		in_reset_1_bit  <= 'U';
	
		wait;
	end process;
	
	
	------------------------------------
	--  3-Bit counter test procedure  --
	------------------------------------
	
	process
	begin
	
		-- Wait
		wait for 3 ns;
		
		-- Initialise
		in_clock_3_bit  <= '1';
		in_enable_3_bit <= '1';
		in_reset_3_bit  <= '1';
		wait for 0.5 ns;
		in_clock_3_bit  <= '0';
		wait for 0.5 ns;
        assert (out_wrap_3_bit = '0') AND (out_value_3_bit = "000")
	     report "Error: 0x20 (val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
         severity ERROR;
		
		-- Increase to maximum
		for i in 0 to 7 loop
		
			in_clock_3_bit <= '1';
			in_reset_3_bit <= '0';
			wait for 0.5 ns;
			in_clock_3_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_3_bit = '0') AND (out_value_3_bit = std_logic_vector(to_unsigned(i, 3)))
			 report "Error: 0x21 (t=" & integer'image(i) & ", val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
			 severity ERROR;
		
		end loop;
		
		-- Wrap the counter
		in_clock_3_bit <= '1';
		in_reset_3_bit <= '0';
		wait for 0.5 ns;
		in_clock_3_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_3_bit = '1') AND (out_value_3_bit = "000")
	     report "Error: 0x22 (val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
         severity ERROR;
		
		-- Increase to maximum without prior reset; no wrap
		for i in 1 to 7 loop
		
			in_clock_3_bit <= '1';
			in_reset_3_bit <= '0';
			wait for 0.5 ns;
			in_clock_3_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_3_bit = '0') AND (out_value_3_bit = std_logic_vector(to_unsigned(i, 3)))
			 report "Error: 0x23 (t=" & integer'image(i) & ", val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
			 severity ERROR;
		
		end loop;
		
		-- Reset while wrapping
		in_clock_3_bit <= '1';
		in_reset_3_bit <= '1';
		wait for 0.5 ns;
		in_clock_3_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_3_bit = '0') AND (out_value_3_bit = "000")
	     report "Error: 0x24 (val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
         severity ERROR;
		
		-- Extra tick while resetting
		in_clock_3_bit <= '1';
		in_reset_3_bit <= '1';
		wait for 0.5 ns;
		in_clock_3_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_3_bit = '0') AND (out_value_3_bit = "000")
	     report "Error: 0x25 (val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
         severity ERROR;
		
		-- Increase halfway
		for i in 0 to 4 loop
		
			in_clock_3_bit <= '1';
			in_reset_3_bit <= '0';
			wait for 0.5 ns;
			in_clock_3_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_3_bit = '0') AND (out_value_3_bit = std_logic_vector(to_unsigned(i, 3)))
			 report "Error: 0x26 (t=" & integer'image(i) & ", val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
			 severity ERROR;
		
		end loop;
		
		-- Increasing while not enabled should have no effect
		for i in 0 to 4 loop
		
			in_clock_3_bit  <= '1';
			in_enable_3_bit <= '0';
			in_reset_3_bit  <= '0';
			wait for 0.5 ns;
			in_clock_3_bit  <= '0';
			wait for 0.5 ns;
			assert (out_wrap_3_bit = '0') AND (out_value_3_bit = std_logic_vector(to_unsigned(5, 3)))
			 report "Error: 0x27 (t=" & integer'image(i) & ", val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
			 severity ERROR;
		
		end loop;
		
		-- Reset while not enabled passes
		in_clock_3_bit <= '1';
		in_reset_3_bit <= '1';
		wait for 0.5 ns;
		in_clock_3_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_3_bit = '0') AND (out_value_3_bit = "000")
	     report "Error: 0x28 (val=" & to_string(out_value_3_bit) & ", wrap=" & to_string(out_wrap_3_bit) & ")"
         severity ERROR;
		
		-- Unset
		in_clock_3_bit  <= 'U';
		in_enable_3_bit <= 'U';
		in_reset_3_bit  <= 'U';
	
		wait;
	end process;
	
	
	------------------------------------
	--  4-Bit counter test procedure  --
	------------------------------------
	
	process
	begin
	
		-- Wait
		wait for 4 ns;
	
		-- Initialise
		in_clock_4_bit  <= '1';
		in_enable_4_bit <= '1';
		in_reset_4_bit  <= '1';
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_4_bit = '0') AND (out_value_4_bit = "0000")
	     report "Error: 0x30 (val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
         severity ERROR;
		
		-- Increase to maximum
		for i in 0 to 15 loop
		
			in_clock_4_bit <= '1';
			in_reset_4_bit <= '0';
			wait for 0.5 ns;
			in_clock_4_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_4_bit = '0') AND (out_value_4_bit = std_logic_vector(to_unsigned(i, 4)))
			 report "Error: 0x31 (t=" & integer'image(i) & ", val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
			 severity ERROR;
		
		end loop;
	
		-- Wrap the counter
		in_clock_4_bit <= '1';
		in_reset_4_bit <= '0';
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_4_bit = '1') AND (out_value_4_bit = "0000")
	     report "Error: 0x32 (val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
         severity ERROR;
		
		-- Increase to maximum without prior reset; no wrap
		for i in 1 to 15 loop
		
			in_clock_4_bit <= '1';
			in_reset_4_bit <= '0';
			wait for 0.5 ns;
			in_clock_4_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_4_bit = '0') AND (out_value_4_bit = std_logic_vector(to_unsigned(i, 4)))
			 report "Error: 0x33 (t=" & integer'image(i) & ", val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
			 severity ERROR;
		
		end loop;
	
		-- Reset while wrapping
		in_clock_4_bit <= '1';
		in_reset_4_bit <= '1';
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_4_bit = '0') AND (out_value_4_bit = "0000")
	     report "Error: 0x34 (val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
         severity ERROR;
	
		-- Extra tick while resetting
		in_clock_4_bit <= '1';
		in_reset_4_bit <= '1';
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_4_bit = '0') AND (out_value_4_bit = "0000")
	     report "Error: 0x35 (val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
         severity ERROR;
		
		-- Increase halfway
		for i in 0 to 8 loop
		
			in_clock_4_bit <= '1';
			in_reset_4_bit <= '0';
			wait for 0.5 ns;
			in_clock_4_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_4_bit = '0') AND (out_value_4_bit = std_logic_vector(to_unsigned(i, 4)))
			 report "Error: 0x36 (t=" & integer'image(i) & ", val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
			 severity ERROR;
		
		end loop;
		
		-- Increasing while not enabled should have no effect
		for i in 0 to 8 loop
		
			in_clock_4_bit  <= '1';
			in_enable_4_bit <= '0';
			in_reset_4_bit  <= '0';
			wait for 0.5 ns;
			in_clock_4_bit  <= '0';
			wait for 0.5 ns;
			assert (out_wrap_4_bit = '0') AND (out_value_4_bit = std_logic_vector(to_unsigned(9, 4)))
			 report "Error: 0x37 (t=" & integer'image(i) & ", val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
			 severity ERROR;
		
		end loop;
	
		-- Reset while not enabled passes
		in_clock_4_bit <= '1';
		in_reset_4_bit <= '1';
		wait for 0.5 ns;
		in_clock_4_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_4_bit = '0') AND (out_value_4_bit = "0000")
	     report "Error: 0x38 (val=" & to_string(out_value_4_bit) & ", wrap=" & to_string(out_wrap_4_bit) & ")"
         severity ERROR; 
		
		-- Unset
		in_clock_4_bit  <= 'U';
		in_enable_4_bit <= 'U';
		in_reset_4_bit  <= 'U';
	
		wait;
	end process;
	
	
	------------------------------------
	--  8-Bit counter test procedure  --
	------------------------------------
	
	process
	begin
	
		-- Wait
		wait for 5 ns;
	
		-- Initialise
		in_clock_8_bit  <= '1';
		in_enable_8_bit <= '1';
		in_reset_8_bit  <= '1';
		wait for 0.5 ns;
		in_clock_8_bit  <= '0';
		wait for 0.5 ns;
        assert (out_wrap_8_bit = '0') AND (out_value_8_bit = "00000000")
	     report "Error: 0x40 (val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
         severity ERROR;
		
		-- Increase to maximum
		for i in 0 to 255 loop
		
			in_clock_8_bit <= '1';
			in_reset_8_bit <= '0';
			wait for 0.5 ns;
			in_clock_8_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_8_bit = '0') AND (out_value_8_bit = std_logic_vector(to_unsigned(i, 8)))
			 report "Error: 0x41 (t=" & integer'image(i) & ", val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
			 severity ERROR;
		
		end loop;
	
		-- Wrap the counter
		in_clock_8_bit <= '1';
		in_reset_8_bit <= '0';
		wait for 0.5 ns;
		in_clock_8_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_8_bit = '1') AND (out_value_8_bit = "00000000")
	     report "Error: 0x42 (val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
         severity ERROR;
		
		-- Increase to maximum without prior reset; no wrap
		for i in 1 to 255 loop
		
			in_clock_8_bit <= '1';
			in_reset_8_bit <= '0';
			wait for 0.5 ns;
			in_clock_8_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_8_bit = '0') AND (out_value_8_bit = std_logic_vector(to_unsigned(i, 8)))
			 report "Error: 0x43 (t=" & integer'image(i) & ", val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
			 severity ERROR;
		
		end loop;
	
		-- Reset while wrapping
		in_clock_8_bit <= '1';
		in_reset_8_bit <= '1';
		wait for 0.5 ns;
		in_clock_8_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_8_bit = '0') AND (out_value_8_bit = "00000000")
	     report "Error: 0x44 (val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
         severity ERROR;
	
		-- Extra tick while resetting
		in_clock_8_bit <= '1';
		in_reset_8_bit <= '1';
		wait for 0.5 ns;
		in_clock_8_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_8_bit = '0') AND (out_value_8_bit = "00000000")
	     report "Error: 0x45 (val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
         severity ERROR;
		
		-- Increase halfway
		for i in 0 to 128 loop
		
			in_clock_8_bit <= '1';
			in_reset_8_bit <= '0';
			wait for 0.5 ns;
			in_clock_8_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_8_bit = '0') AND (out_value_8_bit = std_logic_vector(to_unsigned(i, 8)))
			 report "Error: 0x46 (t=" & integer'image(i) & ", val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
			 severity ERROR;
		
		end loop;
		
		-- Increase while not enabled should have no effect
		for i in 0 to 128 loop
		
			in_clock_8_bit  <= '1';
			in_enable_8_bit <= '0';
			in_reset_8_bit  <= '0';
			wait for 0.5 ns;
			in_clock_8_bit <= '0';
			wait for 0.5 ns;
			assert (out_wrap_8_bit = '0') AND (out_value_8_bit = std_logic_vector(to_unsigned(129, 8)))
			 report "Error: 0x46 (t=" & integer'image(i) & ", val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
			 severity ERROR;
		
		end loop;
	
		-- Reset while not enabled passes
		in_clock_8_bit <= '1';
		in_reset_8_bit <= '1';
		wait for 0.5 ns;
		in_clock_8_bit <= '0';
		wait for 0.5 ns;
        assert (out_wrap_8_bit = '0') AND (out_value_8_bit = "00000000")
	     report "Error: 0x47 (val=" & to_string(out_value_8_bit) & ", wrap=" & to_string(out_wrap_8_bit) & ")"
         severity ERROR;
		
		-- Unset
		in_clock_8_bit  <= 'U';
		in_enable_8_bit <= 'U';
		in_reset_8_bit  <= 'U';
	
		wait;
	end process;

end test;