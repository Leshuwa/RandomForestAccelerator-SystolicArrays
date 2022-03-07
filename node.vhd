library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity node is
    port(
        all_info : in std_logic_vector(19 downto 0);
        feature_to_compare : in std_logic_vector(3 downto 0);
        next_node : out std_logic_vector(3 downto 0);
        current_node : in std_logic_vector(3 downto 0)
    );
end node;

architecture Behavioral of node is

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
           lc <= all_info(11 downto 8);
           rc <= all_info(7 downto 4);
           th <= all_info(19 downto 16);
           ft <= all_info(15 downto 12);  
           
     
     comparator_instance : comparator port map(feature => feature_to_compare, threshold => th , greater => greater_than, less_equal => less_than_equal);
     
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
