library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;

library STD;
use STD.textio.all;

library work;
use work.rf_types.all;



--------------------------------------------------------------------------------
--
-- Memory loader for decision tree nodes.
--
--------------------------------------------------------------------------------
--
-- Simulates a Read-Only-Memory segment containing decision tree node data.
-- Loads a data file from specified file path and reads it line-by-line, where
--  each valid line contains exactly NODE_DATA_BITS characters, each either
--  a zero (0) or one (1).
-- Parses each valid line as sequentially stored node data wíth elements
--
--      THRESHOLD - FEATURE - LEFT_CHILD - RIGHT_CHILD - CLASS_LABEL
--
-- where each such element is read with a length specified by this loader's
--  generic arguments.
-- Skips to the next data chunk when encountering an invalid line.
--
--------------------------------------------------------------------------------
--
-- @generic ADDRESS_BITS      - Node address bit count.
-- @generic CLASS_BITS        - Bit count of classification labels.
-- @generic FEATURE_BITS      - Number of bits in feature and threshold values.
-- @generic FOREST_TREE_COUNT - Number of trees in a random forest instance.
-- @generic PATH_TO_ROM_FILE  - ROM-file path relative to VHDL compilation unit
--                               pointing at a Random Forest data file.
-- @generic TREE_INDEX        - Index of the tree for which to load data.
--
-- @in in_nodeAddress - Node address within given tree.
--
-- @out out_childL    - Address of the tree node's left child node.
-- @out out_childR    - Address of the tree node's right child node.
-- @out out_class     - Class label suggested by given tree node.
-- @out out_featureID - Index within the associated decision tree's feature set;
--                       determines which feature is used for the next node's
--                       comparison. 0xFF..F if the current node is a leaf.
-- @out out_threshold - Feature threshold value which is compared against.
--
--------------------------------------------------------------------------------

entity DecisionTreeMemory is
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
end DecisionTreeMemory;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of DecisionTreeMemory is
    
    -------------------------------------
    --  Constant and type declaration  --
    -------------------------------------
    
    constant NODE_DATA_BITS : integer := (FEATURE_BITS + FEATURE_ID_BITS + (2 * ADDRESS_BITS) + CLASS_BITS);
    constant MAX_NODE_COUNT : integer := (2**ADDRESS_BITS);
    
    constant BEGIN_INDEX_THRESHOLD   : integer := NODE_DATA_BITS;
    constant BEGIN_INDEX_FEATURE     : integer := NODE_DATA_BITS - FEATURE_BITS;
    constant BEGIN_INDEX_CHILD_L     : integer := NODE_DATA_BITS - FEATURE_BITS - FEATURE_ID_BITS;
    constant BEGIN_INDEX_CHILD_R     : integer := NODE_DATA_BITS - FEATURE_BITS - FEATURE_ID_BITS - ADDRESS_BITS;
    constant BEGIN_INDEX_CLASS_LABEL : integer := NODE_DATA_BITS - FEATURE_BITS - FEATURE_ID_BITS - (2 * ADDRESS_BITS);
	
    
    -----------------------------
    --  Component declaration  --
    -----------------------------
	
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

    
    ----------------------------
    --  Function declaration  --
    ----------------------------
    
    impure function loadForestFromFile
        return std_logic_matrix
    is
        
        file     dataFile       : text open read_mode is PATH_TO_ROM_FILE;
        variable dataFileLine   : line;
        variable nodeDataMatrix : std_logic_matrix((2**ADDRESS_BITS)-1 downto 0)(NODE_DATA_BITS-1 downto 0) := (others => (others => '0'));
        
    begin
    
        tree_data_loop : for treeIndex in 0 to FOREST_TREE_COUNT-1 loop
			
			if (treeIndex = TREE_INDEX) then
				
				node_data_loop : for nodeIndex in 0 to NODE_DATA_BITS-1 loop
                
					readline(dataFile, dataFileLine);
					
					if (dataFileLine'length < NODE_DATA_BITS) then
						exit node_data_loop;
					end if;
					
					read(dataFileLine, nodeDataMatrix(nodeIndex));
					
				end loop;
				
			end if;
			
        end loop;
        
        return nodeDataMatrix;
        
    end function;

    
    --------------------------
    --  Signal declaration  --
    --------------------------
    
    signal nodeDataMatrix : std_logic_matrix((2**ADDRESS_BITS)-1 downto 0)(NODE_DATA_BITS-1 downto 0) := loadForestFromFile;
    signal nodeData       : std_logic_vector(NODE_DATA_BITS-1 downto 0);
    
begin

	-- Feed address bits into multiplexer to retrieve loaded node data from ROM.
	mux_get_data : Mux_n_Bit
	generic map(
		INPUT_BITS  => NODE_DATA_BITS,
		SELECT_BITS => ADDRESS_BITS
	)
	port map(
		in_select => in_nodeAddress,
		in_values => nodeDataMatrix,
		out_value => nodeData
	);
    
    -- Divide node data into output fields.
    out_threshold <= nodeData(BEGIN_INDEX_THRESHOLD-1   downto BEGIN_INDEX_THRESHOLD   - FEATURE_BITS);
    out_featureID <= nodeData(BEGIN_INDEX_FEATURE-1     downto BEGIN_INDEX_FEATURE     - FEATURE_ID_BITS);
    out_childL    <= nodeData(BEGIN_INDEX_CHILD_L-1     downto BEGIN_INDEX_CHILD_L     - ADDRESS_BITS);
    out_childR    <= nodeData(BEGIN_INDEX_CHILD_R-1     downto BEGIN_INDEX_CHILD_R     - ADDRESS_BITS);
    out_class     <= nodeData(BEGIN_INDEX_CLASS_LABEL-1 downto BEGIN_INDEX_CLASS_LABEL - CLASS_BITS);

end arch;
