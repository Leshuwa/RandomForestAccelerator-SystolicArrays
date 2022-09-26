library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.rf_types.all;



--------------------------------------------------------------------------------
--
-- Multi-nodal Decision Tree algorithm implementation.
--
--------------------------------------------------------------------------------
--
-- Each decision tree has a root node with address 0x00..0 from which the
--  classification process begins. Starting with the root node, each tree node
--  compares the currently selected feature with its own threshold and selects
--  either its left or right child as successor or (if it is a leaf) returns
--  its assigned (=stored) class label as result.
--
-- Feature count can be declared independently from its bit count declaration.
-- However, behaviour is undefined for cases where the node count is less than
--  two to the power of the feature bit count.
--
--------------------------------------------------------------------------------
--
-- @generic CLASS_LABEL_BITS  - Number of bits a single class label has.
-- @generic FEATURE_BITS      - Bit count for class entity features.
-- @generic FEATURE_ID_BITS   - Bits per feature index/ identifier.
-- @generic FEATURE_ID_COUNT  - Number of used features (1..2^FEATURE_ID_BITS)
-- @generic NODE_ADDRESS_BITS - Bits per node address.
-- @generic PATH_TO_ROM_FILE  - ROM-file path relative to VHDL compilation unit
--                               pointing at a Random Forest data file.
-- @generic TREE_COUNT        - Number of trees per random forest.
-- @generic TREE_DEPTH        - Levels in a single decision tree.
-- @generic TREE_INDEX        - Current index of this tree for memory reference.
--
-- @in in_features  - Input matrix containing a feature set for classification.
-- @in in_reset     - Set to '1' to reset the entire decision tree.
--
-- @out out_ready   - Raised to '1' once computation has finished.
-- @out out_class   - Suggested class label for given feature set.
--
--------------------------------------------------------------------------------

entity DecisionTree is
	generic(
		CLASS_LABEL_BITS  : positive;
		FEATURE_BITS      : positive;
		FEATURE_ID_BITS   : positive;
		FEATURE_ID_COUNT  : positive;
		NODE_ADDRESS_BITS : positive;
		PATH_TO_ROM_FILE  : string;
		TREE_COUNT        : positive;
		TREE_DEPTH        : positive;
		TREE_INDEX        : natural
	);
    port(
		in_features  : in  std_logic_matrix(0 to FEATURE_ID_COUNT-1)(FEATURE_BITS-1 downto 0);
		out_ready    : out std_logic;
        out_class    : out std_logic_vector(CLASS_LABEL_BITS-1 downto 0)
    );
end DecisionTree;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of DecisionTree is
    
    -----------------------------
    --  Component declaration  --
    -----------------------------

    component DecisionTreeMemory is
		generic(
			ADDRESS_BITS      : positive;
			CLASS_BITS        : positive;
			FEATURE_BITS      : positive;
			FEATURE_ID_BITS   : positive;
			FOREST_TREE_COUNT : positive;
			PATH_TO_ROM_FILE  : string;
			TREE_INDEX        : natural
		);
		port(
			in_nodeAddress : in  std_logic_vector(   ADDRESS_BITS-1 downto 0);
			out_childL     : out std_logic_vector(   FEATURE_BITS-1 downto 0);
			out_childR     : out std_logic_vector(   FEATURE_BITS-1 downto 0);
			out_class      : out std_logic_vector(     CLASS_BITS-1 downto 0);
			out_featureID  : out std_logic_vector(FEATURE_ID_BITS-1 downto 0);
			out_threshold  : out std_logic_vector(   FEATURE_BITS-1 downto 0)
		);
    end component;

    component Node is
		generic(
			ADDRESS_BITS    : positive;
			FEATURE_BITS    : positive;
			FEATURE_ID_BITS : positive
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
	
	component Mux_n_Bit is
		generic(
			INPUT_BITS  : positive;
			SELECT_BITS : positive
		);
		port(
			in_select  : in  std_logic_vector(SELECT_BITS-1 downto 0);
			in_values  : in  std_logic_matrix((2**SELECT_BITS)-1 downto 0)(INPUT_BITS-1 downto 0);
			out_value  : out std_logic_vector(INPUT_BITS-1 downto 0)
		);
	end component;
    
    
    --------------------------
    --  Signal declaration  --
    --------------------------

	signal curr_compareFeature : std_logic_matrix(0 to TREE_DEPTH-1)(     FEATURE_BITS-1 downto 0);
	signal curr_nodeAddress    : std_logic_matrix(0 to TREE_DEPTH-1)(NODE_ADDRESS_BITS-1 downto 0) := (others => (others => '0'));
	signal curr_nodeChildL     : std_logic_matrix(0 to TREE_DEPTH-1)(NODE_ADDRESS_BITS-1 downto 0);
	signal curr_nodeChildR     : std_logic_matrix(0 to TREE_DEPTH-1)(NODE_ADDRESS_BITS-1 downto 0);
	signal curr_nodeClass      : std_logic_matrix(0 to TREE_DEPTH-1)( CLASS_LABEL_BITS-1 downto 0);
	signal curr_nodeFeatureID  : std_logic_matrix(0 to TREE_DEPTH-1)(  FEATURE_ID_BITS-1 downto 0) := (others => (others => '0'));
	signal curr_nodeThreshold  : std_logic_matrix(0 to TREE_DEPTH-1)(     FEATURE_BITS-1 downto 0);
	
	-- Given input feature IDs, padded from FEATURE_ID_COUNT to 2^FEATURE_ID_BITS elements.
	signal paddedFeatures : std_logic_matrix(0 to (2**FEATURE_ID_BITS)-1)(FEATURE_BITS-1 downto 0);


begin

	-- Pad input features
	genPaddedFeatures:
	for i in 0 to (2**FEATURE_ID_BITS)-1 generate
	
		genPaddedFeatures_feature:
		if (i < FEATURE_ID_COUNT) generate
			paddedFeatures(i) <= in_features(i);
		end generate;
		
		genPaddedFeatures_padding:
		if (i >= FEATURE_ID_COUNT) generate
			paddedFeatures(i) <= (others => '0');
		end generate;
	
	end generate;

    ---------------------------
    --  Loop initialisation  --
    ---------------------------
	
	-- Root node has address 0x00..0
	curr_nodeAddress(0) <= (others => '0');
	
	-- Load data for root node from ROM
	decisionTreeMemory_init : DecisionTreeMemory
	generic map(
		ADDRESS_BITS      => NODE_ADDRESS_BITS,
		CLASS_BITS        => CLASS_LABEL_BITS,
		FEATURE_BITS      => FEATURE_BITS,
		FEATURE_ID_BITS   => FEATURE_ID_BITS,
		FOREST_TREE_COUNT => TREE_COUNT,
		PATH_TO_ROM_FILE  => PATH_TO_ROM_FILE,
		TREE_INDEX        => TREE_INDEX
	)
	port map(
		in_nodeAddress => curr_nodeAddress(0),
		out_childL     => curr_nodeChildL(0),
		out_childR     => curr_nodeChildR(0),
		out_class      => curr_nodeClass(0),
		out_featureID  => curr_nodeFeatureID(0),
		out_threshold  => curr_nodeThreshold(0)
	);
	
	----------------------
    --  Loop execution  --
    ----------------------
	
	genLoop:
	for i in 1 to TREE_DEPTH-1 generate
	
		-- Retrieve comparison feature for previous node.
		mux_get_feature : Mux_n_Bit
		generic map(
			INPUT_BITS  => FEATURE_BITS,
			SELECT_BITS => FEATURE_ID_BITS
		)
		port map(
			in_select => curr_nodeFeatureID(i - 1),
			in_values => paddedFeatures,
			out_value => curr_compareFeature(i - 1)
		);
	
		-- Calculate address for next node	
		node_loop : Node
		generic map(
			ADDRESS_BITS    => NODE_ADDRESS_BITS,
			FEATURE_BITS    => FEATURE_BITS,
			FEATURE_ID_BITS => FEATURE_ID_BITS
		)
		port map(
			in_compareFeature => curr_compareFeature(i - 1),
			in_nodeAddress    => curr_nodeAddress   (i - 1),
			in_nodeChildL     => curr_nodeChildL    (i - 1),
			in_nodeChildR     => curr_nodeChildR    (i - 1),
			in_nodeFeatureID  => curr_nodeFeatureID (i - 1),
			in_nodeThreshold  => curr_nodeThreshold (i - 1),
			out_nextAddress   => curr_nodeAddress   (i)
		);
		
		-- Load data for next node from ROM
		decisionTreeMemory_loop : DecisionTreeMemory
		generic map(
			ADDRESS_BITS      => NODE_ADDRESS_BITS,
			CLASS_BITS        => CLASS_LABEL_BITS,
			FEATURE_BITS      => FEATURE_BITS,
			FEATURE_ID_BITS   => FEATURE_ID_BITS,
			FOREST_TREE_COUNT => TREE_COUNT,
			PATH_TO_ROM_FILE  => PATH_TO_ROM_FILE,
			TREE_INDEX        => TREE_INDEX
		)
		port map(
			in_nodeAddress => curr_nodeAddress   (i),
			out_childL     => curr_nodeChildL    (i),
			out_childR     => curr_nodeChildR    (i),
			out_class      => curr_nodeClass     (i),
			out_featureID  => curr_nodeFeatureID (i),
			out_threshold  => curr_nodeThreshold (i)
		);
	
	end generate;
	
	--------------------------
    --  Output assignments  --
    --------------------------
	
	-- Reset ready-flag when either input changes.
	out_ready <= '0', '1' after (TREE_DEPTH * (1 ns));
	
	-- Resulting classification label is that of the selected leaf.
	out_class <= curr_nodeClass(TREE_DEPTH - 1);

end arch;
