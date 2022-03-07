library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RF_tb is
end RF_tb;

architecture Behavioral of RF_tb is
    
    component Random_Forest_accelerator
       port(
        sepal_length : in std_logic_vector(3 downto 0); -- 0000
        sepal_width : in std_logic_vector(3 downto 0); -- 0001
        petal_length : in std_logic_vector(3 downto 0); -- 0010
        petal_width : in std_logic_vector(3 downto 0); -- 0011
        class_out : out std_logic_vector(3 downto 0) --0000 -> Setosa -- 0001 -> versicolor -- 0010 -> virginica--
     );
    end component;

    
    signal sepal_length, sepal_width, petal_length, petal_width : std_logic_vector (3 downto 0);
    signal class_out : std_logic_vector(3 downto 0);
    
begin
    
    instance_Random_Forest : Random_Forest_accelerator port map(sepal_length => sepal_length, sepal_width => sepal_width,
                                         petal_length => petal_length, petal_width => petal_width, class_out => class_out);

    process begin
    
    sepal_length <= "0011";
    sepal_width <= "0000";
    petal_length <= "1101";
    petal_width <= "0010";
    wait for 50ns;
    sepal_length <= "0101";
    sepal_width <= "1000";
    petal_length <= "0100";
    petal_width <= "1001";
    wait for 50ns;
    sepal_length <= "1011";
    sepal_width <= "0000";
    petal_length <= "1010";
    petal_width <= "1101";
    wait for 50ns;
    sepal_length <= "1011";
    sepal_width <= "0000";
    petal_length <= "0100";
    petal_width <= "0010";
    wait for 50ns;
    wait;
    end process;
    
end Behavioral;



    
    