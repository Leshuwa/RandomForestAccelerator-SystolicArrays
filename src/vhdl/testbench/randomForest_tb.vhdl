library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

library work;
use work.rf_types.all;



entity RandomForest_tb is
end RandomForest_tb;



--------------------------------------------------------------------------------
-- Testbench implementation.
--------------------------------------------------------------------------------

architecture test of RandomForest_tb is

    component RandomForest
		generic(
			CLASS_LABEL_BITS  : positive;
			FEATURE_BITS      : positive;
			FEATURE_ID_BITS   : positive;
			FEATURE_ID_COUNT  : positive;
			NODE_ADDRESS_BITS : positive;
			PATH_TO_ROM_FILE  : string;
			TREE_COUNT        : positive;
			TREE_DEPTH        : positive
		);
		port(
			in_clock    : in  std_logic;
			in_reset    : in  std_logic;
			in_features : in  std_logic_matrix(0 to FEATURE_ID_COUNT-1)(FEATURE_BITS-1 downto 0);
			out_ready   : out std_logic;
			out_class   : out std_logic_vector(CLASS_LABEL_BITS-1 downto 0)
		);
    end component;

    signal in_clock_1    : std_logic;
	signal in_reset_1    : std_logic;
	signal in_features_1 : std_logic_matrix(0 to (4)-1)((4)-1 downto 0);
	signal out_ready_1   : std_logic;
	signal out_class_1   : std_logic_vector((4)-1 downto 0);

begin

    randomForest_1 : RandomForest
    generic map(
		CLASS_LABEL_BITS  => 4,
		FEATURE_BITS      => 4,
		FEATURE_ID_BITS   => 4,
		FEATURE_ID_COUNT  => 4,
		NODE_ADDRESS_BITS => 4,
		PATH_TO_ROM_FILE  => "../res/iris_forest_1.dat",
		TREE_COUNT        => 10,
		TREE_DEPTH        => 3
	)
    port map(
		in_clock    => in_clock_1,
		in_reset    => in_reset_1,
		in_features => in_features_1,
		out_ready   => out_ready_1,
		out_class   => out_class_1
    );

    process begin
	
        in_clock_1 <= '0';
		in_reset_1 <= '0';
		
		-- Reset
		in_clock_1 <= '1';
		in_reset_1 <= '1';
		wait for 0.5 ns;
		in_clock_1 <= '0';
		wait for 0.5 ns;
		
		-- First test; data supplied by last year's group
		in_features_1(0) <= "0011"; -- Sepal length
        in_features_1(1) <= "0000"; -- Sepal width
        in_features_1(2) <= "1101"; -- Petal length
        in_features_1(3) <= "0010"; -- Petal width
		in_reset_1 <= '0';
		
		while (out_ready_1 = '0') loop
			in_clock_1 <= '1';
			wait for 0.5 ns;
			in_clock_1 <= '0';
			wait for 0.5 ns;
		end loop;
		
		wait for 1.0 ns;
		
        wait;
    end process;

end test;
