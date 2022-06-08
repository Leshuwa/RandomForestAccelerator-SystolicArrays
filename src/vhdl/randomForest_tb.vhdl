library IEEE;
use IEEE.std_logic_1164.ALL;



-- this is the testbench of the random-forest-accelerator design. which is used to test
-- and simulate the random-forest-accelerator with user-given values.

entity RandomForest_tb is
end RandomForest_tb;



architecture test of RandomForest_tb is

    -- the testbench uses the Random-Forest_accelerator within its architecture
    component RandomForest
        port(
            sepal_length : in  std_logic_vector(3 downto 0);
            sepal_width  : in  std_logic_vector(3 downto 0);
            petal_length : in  std_logic_vector(3 downto 0);
            petal_width  : in  std_logic_vector(3 downto 0);
            class_out    : out std_logic_vector(3 downto 0) -- limited to "0000" (setosa), "0001" (versicolor), and "0010" (virginica)
        );
    end component;

    signal sepal_length : std_logic_vector(3 downto 0);
    signal sepal_width  : std_logic_vector(3 downto 0);
    signal petal_length : std_logic_vector(3 downto 0);
    signal petal_width  : std_logic_vector(3 downto 0);
    signal class_out    : std_logic_vector(3 downto 0);

begin

    randomForest1 : RandomForest port map(
        sepal_length => sepal_length,
        sepal_width  => sepal_width,
        petal_length => petal_length,
        petal_width  => petal_width,
        class_out    => class_out
    );

    -- values of sepal_length, sepal_width, petal_length, petal_width givin within the process below:
    -- please give test-inputs one input at a time as shown below
    -- (design not configured to test multiple test-inputs in a row)
    process begin
        sepal_length <= "0011";
        sepal_width  <= "0000";
        petal_length <= "1101";
        petal_width  <= "0010";
        wait for 50 ns;
        wait;
    end process;

end test;
