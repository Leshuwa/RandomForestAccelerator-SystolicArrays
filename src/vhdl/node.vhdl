library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.rf_types.all;



--------------------------------------------------------------------------------
--
-- Takes a feature value for classification and determines from supplied node
--  data which child to select next by comparing given feature against this
--  node's threshold.
--
-- @in in_compareFeature - Feature to compare and classify.
-- @in in_nodeAddress    - Currently selected node; may be returned as result.
-- @in in_nodeChildL     - Address of the node's left child.
-- @in in_nodeChildR     - Address of the node's right child.
-- @in in_nodeFeature    - Feature value of this node.
-- @in in_nodeThreshold  - This node's feature threshold.
--
-- @out out_nextAddress  - Next node address, either relevant child node's
--							address, or in_nodeAddress if this is a leaf.
--
-- @complexity    23n - 5  =  (2 * (9n - 5)) + (3 * (n + 1)) + (2n + 2)
-- @runtime        2n + 7  =  (2n + 2)       + (2)           + (3)
--
--------------------------------------------------------------------------------

entity Node is
	port(
		in_compareFeature : in  rf_types_value;
		in_nodeAddress    : in  rf_types_address;
		in_nodeChildL     : in  rf_types_address;
		in_nodeChildR     : in  rf_types_address;
		in_nodeFeature    : in  rf_types_value;
		in_nodeThreshold  : in  rf_types_value;
        out_nextAddress   : out rf_types_address
    );
end Node;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of Node is

	component And_n_Bit is
		generic(
			CONDITIONS : integer := 2;
			INPUT_BITS : integer := 4
		);
		port(
			in_conds   : in  std_logic_vector(CONDITIONS-1 downto 0);
			in_vector  : in  std_logic_vector(INPUT_BITS-1 downto 0);
			out_vector : out std_logic_vector(INPUT_BITS-1 downto 0)
		);
	end component;

    component Comparator_n_Bit is
		generic(
			INPUT_BITS : integer := 4
		);
        port(
			in_threshold : in  std_logic_vector(INPUT_BITS-1 downto 0);
			in_value     : in  std_logic_vector(INPUT_BITS-1 downto 0);
			out_equal    : out std_logic;
			out_greater  : out std_logic;
			out_less     : out std_logic
        );
    end component;
	
	signal in_conds_0 : std_logic_vector(0 downto 0);
	signal in_conds_1 : std_logic_vector(1 downto 0);
	signal in_conds_2 : std_logic_vector(1 downto 0);
	
	signal isGreater  : std_logic;
	signal isLeafNode : std_logic;
	signal isTreeNode : std_logic;
	
	signal nodeAddress_and : rf_types_address;
	signal nodeChildL_and  : rf_types_address;
	signal nodeChildR_and  : rf_types_address;

begin

    -- Passing feature and threshold to the comparator; we only care about the 'greater'-bit.
    comparator_n_bit_0 : Comparator_n_Bit
	generic map(
		INPUT_BITS => VALUE_BITS
	)
	port map(
        in_threshold => in_nodeThreshold,
        in_value     => in_compareFeature,
        out_greater  => isGreater
    );
	
	-- Determine whether current node data is that of a leaf.
	comparator_n_bit_1 : Comparator_n_Bit
	generic map(
		INPUT_BITS => VALUE_BITS
	)
	port map(
        in_threshold => (others => '1'),
        in_value     => in_nodeFeature,
        out_equal    => isLeafNode
    );
	
	-- Prepare AND-gate condition inputs.
	isTreeNode <= NOT isLeafNode;
	
	in_conds_0(0) <= isLeafNode;
	in_conds_1(0) <= isTreeNode;
	in_conds_1(1) <= (NOT isGreater);
	in_conds_2(0) <= isTreeNode;
	in_conds_2(1) <= isGreater;
	
	-- Create AND-gates for node addresses.
	and_n_bit_0 : And_n_Bit
	generic map(
		CONDITIONS => 1,
		INPUT_BITS => ADDRESS_BITS
	)
    port map(
		in_conds   => in_conds_0,
        in_vector  => in_nodeAddress,
		out_vector => nodeAddress_and
	);
	
	and_n_bit_1 : And_n_Bit
	generic map(
		CONDITIONS => 2,
		INPUT_BITS => ADDRESS_BITS
	)
    port map(
		in_conds   => in_conds_1,
        in_vector  => in_nodeChildL,
		out_vector => nodeChildL_and
    );
	
	and_n_bit_2 : And_n_Bit
	generic map(
		CONDITIONS => 2,
		INPUT_BITS => ADDRESS_BITS
	)
    port map(
		in_conds   => in_conds_2,
        in_vector  => in_nodeChildR,
		out_vector => nodeChildR_and
    );

	-- Connect output bits via multi-OR-gates.
	genOrGates:
	for i in ADDRESS_BITS-1 downto 0 generate

		out_nextAddress(i) <= (nodeAddress_and(i) OR nodeChildL_and(i) OR nodeChildR_and(i));
		
	end generate genOrGates;

end arch;
