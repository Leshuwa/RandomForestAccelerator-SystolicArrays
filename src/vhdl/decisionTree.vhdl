--10 instances of the DT component are called within the Random_Forest_accelerator design, each given a unique tree_number and the same sl, sw, pl, pw
--values to calculate their decisions simultaniously. this design shows how each decision is calculated in more detail.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

--entity of design has:
--5 inputs: tree_number --> used for memory access, sl, sw, pl, pw --> used for calculating decision
--1 output: class_out --> contains final decision of decision tree.
entity DT is
    port(
    tree_number : in integer;
    sepal_length : in std_logic_vector(3 downto 0); 
    sepal_width : in std_logic_vector(3 downto 0); 
    petal_length : in std_logic_vector(3 downto 0); 
    petal_width : in std_logic_vector(3 downto 0); 
    class_out : out std_logic_vector(3 downto 0) 
    
    );
end DT;

architecture Behavioral of DT is

--use of component node within the decision tree architecture
    component node is
    port(
        all_info : in std_logic_vector(19 downto 0);
        feature_to_compare : in std_logic_vector(3 downto 0);
        next_node : out std_logic_vector(3 downto 0);
        current_node : in std_logic_vector(3 downto 0)
    );
    end component;

-- memory which has all info regarding all nodes of all decision trees in Random Forest
    component DT_memory is
     Port (
        tree_num : in integer;
        currentNode : in std_logic_vector;
        allinf : out std_logic_vector(19 downto 0)
        );
    end component;
    
    signal currentNode, nextNode1, nextNode2, nextNode3 : std_logic_vector(3 downto 0);
    signal f1, f2, f3 : std_logic_vector(3 downto 0);
    signal allinf0, allinf1, allinf2, allinf3 : std_logic_vector(19 downto 0);
     
     --the blelow getFeature function takes one input and returns the feature to be used within the comparator to calculate the decision.
     --whenever feature given within parameter is:
     --0000=>sepal length must be used as feature to compare
     --0001=>sepal width must be used as feature to compare
     --0010=>petal length must be used as feature to compare
     --0011=>petal width must be used as feature to compare
     impure function getFeature (a : std_logic_vector) return std_logic_vector is 
     begin
        if a = "0000" then
            return sepal_length;
        elsif a = "0001" then
            return sepal_width;
        elsif a = "0010" then
            return petal_length;
        elsif a = "0011" then
            return petal_width;
        else return "0000";
        end if;
     end getFeature;
     

begin
    --the design must always start with current node 0(root node) which has first address in data file
    --20 bit-data of each node is fetched using the 4 instances of memory component (DT_memory), next node is given as current node after 1st iteration
    --3 instances of the component node are created since there is a max_depth of 3, each instance returns the next node(either left or right child)
    --at the end we read the class from the last node the design has reached
     currentNode <= "0000";

     instance_mem_1 : DT_memory port map(tree_num => tree_number, currentNode => currentNode, allinf => allinf0); 
     f1 <= getFeature(allinf0(15 downto 12));
     instance_node_1 : node port map(all_info => allinf0, feature_to_compare => f1, next_node => nextNode1, current_node => currentNode);
  
     instance_mem_2 : DT_memory port map(tree_num => tree_number, currentNode => nextNode1 , allinf => allinf1); 
     f2 <= getFeature(allinf1(15 downto 12)) after 1 ns;
     instance_node_2 : node port map(all_info => allinf1, feature_to_compare => f2, next_node => nextNode2, current_node => nextNode1);
     

     instance_mem_3 : DT_memory port map(tree_num => tree_number, currentNode => nextNode2, allinf => allinf2); 
     f3 <= getFeature(allinf2(15 downto 12)) after 2 ns;
     instance_node_3 : node port map(all_info => allinf2, feature_to_compare => f3, next_node => nextNode3, current_node => nextNode2);
     
     
     instance_mem_4 : DT_memory port map(tree_num => tree_number, currentNode => nextNode3, allinf => allinf3);
     class_out <= allinf3(3 downto 0);
     
end Behavioral;
