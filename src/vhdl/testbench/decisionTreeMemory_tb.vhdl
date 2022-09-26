library IEEE;
use IEEE.std_logic_1164.all;



entity DecisionTreeMemory_tb is
end DecisionTreeMemory_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of DecisionTreeMemory_tb is

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
    
    signal in_nodeAddress_1 : std_logic_vector((4)-1 downto 0) := "0000";
    signal out_childL_1     : std_logic_vector((4)-1 downto 0);
    signal out_childR_1     : std_logic_vector((4)-1 downto 0);
    signal out_class_1      : std_logic_vector((4)-1 downto 0);
    signal out_featureID_1  : std_logic_vector((4)-1 downto 0);
    signal out_threshold_1  : std_logic_vector((4)-1 downto 0);
    
    signal in_nodeAddress_2 : std_logic_vector((3)-1 downto 0) := "000";
    signal out_childL_2     : std_logic_vector((8)-1 downto 0);
    signal out_childR_2     : std_logic_vector((8)-1 downto 0);
    signal out_class_2      : std_logic_vector((6)-1 downto 0);
    signal out_featureID_2  : std_logic_vector((5)-1 downto 0);
    signal out_threshold_2  : std_logic_vector((8)-1 downto 0);

begin

    decisionTreeMemory_1 : DecisionTreeMemory
     generic map(
         ADDRESS_BITS      => 4,
         CLASS_BITS        => 4,
         FEATURE_BITS      => 4,
         FEATURE_ID_BITS   => 4,
         FOREST_TREE_COUNT => 10,
         PATH_TO_ROM_FILE  => "../res/iris_forest_1.dat",
		 TREE_INDEX        => 0
     )
    port map(
        in_nodeAddress => in_nodeAddress_1,
        out_childL     => out_childL_1,
        out_childR     => out_childR_1,
        out_class      => out_class_1,
        out_featureID  => out_featureID_1,
        out_threshold  => out_threshold_1
    );
    
    -- decisionTreeMemory_2 : DecisionTreeMemory
    -- generic map(
    --     ADDRESS_BITS      => 3,
    --     CLASS_BITS        => 6,
    --     FEATURE_BITS      => 8,
    --     FEATURE_ID_BITS   => 5,
    --     FOREST_TREE_COUNT => 17,
    --     PATH_TO_ROM_FILE  => "../res/iris_forest_2.dat",
    --     TREE_INDEX        => 0
    -- )
    -- port map(
    --     in_nodeAddress => in_nodeAddress_2,
    --     out_childL     => out_childL_2,
    --     out_childR     => out_childR_2,
    --     out_class      => out_class_2,
    --     out_featureID  => out_featureID_2,
    --     out_threshold  => out_threshold_2
    -- );

    process begin
    
        -- TODO: testbench implementation
    
        wait;
    end process;

end test;
