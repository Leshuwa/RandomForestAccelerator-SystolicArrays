library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

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

    
   type mem is array(0 to 9, 0 to 14) of std_logic_vector(19 downto 0);
   
    impure function InitRamFromFile (RamFileName : in string) return mem is
    file RamFile : text is in RamFileName;
    variable RamFileLine : line;
    variable RAM : mem;
    begin
        L1 : for i in 0 to 9 loop
            L2 : for j in 0 to 14 loop
                readline(RamFile, RamFileLine);
                if RamFileLine'length < 4 then
                    exit L2;
                else
                    read(RamFileLine, RAM(i,j));       
                end if;
            end loop;
        end loop;
        return RAM;   
   end function;
   
   signal RAM : mem := InitRamFromFile("/home/marji/Desktop/Fachprojekt/DT_Data/randomForest.data");
        

    component node is
    port(
        all_info : in std_logic_vector(19 downto 0);
        feature_to_compare : in std_logic_vector(3 downto 0);
        next_node : out std_logic_vector(3 downto 0);
        current_node : in std_logic_vector(3 downto 0)
    );
    end component;
    
    signal currentNode, nextNode1, nextNode2, nextNode3 : std_logic_vector(3 downto 0);
    signal f1, f2, f3 : std_logic_vector(3 downto 0);
    signal allinf0, allinf1, allinf2, allinf3 : std_logic_vector(19 downto 0);
     
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
     
     impure function getInfo (z : std_logic_vector) return std_logic_vector is
     variable switch : integer;
     begin
        switch := to_integer(unsigned(z));
        return RAM(tree_number, switch);
     end getInfo;

begin
     currentNode <= "0000";
     allinf0 <= getInfo(currentNode);
     f1 <= getFeature(allinf0(15 downto 12));
     instance_node_1 : node port map(all_info => allinf0, feature_to_compare => f1, next_node => nextNode1, current_node => currentNode);
     
     
     allinf1 <= getInfo(nextNode1);
     f2 <= getFeature(allinf1(15 downto 12)) after 1ns;
     instance_node_2 : node port map(all_info => allinf1, feature_to_compare => f2, next_node => nextNode2, current_node => nextNode1);
     
     allinf2 <= getInfo(nextNode2);
     f3 <= getFeature(allinf2(15 downto 12)) after 2ns;
     instance_node_3 : node port map(all_info => allinf2, feature_to_compare => f3, next_node => nextNode3, current_node => nextNode2);
     
     class_out <= getInfo(nextNode3)(3 downto 0);
     
end Behavioral;
