library IEEE;
use IEEE.std_logic_1164.all;



--------------------------------------------------------------------------------
--
-- Decision Tree class calculation node.
--
--------------------------------------------------------------------------------
--
-- Takes a feature value for classification and determines from supplied node
--  data which child to select next by comparing given feature against this
--  node's threshold.
--
-- Returns this node's own address if it is a leaf (i.e. its feature is 0xFF..F).
-- Returns the right child node address if given input feature value is truly
--  greater than this node's threshold.
-- Returns the left child node address otherwise.
--
--------------------------------------------------------------------------------
--
-- @generic ADDRESS_BITS    - Bits per node address.
-- @generic FEATURE_BITS    - Bit count for class entity features.
-- @generic FEATURE_ID_BITS - Bits per feature index/ identifier.
--
-- @in in_compareFeature - Feature to compare and classify.
-- @in in_nodeAddress    - Currently selected node; may be returned as result.
-- @in in_nodeChildL     - Address of the node's left child.
-- @in in_nodeChildR     - Address of the node's right child.
-- @in in_nodeFeatureID  - Index within the associated decision tree's feature
--                          set; determines which feature is used for the next
--                          node's comparison. Set to 0xFF..F if this is a leaf.
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
	
	signal nodeAddress_and : std_logic_vector(ADDRESS_BITS-1 downto 0);
	signal nodeChildL_and  : std_logic_vector(ADDRESS_BITS-1 downto 0);
	signal nodeChildR_and  : std_logic_vector(ADDRESS_BITS-1 downto 0);

begin

    -- Comparing feature and threshold, only caring about the 'greater'-bit.
    comparator_n_bit_0 : Comparator_n_Bit
	generic map(
		INPUT_BITS => FEATURE_BITS
	)
	port map(
        in_threshold => in_nodeThreshold,
        in_value     => in_compareFeature,
        out_greater  => isGreater
    );
	
	-- Determine whether current node data is that of a leaf.
	comparator_n_bit_1 : Comparator_n_Bit
	generic map(
		INPUT_BITS => FEATURE_ID_BITS
	)
	port map(
        in_threshold => (others => '1'),
        in_value     => in_nodeFeatureID,
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
