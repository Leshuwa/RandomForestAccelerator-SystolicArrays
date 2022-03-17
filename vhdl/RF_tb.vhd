--this is the testbench of the random-forest-accelerator design. which is used to test
--and simulate the random-forest-accelerator with user-given values.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--entity of testbench has no ports.
entity RF_tb is
end RF_tb;

architecture Behavioral of RF_tb is
    
    --the testbench uses the Random-Forest_accelerator within its architecture
    component Random_Forest_accelerator
       port(
        sepal_length : in std_logic_vector(3 downto 0);
        sepal_width : in std_logic_vector(3 downto 0); 
        petal_length : in std_logic_vector(3 downto 0); 
        petal_width : in std_logic_vector(3 downto 0); 
        class_out : out std_logic_vector(3 downto 0) 
 -- class_out can have 3 possible outputs only "0000"=>(setosa), "0001"=>(versicolor), "0010"=>(virginica)
     );
    end component;

    --some signal definitions to call on the port map of the Random_Forest_accelerator
    signal sepal_length, sepal_width, petal_length, petal_width : std_logic_vector (3 downto 0);
    signal class_out : std_logic_vector(3 downto 0);
    
begin
    
    instance_Random_Forest : Random_Forest_accelerator port map(sepal_length => sepal_length, sepal_width => sepal_width,
                                         petal_length => petal_length, petal_width => petal_width, class_out => class_out);

-- values of sepal_length, sepal_width, petal_length, petal_width givin within the process below:
--please give test-inputs one input at a time as shown below 
--(design not configured to test multiple test-inputs in a row)
    process begin
    sepal_length <= "0011";
    sepal_width <= "0000";
    petal_length <= "1101";
    petal_width <= "0010";
    wait for 50ns;
    wait;
    end process;
    
end Behavioral;



    
    
