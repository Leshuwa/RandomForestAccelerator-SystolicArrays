library IEEE;
use IEEE.std_logic_1164.all;


library work;
use work.rf_types.all;


entity DecisionTree_tb is
end DecisionTree_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of DecisionTree_tb is

	component DecisionTree is
		generic(
			CLASS_LABEL_BITS  : integer := 4;
			FEATURE_BITS      : integer := 4;
			FEATURE_ID_BITS   : integer := 4;
			FEATURE_ID_COUNT  : integer := 4;
			NODE_ADDRESS_BITS : integer := 4;
			TREE_COUNT        : integer := 10;
			TREE_DEPTH        : integer := 3
		);
		port(
			in_treeIndex : in  integer;
			in_features  : in  std_logic_matrix(0 to FEATURE_ID_COUNT-1)(FEATURE_BITS-1 downto 0);
			out_ready    : out std_logic;
			out_class    : out std_logic_vector(CLASS_LABEL_BITS-1 downto 0)
		);
	end component;
	
	signal in_treeIndex_1 : integer := 0;
	signal in_features_1  : std_logic_matrix(0 to (4)-1)((4)-1 downto 0) := (others => "0000");
	signal out_ready_1    : std_logic;
	signal out_class_1    : std_logic_vector((4)-1 downto 0);

begin

	decisionTree_1 : DecisionTree
	port map(
		in_treeIndex => in_treeIndex_1,
		in_features  => in_features_1,
		out_ready    => out_ready_1,
		out_class    => out_class_1
	);
	
	process begin
	
		in_features_1(0) <= "0010";
		in_features_1(1) <= "0110";
		in_features_1(2) <= "1010";
		in_features_1(3) <= "0111";
		
		wait until (out_ready_1 = '1');
		wait for 1 ns;
	
		-- TODO: Further testbench implementation
	
		wait;
	end process;

end test;