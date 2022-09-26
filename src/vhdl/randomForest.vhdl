library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.ALL;

library work;
use work.rf_types.all;



--------------------------------------------------------------------------------
--
-- Random Forest-based implementation of a classification algorithm.
--
--------------------------------------------------------------------------------
--
-- Feeds given feature set into a pre-defined number of decision trees. Each
--  tree calculates their own suggested classification for given feature set.
-- These suggested class labels are then handed to a majority vote component
--  to decide for a final classification.
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
--
-- @in in_clock    - Clock input used to update the counter and queue components.
-- @in in_reset    - Synchronously resets the current calculation and outputs.
-- @in in_features - Input matrix containing a feature set for classification.
--
-- @out out_ready - Outputs '1' once calculation has finished.
-- @out out_class - Selected class value; only valid while out_ready is '1'.
--
--------------------------------------------------------------------------------

entity RandomForest is
	generic(
		CLASS_LABEL_BITS  : positive;
		FEATURE_BITS      : positive;
		FEATURE_ID_BITS   : positive;
		FEATURE_ID_COUNT  : positive;
		NODE_ADDRESS_BITS : positive;
		PATH_TO_ROM_FILE  : string;
		TREE_COUNT        : positive;
		TREE_DEPTH        : positive
	);
    port(
		in_clock    : in  std_logic;
		in_reset    : in  std_logic;
		in_features : in  std_logic_matrix(0 to FEATURE_ID_COUNT-1)(FEATURE_BITS-1 downto 0);
		out_ready   : out std_logic;
		out_class   : out std_logic_vector(CLASS_LABEL_BITS-1 downto 0)
    );
end RandomForest;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of RandomForest is
    
    -----------------------------
    --  Component declaration  --
    -----------------------------

	component DecisionTree is
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
	end component;

    component MajorityVote
		generic(
			CLASS_COUNT_LOG_2 : positive;
			CLASS_LABEL_BITS  : positive
		);
		port(
			in_clock  : in  std_logic;
			in_labels : in  std_logic_matrix(0 to (2**CLASS_COUNT_LOG_2)-1)(CLASS_LABEL_BITS-1 downto 0);
			in_reset  : in  std_logic;
			out_ready : out std_logic;
			out_class : out std_logic_vector(CLASS_LABEL_BITS-1 downto 0)
		);
    end component;
    
    
    --------------------------
    --  Signal declaration  --
    --------------------------
	
	signal enableMajorityVote : std_logic := '0';
	signal decisionTreeReady  : std_logic_vector(0 to TREE_COUNT-1);
	signal decisionTreeClass  : std_logic_matrix(0 to TREE_COUNT-1)(CLASS_LABEL_BITS-1 downto 0);
	
	signal classLabelsPadded : std_logic_matrix(0 to (2**TREE_COUNT)-1)(CLASS_LABEL_BITS-1 downto 0);
	signal classLabelInverse : std_logic_vector(CLASS_LABEL_BITS-1 downto 0);

begin

	-- Generate decision trees for this random forest.
	genDecisionTrees:
	for i in 0 to TREE_COUNT-1 generate
	
		decisionTree_1 : DecisionTree
		generic map(
			CLASS_LABEL_BITS  => CLASS_LABEL_BITS,
			FEATURE_BITS      => FEATURE_BITS,
			FEATURE_ID_BITS   => FEATURE_ID_BITS,
			FEATURE_ID_COUNT  => FEATURE_ID_COUNT,
			NODE_ADDRESS_BITS => NODE_ADDRESS_BITS,
			PATH_TO_ROM_FILE  => PATH_TO_ROM_FILE,
			TREE_COUNT        => TREE_COUNT,
			TREE_DEPTH        => TREE_DEPTH,
			TREE_INDEX        => i
		)
		port map(
			in_features  => in_features,
			out_ready    => decisionTreeReady(i),
			out_class    => decisionTreeClass(i)
		);
	
	end generate;
	
	-- Majority vote component gets enabled only after all decision trees completed calculation.
	enableMajorityVote <= (AND decisionTreeReady);
	
	-- Store inverse (!) decision tree class labels in class label input array, pad empty elements.
	--  DT class labels need to be inverse as values 0x00..0 are ignored by the majority vote component.
	genClassLabelLinks:
	for i in 0 to (2**TREE_COUNT)-1 generate
	
		genMoveDecisionTreeLabels:
		if (i < TREE_COUNT) generate
			classLabelsPadded(i) <= decisionTreeClass(i);
		end generate;
		
		genClassLabelPadding:
		if (i >= TREE_COUNT) generate
			classLabelsPadded(i) <= (others => '1');
		end generate;
	
	end generate;
	
	-- Generate majority vote component and link results.
	majorityVote_1 : MajorityVote
	generic map(
		CLASS_COUNT_LOG_2 => TREE_COUNT, -- FIXME: This should actually be ceil(log_2(TREE_COUNT))
		CLASS_LABEL_BITS  => CLASS_LABEL_BITS
	)
	port map(
		in_clock  => in_clock AND enableMajorityVote,
		in_labels => classLabelsPadded,
		in_reset  => in_reset,
		out_ready => out_ready,
		out_class => classLabelInverse
	);
	
	-- Result is the inverse of the suggested class label.
	out_class <= (NOT classLabelInverse);

end arch;
