library IEEE;
use IEEE.std_logic_1164.all;



package rf_types is

	-- Constant definitions to configure the design's dimensions.
	constant ADDRESS_BITS : integer := 4;
	constant CLASS_BITS   : integer := 4;
	constant VALUE_BITS   : integer := 4;
	
	-- Total number of node data bits, automatically calculated.
	constant NODE_DATA_BITS : integer := ((2 * VALUE_BITS) + (2 * ADDRESS_BITS) + CLASS_BITS);
	
	-- Subtype definitions for Random Forest node data.
	subtype rf_types_address   is std_logic_vector((ADDRESS_BITS - 1)   downto 0);
	subtype rf_types_class     is std_logic_vector((CLASS_BITS - 1)     downto 0);
	subtype rf_types_value     is std_logic_vector((VALUE_BITS - 1)     downto 0);
	subtype rf_types_node_data is std_logic_vector((NODE_DATA_BITS - 1) downto 0);

	-- Bundles relevant node data in a record.
	type node_data is record
		threshold     : rf_types_value;
		feature       : rf_types_value;
		addressChildL : rf_types_address;
		addressChildR : rf_types_address;
		class         : rf_types_class;
	end record;

end rf_types;
