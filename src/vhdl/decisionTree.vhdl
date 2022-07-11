library IEEE;
library STD;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_textio.all;
use STD.textio.all;


-- 10 instances of the DT component are called within the Random_Forest_accelerator design, each given a unique tree_number and the same sl, sw, pl, pw
-- values to calculate their decisions simultaniously. this design shows how each decision is calculated in more detail.
-- entity of design has:
-- 5 inputs: tree_number --> used for memory access, sl, sw, pl, pw --> used for calculating decision
-- 1 output: class_out --> contains final decision of decision tree.

entity DecisionTree is
    port(
        tree_number  : in  integer;
        sepal_length : in  std_logic_vector(3 downto 0);
        sepal_width  : in  std_logic_vector(3 downto 0);
        petal_length : in  std_logic_vector(3 downto 0);
        petal_width  : in  std_logic_vector(3 downto 0);
        class_out    : out std_logic_vector(3 downto 0)
    );
end DecisionTree;



architecture arch of DecisionTree is

    component Node is
        port(
            all_info           : in  std_logic_vector(19 downto 0);
            feature_to_compare : in  std_logic_vector(3 downto 0);
            current_node       : in  std_logic_vector(3 downto 0);
            next_node          : out std_logic_vector(3 downto 0)
        );
    end component;

    component DecisionTreeMemory is
        port(
            tree_num    : in  integer;
            currentNode : in  std_logic_vector;
            allinf      : out std_logic_vector(19 downto 0)
        );
    end component;

    signal f1 : std_logic_vector(3 downto 0);
    signal f2 : std_logic_vector(3 downto 0);
    signal f3 : std_logic_vector(3 downto 0);

    signal allinf0 : std_logic_vector(19 downto 0);
    signal allinf1 : std_logic_vector(19 downto 0);
    signal allinf2 : std_logic_vector(19 downto 0);
    signal allinf3 : std_logic_vector(19 downto 0);

    signal currentNode : std_logic_vector(3 downto 0);
    signal nextNode1   : std_logic_vector(3 downto 0);
    signal nextNode2   : std_logic_vector(3 downto 0);
    signal nextNode3   : std_logic_vector(3 downto 0);

    -- takes one input and returns the feature to be used within the comparator to calculate the decision.
    -- whenever feature given within parameter is:
    --  0000 => sepal length must be used as feature to compare
    --  0001 => sepal width must be used as feature to compare
    --  0010 => petal length must be used as feature to compare
    --  0011 => petal width must be used as feature to compare
    impure function getFeature (a : std_logic_vector) return std_logic_vector is
    begin
        if (a = "0000") then
            return sepal_length;
        elsif (a = "0001") then
            return sepal_width;
        elsif (a = "0010") then
            return petal_length;
        elsif (a = "0011") then
            return petal_width;
        else
            return "0000";
        end if;
    end getFeature;


begin
    -- the design must always start with current node 0(root node) which has first address in data file
    -- 20 bit-data of each node is fetched using the 4 instances of memory component (DT_memory), next node is given as current node after 1st iteration
    -- 3 instances of the component node are created since there is a max_depth of 3, each instance returns the next node(either left or right child)
    -- at the end we read the class from the last node the design has reached
    currentNode <= "0000";
    decisionTreeMemory1 : DecisionTreeMemory port map(
        tree_num    => tree_number,
        currentNode => currentNode,
        allinf      => allinf0
    );

    f1 <= getFeature(allinf0(15 downto 12));

    node1 : Node port map(
        all_info           => allinf0,
        feature_to_compare => f1,
        next_node          => nextNode1,
        current_node       => currentNode
    );
    decisionTreeMemory2 : DecisionTreeMemory port map(
        tree_num    => tree_number,
        currentNode => nextNode1,
        allinf      => allinf1
    );

    f2 <= getFeature(allinf1(15 downto 12)) after 1 ns;

    node2 : Node port map(
        all_info           => allinf1,
        feature_to_compare => f2,
        next_node          => nextNode2,
        current_node       => nextNode1
    );
    decisionTreeMemory3 : DecisionTreeMemory port map(
        tree_num    => tree_number,
        currentNode => nextNode2,
        allinf      => allinf2
    );

    f3 <= getFeature(allinf2(15 downto 12)) after 2 ns;

    node3 : Node port map(
        all_info           => allinf2,
        feature_to_compare => f3,
        next_node          => nextNode3,
        current_node       => nextNode2
    );
    decisionTreeMemory4 : DecisionTreeMemory port map(
        tree_num    => tree_number,
        currentNode => nextNode3,
        allinf      => allinf3
    );

    class_out <= allinf3(3 downto 0);

end arch;
