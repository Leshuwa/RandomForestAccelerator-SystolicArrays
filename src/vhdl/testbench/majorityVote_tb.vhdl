library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

library work;
use work.rf_types.all;



entity MajorityVote_tb is
end MajorityVote_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of MajorityVote_tb is

    component MajorityVote is
        generic(
            CLASS_COUNT_LOG_2 : integer := 3;
            CLASS_LABEL_BITS  : integer := 4
        );
        port(
            in_clock  : in  std_logic;
            in_labels : in  std_logic_matrix((2**CLASS_COUNT_LOG_2)-1 downto 0)(CLASS_LABEL_BITS-1 downto 0);
            in_reset  : in  std_logic;
            out_ready : out std_logic;
            out_class : out std_logic_vector(CLASS_LABEL_BITS-1 downto 0)
        );
    end component;
	
	signal in_clock_2c_7l  : std_logic;
	signal in_labels_2c_7l : std_logic_matrix((2**2)-1 downto 0)(7-1 downto 0);
	signal in_reset_2c_7l  : std_logic;
	signal out_ready_2c_7l : std_logic;
	signal out_class_2c_7l : std_logic_vector(7-1 downto 0);
	
	signal in_clock_3c_4l  : std_logic;
	signal in_labels_3c_4l : std_logic_matrix((2**3)-1 downto 0)(4-1 downto 0);
	signal in_reset_3c_4l  : std_logic;
	signal out_ready_3c_4l : std_logic;
	signal out_class_3c_4l : std_logic_vector(4-1 downto 0);

begin
    
    majorityVote_2c_7l : MajorityVote
    generic map(
        CLASS_COUNT_LOG_2 => 2,
        CLASS_LABEL_BITS  => 7
    )
    port map(
        in_clock  => in_clock_2c_7l,
        in_labels => in_labels_2c_7l,
        in_reset  => in_reset_2c_7l,
        out_ready => out_ready_2c_7l,
        out_class => out_class_2c_7l
    );

    majorityVote_3c_4l : MajorityVote
    port map(
        in_clock  => in_clock_3c_4l,
        in_labels => in_labels_3c_4l,
        in_reset  => in_reset_3c_4l,
        out_ready => out_ready_3c_4l,
        out_class => out_class_3c_4l
    );

    process begin

		--------------------------------------------------------------
		--  Tests for 4-class majority vote with 7-Bit class labels --
		--------------------------------------------------------------
		
		-- Initialisation
		--  Duration: 1ns (0ns -> 1ns)
        in_labels_2c_7l <= ("0000000", "0000000", "0000000", "0000000");
        in_reset_2c_7l  <= '1';
		in_clock_2c_7l  <= '1';
		wait for 0.5 ns;
		in_clock_2c_7l  <= '0';
		wait for 0.5 ns;
        assert (out_ready_2c_7l = '0' AND out_class_2c_7l = "0000000")
	     report "Error: 0x10 (ready=" & to_string(out_ready_2c_7l) & ", class=" & to_string(out_class_2c_7l) & ")"
         severity ERROR;
        
        -- Clear majority with one intermittent result change
		--  Duration: 17ns (1ns -> 18ns)
        in_labels_2c_7l <= ("0110010", "1000101", "0110010", "1100010");
        in_reset_2c_7l  <= '0';
		
		for i in 0 to 16 loop
		
		    in_clock_2c_7l <= '1';
		    wait for 0.5 ns;
		    in_clock_2c_7l <= '0';
		    wait for 0.5 ns;
			
			if (i < 7) then
			
				assert (out_ready_2c_7l = '0' AND out_class_2c_7l = "1100010")
				 report "Error: 0x11 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_2c_7l) & ", class=" & to_string(out_class_2c_7l) & ")"
				 severity ERROR;
				 
			elsif (i < 16) then
			
				assert (out_ready_2c_7l = '0' AND out_class_2c_7l = "0110010")
				 report "Error: 0x12 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_2c_7l) & ", class=" & to_string(out_class_2c_7l) & ")"
				 severity ERROR;
				 
			else
			
				assert (out_ready_2c_7l = '1' AND out_class_2c_7l = "0110010")
				 report "Error: 0x13 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_2c_7l) & ", class=" & to_string(out_class_2c_7l) & ")"
				 severity ERROR;
				 
			end if;
			 
		end loop;
        
        -- Stability test with extra clock-ticks after ready-flag was set.
		-- Output and ready-flag must remain stable.
		--  Duration: 17ns (18ns -> 35ns)
		for i in 0 to 16 loop
		
		    in_clock_2c_7l <= '1';
		    wait for 0.5 ns;
		    in_clock_2c_7l <= '0';
		    wait for 0.5 ns;
			assert (out_ready_2c_7l = '1' AND out_class_2c_7l = "0110010")
			 report "Error: 0x14 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_2c_7l) & ", class=" & to_string(out_class_2c_7l) & ")"
			 severity ERROR;
			 
		end loop;
		
		-- Reset
		--  Duration: 1ns (35ns -> 36ns)
        in_labels_2c_7l <= ("0000000", "0000000", "0000000", "0000000");
        in_reset_2c_7l  <= '1';
		in_clock_2c_7l  <= '1';
		wait for 0.5 ns;
		in_clock_2c_7l  <= '0';
		wait for 0.5 ns;
        assert (out_ready_2c_7l = '0' AND out_class_2c_7l = "0000000")
	     report "Error: 0x15 (ready=" & to_string(out_ready_2c_7l) & ", class=" & to_string(out_class_2c_7l) & ")"
         severity ERROR;
		 
		-- Run with empty inputs
		--  Duration: 17ns (36ns -> 53ns)
        in_reset_2c_7l  <= '0';
		
		for i in 0 to 16 loop
		
		    in_clock_2c_7l <= '1';
		    wait for 0.5 ns;
		    in_clock_2c_7l <= '0';
		    wait for 0.5 ns;
			
			if (i < 16) then
			
				assert (out_ready_2c_7l = '0' AND out_class_2c_7l = "0000000")
				 report "Error: 0x16 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_2c_7l) & ", class=" & to_string(out_class_2c_7l) & ")"
				 severity ERROR;
				 
			else
			
				assert (out_ready_2c_7l = '1' AND out_class_2c_7l = "0000000")
				 report "Error: 0x17 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_2c_7l) & ", class=" & to_string(out_class_2c_7l) & ")"
				 severity ERROR;
				 
			end if;
			 
		end loop;
		
		-- Reset and wait until next 10-nanosecond time slot.
        in_clock_2c_7l  <= 'U';
        in_reset_2c_7l  <= 'U';
		wait for 7 ns;
		

		--------------------------------------------------------------
		--  Tests for 8-class majority vote with 4-Bit class labels --
		--------------------------------------------------------------
		
		-- Initialisation
		--  Duration: 1ns (60ns -> 61ns)
		in_labels_3c_4l <= ("0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000");
        in_reset_3c_4l  <= '1';
        in_clock_3c_4l  <= '1';
		wait for 0.5 ns;
		in_clock_3c_4l  <= '0';
		wait for 0.5 ns;
        assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0000")
	     report "Error: 0x20 (ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
         severity ERROR;
        
        -- No majority; first input value remains selected
		--  Duration: 65ns (61ns -> 126ns)
		in_labels_3c_4l <= ("1000", "0111", "0110", "0101", "0100", "0011", "0010", "0001");
        in_reset_3c_4l  <= '0';
		
		for i in 0 to 64 loop
		
            in_clock_3c_4l <= '1';
		    wait for 0.5 ns;
		    in_clock_3c_4l <= '0';
		    wait for 0.5 ns;
			
			if (i < 64) then
			
				assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0001")
				 report "Error: 0x21 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			else
			
				assert (out_ready_3c_4l = '1' AND out_class_3c_4l = "0001")
				 report "Error: 0x22 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			end if;
			
		end loop;
        
        -- Stability test with extra clock-ticks after ready-flag was set.
		-- Output and ready-flag must remain stable.
		--  Duration: 65ns (126ns -> 191ns)
		for i in 0 to 64 loop
            
			in_clock_3c_4l <= '1';
		    wait for 0.5 ns;
		    in_clock_3c_4l <= '0';
		    wait for 0.5 ns;
			assert (out_ready_3c_4l = '1' AND out_class_3c_4l = "0001")
			 report "Error: 0x23 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
			 severity ERROR;
		
		end loop;
		
		-- Reset
		--  Duration: 1ns (191ns -> 192ns)
        in_reset_3c_4l <= '1';
        in_clock_3c_4l <= '1';
		wait for 0.5 ns;
		in_clock_3c_4l <= '0';
		wait for 0.5 ns;
        assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0000")
	     report "Error: 0x24 (ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
         severity ERROR;
        
        -- Clear majority; no change in between
		--  Duration: 65ns (192ns -> 257ns)
		in_labels_3c_4l <= ("0111", "0010", "0111", "0111", "0100", "1001", "0001", "0111");
        in_reset_3c_4l  <= '0';
		
        for i in 0 to 64 loop
            
			in_clock_3c_4l <= '1';
		    wait for 0.5 ns;
		    in_clock_3c_4l <= '0';
		    wait for 0.5 ns;
			
		end loop;
		
		assert (out_ready_3c_4l = '1' AND out_class_3c_4l = "0111")
		 report "Error: 0x25 (ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
		 severity ERROR;
		
		-- Reset
		--  Duration: 1ns (257ns -> 258ns)
        in_reset_3c_4l <= '1';
        in_clock_3c_4l <= '1';
		wait for 0.5 ns;
		in_clock_3c_4l <= '0';
		wait for 0.5 ns;
        assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0000")
	     report "Error: 0x26 (ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
         severity ERROR;
        
        -- Close majority, only determined at the end
		--  Duration: 65ns (258ns -> 323ns)
		in_labels_3c_4l <= ("0011", "0011", "0011", "0011", "0010", "0010", "0010", "0001");
        in_reset_3c_4l  <= '0';
        
		for i in 0 to 64 loop
		
            in_clock_3c_4l <= '1';
		    wait for 0.5 ns;
		    in_clock_3c_4l <= '0';
		    wait for 0.5 ns;
			
			if (i < 10) then
			
				assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0001")
				 report "Error: 0x27 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			elsif (i < 39) then
			
				assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0010")
				 report "Error: 0x28 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			elsif (i < 64) then
			
				assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0011")
				 report "Error: 0x29 (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			else
			
				assert (out_ready_3c_4l = '1' AND out_class_3c_4l = "0011")
				 report "Error: 0x2A (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			end if;
		
		end loop;
		
		-- Reset
		--  Duration: 1ns (323ns -> 324ns)
        in_reset_3c_4l <= '1';
        in_clock_3c_4l <= '1';
		wait for 0.5 ns;
		in_clock_3c_4l <= '0';
		wait for 0.5 ns;
        assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0000")
	     report "Error: 0x2B (ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
         severity ERROR;
        
        -- Simple majority with various empty (0x00) inputs.
		--  Duration: 65ns (324ns -> 389ns)
		in_labels_3c_4l <= ("0000", "0110", "0000", "0000", "0110", "0111", "0010", "0000");
        in_reset_3c_4l  <= '0';
		
        for i in 0 to 64 loop
            
			in_clock_3c_4l <= '1';
		    wait for 0.5 ns;
		    in_clock_3c_4l <= '0';
		    wait for 0.5 ns;
			
			if (i < 8) then
			
				assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0000")
				 report "Error: 0x2C (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			elsif (i < 30) then
			
				assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0010")
				 report "Error: 0x2D (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			elsif (i < 64) then
			
				assert (out_ready_3c_4l = '0' AND out_class_3c_4l = "0110")
				 report "Error: 0x2E (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			else
			
				assert (out_ready_3c_4l = '1' AND out_class_3c_4l = "0110")
				 report "Error: 0x2F (t=" & integer'image(i) & ", ready=" & to_string(out_ready_3c_4l) & ", class=" & to_string(out_class_3c_4l) & ")"
				 severity ERROR;
			
			end if;
			
		end loop;
		
		-- Reset and wait until next 10-nanosecond time slot.
        in_clock_3c_4l <= 'U';
        in_reset_3c_4l <= 'U';
		wait for 1 ns;
		
		wait;
    end process;

end test;
