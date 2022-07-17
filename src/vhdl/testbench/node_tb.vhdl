library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.rf_types.all;



entity Node_tb is
end Node_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of Node_tb is

	component Node is
		port(
			in_compareFeature : in  rf_types_value;
			in_nodeAddress    : in  rf_types_address;
			in_nodeChildL     : in  rf_types_address;
			in_nodeChildR     : in  rf_types_address;
			in_nodeFeature    : in  rf_types_value;
			in_nodeThreshold  : in  rf_types_value;
			out_nextAddress   : out rf_types_address
		);
	end component;
	
	signal in_compareFeature : rf_types_value;
	signal in_nodeAddress    : rf_types_address;
	signal in_nodeChildL     : rf_types_address;
	signal in_nodeChildR     : rf_types_address;
	signal in_nodeFeature    : rf_types_value;
	signal in_nodeThreshold  : rf_types_value;
	signal out_nextAddress   : rf_types_address;

begin

	node0 : Node
	port map(
		in_compareFeature => in_compareFeature,
		in_nodeAddress    => in_nodeAddress,
		in_nodeChildL     => in_nodeChildL,
		in_nodeChildR     => in_nodeChildR,
		in_nodeFeature    => in_nodeFeature,
		in_nodeThreshold  => in_nodeThreshold,
		out_nextAddress   => out_nextAddress
	);
	
	process begin
	
		in_compareFeature  <= "0000";
		in_nodeAddress     <= "0000";
		in_nodeChildL      <= "0000";
		in_nodeChildR      <= "0000";
		in_nodeFeature     <= "0000";
		in_nodeThreshold   <= "0000";
		wait for 1 ns;
        assert (out_nextAddress = "0000")
	     report "Error: 0x10"
         severity ERROR;
		
		in_compareFeature  <= "0100";
		in_nodeAddress     <= "0111";
		in_nodeChildL      <= "1101";
		in_nodeChildR      <= "1011";
		in_nodeFeature     <= "1111";
		in_nodeThreshold   <= "0101";
		wait for 1 ns;
        assert (out_nextAddress = in_nodeAddress)
	     report "Error: 0x11"
         severity ERROR;
		
		in_compareFeature  <= "0100";
		in_nodeAddress     <= "0111";
		in_nodeChildL      <= "1101";
		in_nodeChildR      <= "1011";
		in_nodeFeature     <= "0010";
		in_nodeThreshold   <= "0101";
		wait for 1 ns;
        assert (out_nextAddress = in_nodeChildL)
	     report "Error: 0x12"
         severity ERROR;
		
		in_compareFeature  <= "0110";
		in_nodeAddress     <= "0111";
		in_nodeChildL      <= "1101";
		in_nodeChildR      <= "1011";
		in_nodeFeature     <= "0010";
		in_nodeThreshold   <= "0101";
		wait for 1 ns;
        assert (out_nextAddress = in_nodeChildR)
	     report "Error: 0x13"
         severity ERROR;
	
		wait;
	end process;

end test;
