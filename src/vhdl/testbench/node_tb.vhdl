library IEEE;
use IEEE.std_logic_1164.all;



entity Node_tb is
end Node_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of Node_tb is

	component Node is
		generic(
			ADDRESS_BITS    : integer := 4;
			FEATURE_BITS    : integer := 4;
			FEATURE_ID_BITS : integer := 4
		);
		port(
			in_compareFeature : in  std_logic_vector(   FEATURE_BITS-1 downto 0);
			in_nodeAddress    : in  std_logic_vector(   ADDRESS_BITS-1 downto 0);
			in_nodeChildL     : in  std_logic_vector(   ADDRESS_BITS-1 downto 0);
			in_nodeChildR     : in  std_logic_vector(   ADDRESS_BITS-1 downto 0);
			in_nodeFeatureID  : in  std_logic_vector(FEATURE_ID_BITS-1 downto 0);
			in_nodeThreshold  : in  std_logic_vector(   FEATURE_BITS-1 downto 0);
			out_nextAddress   : out std_logic_vector(   ADDRESS_BITS-1 downto 0)
		);
	end component;
	
	signal in_compareFeature_3a_5f_2i : std_logic_vector((5)-1 downto 0);
	signal in_nodeAddress_3a_5f_2i    : std_logic_vector((3)-1 downto 0);
	signal in_nodeChildL_3a_5f_2i     : std_logic_vector((3)-1 downto 0);
	signal in_nodeChildR_3a_5f_2i     : std_logic_vector((3)-1 downto 0);
	signal in_nodeFeatureID_3a_5f_2i  : std_logic_vector((2)-1 downto 0);
	signal in_nodeThreshold_3a_5f_2i  : std_logic_vector((5)-1 downto 0);
	signal out_nextAddress_3a_5f_2i   : std_logic_vector((3)-1 downto 0);
	
	signal in_compareFeature_4a_4f_4i : std_logic_vector((4)-1 downto 0);
	signal in_nodeAddress_4a_4f_4i    : std_logic_vector((4)-1 downto 0);
	signal in_nodeChildL_4a_4f_4i     : std_logic_vector((4)-1 downto 0);
	signal in_nodeChildR_4a_4f_4i     : std_logic_vector((4)-1 downto 0);
	signal in_nodeFeatureID_4a_4f_4i  : std_logic_vector((4)-1 downto 0);
	signal in_nodeThreshold_4a_4f_4i  : std_logic_vector((4)-1 downto 0);
	signal out_nextAddress_4a_4f_4i   : std_logic_vector((4)-1 downto 0);

begin

	node_3a_5f_2i : Node
	generic map(
		ADDRESS_BITS    => 3,
		FEATURE_BITS    => 5,
		FEATURE_ID_BITS => 2
	)
	port map(
		in_compareFeature => in_compareFeature_3a_5f_2i,
		in_nodeAddress    => in_nodeAddress_3a_5f_2i,
		in_nodeChildL     => in_nodeChildL_3a_5f_2i,
		in_nodeChildR     => in_nodeChildR_3a_5f_2i,
		in_nodeFeatureID  => in_nodeFeatureID_3a_5f_2i,
		in_nodeThreshold  => in_nodeThreshold_3a_5f_2i,
		out_nextAddress   => out_nextAddress_3a_5f_2i
	);

	node_4a_4f_4i : Node
	port map(
		in_compareFeature => in_compareFeature_4a_4f_4i,
		in_nodeAddress    => in_nodeAddress_4a_4f_4i,
		in_nodeChildL     => in_nodeChildL_4a_4f_4i,
		in_nodeChildR     => in_nodeChildR_4a_4f_4i,
		in_nodeFeatureID  => in_nodeFeatureID_4a_4f_4i,
		in_nodeThreshold  => in_nodeThreshold_4a_4f_4i,
		out_nextAddress   => out_nextAddress_4a_4f_4i
	);
	
	process begin

		-----------------------------------------------------
		--  Tests for 2-bit addresses with 5-bit features  --
		-----------------------------------------------------
	
		-- Empty node
		in_compareFeature_3a_5f_2i  <= "00000";
		in_nodeAddress_3a_5f_2i     <= "000";
		in_nodeChildL_3a_5f_2i      <= "000";
		in_nodeChildR_3a_5f_2i      <= "000";
		in_nodeFeatureID_3a_5f_2i   <= "00";
		in_nodeThreshold_3a_5f_2i   <= "00000";
		wait for 1 ns;
        assert (out_nextAddress_3a_5f_2i = "000")
	     report "Error: 0x10"
         severity ERROR;
		
		-- Leaf node (always returns its own address)
		in_compareFeature_3a_5f_2i  <= "01101";
		in_nodeAddress_3a_5f_2i     <= "001";
		in_nodeChildL_3a_5f_2i      <= "010";
		in_nodeChildR_3a_5f_2i      <= "100";
		in_nodeFeatureID_3a_5f_2i   <= "11";
		in_nodeThreshold_3a_5f_2i   <= "01010";
		wait for 1 ns;
        assert (out_nextAddress_3a_5f_2i = in_nodeAddress_3a_5f_2i)
	     report "Error: 0x11"
         severity ERROR;
		
		-- Left child node (feature less than or equal to threshold)
		in_compareFeature_3a_5f_2i  <= "01001";
		in_nodeAddress_3a_5f_2i     <= "001";
		in_nodeChildL_3a_5f_2i      <= "010";
		in_nodeChildR_3a_5f_2i      <= "100";
		in_nodeFeatureID_3a_5f_2i   <= "01";
		in_nodeThreshold_3a_5f_2i   <= "01001";
		wait for 1 ns;
        assert (out_nextAddress_3a_5f_2i = in_nodeChildL_3a_5f_2i)
	     report "Error: 0x12"
         severity ERROR;
		
		-- Right child node (feature greater than threshold)
		in_compareFeature_3a_5f_2i  <= "01101";
		in_nodeAddress_3a_5f_2i     <= "001";
		in_nodeChildL_3a_5f_2i      <= "010";
		in_nodeChildR_3a_5f_2i      <= "100";
		in_nodeFeatureID_3a_5f_2i   <= "10";
		in_nodeThreshold_3a_5f_2i   <= "01100";
		wait for 1 ns;
        assert (out_nextAddress_3a_5f_2i = in_nodeChildR_3a_5f_2i)
	     report "Error: 0x13"
         severity ERROR;
		
		-- Wait until next 10-nanosecond timeslot.
		in_compareFeature_3a_5f_2i  <= "UUUUU";
		in_nodeAddress_3a_5f_2i     <= "UUU";
		in_nodeChildL_3a_5f_2i      <= "UUU";
		in_nodeChildR_3a_5f_2i      <= "UUU";
		in_nodeFeatureID_3a_5f_2i   <= "UU";
		in_nodeThreshold_3a_5f_2i   <= "UUUUU";
		wait for 6 ns;

		-----------------------------------------------------
		--  Tests for 4-bit addresses with 4-bit features  --
		-----------------------------------------------------
	
		-- Empty node
		in_compareFeature_4a_4f_4i  <= "0000";
		in_nodeAddress_4a_4f_4i     <= "0000";
		in_nodeChildL_4a_4f_4i      <= "0000";
		in_nodeChildR_4a_4f_4i      <= "0000";
		in_nodeFeatureID_4a_4f_4i   <= "0000";
		in_nodeThreshold_4a_4f_4i   <= "0000";
		wait for 1 ns;
        assert (out_nextAddress_4a_4f_4i = "0000")
	     report "Error: 0x20"
         severity ERROR;
		
		-- Leaf node (always returns its own address)
		in_compareFeature_4a_4f_4i  <= "0100";
		in_nodeAddress_4a_4f_4i     <= "0111";
		in_nodeChildL_4a_4f_4i      <= "1101";
		in_nodeChildR_4a_4f_4i      <= "1011";
		in_nodeFeatureID_4a_4f_4i   <= "1111";
		in_nodeThreshold_4a_4f_4i   <= "0101";
		wait for 1 ns;
        assert (out_nextAddress_4a_4f_4i = in_nodeAddress_4a_4f_4i)
	     report "Error: 0x21"
         severity ERROR;
		
		-- Left child node (feature less than or equal to threshold)
		in_compareFeature_4a_4f_4i  <= "0100";
		in_nodeAddress_4a_4f_4i     <= "0111";
		in_nodeChildL_4a_4f_4i      <= "1101";
		in_nodeChildR_4a_4f_4i      <= "1011";
		in_nodeFeatureID_4a_4f_4i   <= "0010";
		in_nodeThreshold_4a_4f_4i   <= "0101";
		wait for 1 ns;
        assert (out_nextAddress_4a_4f_4i = in_nodeChildL_4a_4f_4i)
	     report "Error: 0x22"
         severity ERROR;
		
		-- Right child node (feature greater than threshold)
		in_compareFeature_4a_4f_4i  <= "0110";
		in_nodeAddress_4a_4f_4i     <= "0111";
		in_nodeChildL_4a_4f_4i      <= "1101";
		in_nodeChildR_4a_4f_4i      <= "1011";
		in_nodeFeatureID_4a_4f_4i   <= "0010";
		in_nodeThreshold_4a_4f_4i   <= "0101";
		wait for 1 ns;
        assert (out_nextAddress_4a_4f_4i = in_nodeChildR_4a_4f_4i)
	     report "Error: 0x23"
         severity ERROR;
		
		-- Wait until next 10-nanosecond timeslot.
		in_compareFeature_4a_4f_4i  <= "UUUU";
		in_nodeAddress_4a_4f_4i     <= "UUUU";
		in_nodeChildL_4a_4f_4i      <= "UUUU";
		in_nodeChildR_4a_4f_4i      <= "UUUU";
		in_nodeFeatureID_4a_4f_4i   <= "UUUU";
		in_nodeThreshold_4a_4f_4i   <= "UUUU";
		wait for 6 ns;
	
		wait;
	end process;

end test;
