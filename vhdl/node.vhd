--node calculates the next node, and returns the address of the left/right child of current node.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--node has:
--3 input --> all_info(20 bit data of all node information containing threshold, feature, lc, rc, and class
--            feature_to_compare: given from the DT design and is used by the comparator.
--            current_node
--1 output --> next_node: returns next_node to continue iteration through decision tree
entity node is
    port(
        all_info : in std_logic_vector(19 downto 0);
        feature_to_compare : in std_logic_vector(3 downto 0);
        next_node : out std_logic_vector(3 downto 0);
        current_node : in std_logic_vector(3 downto 0)
    );
end node;

architecture Behavioral of node is

    --component comparator used in design
    component comparator is
        port(
		  feature : in std_logic_vector(3 downto 0);
		  threshold: in std_logic_vector(3 downto 0);
		  greater: out std_logic;
		  less_equal: out std_logic
		);
    end component;
    
    signal greater_than, less_than_equal : std_logic;
    signal lc, rc, th, ft : std_logic_vector(3 downto 0);
    
begin
           --this is summary of lc,rc,th,ft address within all_info. each address corrosponds to a value
           lc <= all_info(11 downto 8);
           rc <= all_info(7 downto 4);
           th <= all_info(19 downto 16);
           ft <= all_info(15 downto 12);  
           
     --the comparator is given the feature, threshold and determines whether its greater than or lessthan/equal.
     comparator_instance : comparator port map(feature => feature_to_compare, threshold => th , greater => greater_than, less_equal => less_than_equal);
     
     --in summary if feature was greater than threshold next_node will be the right child, and if not next_node = left child
     process(less_than_equal, greater_than)
     begin
     if(ft /= "1111") then
           if(less_than_equal = '1') then
                  next_node <= lc;      
           elsif(greater_than = '1') then
                  next_node <= rc;
           end if;
     else 
            next_node <= current_node;
     end if;   
     end process;
end Behavioral;
