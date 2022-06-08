library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.ALL;



-- entity of design has:
-- 4 inputs (sepal_length, sepal_width, petal_length, petal_width) each 4 bits which are the features of the iris data-set
-- 1 output: class_out can have 3 possible outputs only "0000"=>(setosa), "0001"=>(versicolor), "0010"=>(virginica)

entity RandomForest is
    port(
        sepal_length : in  std_logic_vector(3 downto 0);
        sepal_width  : in  std_logic_vector(3 downto 0);
        petal_length : in  std_logic_vector(3 downto 0);
        petal_width  : in  std_logic_vector(3 downto 0);
        class_out    : out std_logic_vector(3 downto 0)
    );

end RandomForest;



architecture arch of RandomForest is

    -- array results below stores the class from each of the 10 decision trees which will then be
    -- used in the majority vote component to calculate the final decision.
    type mem is array(0 to 9) of std_logic_vector(3 downto 0);

    signal results     : mem;
    signal finalresult : std_logic_vector(3 downto 0); -- signal for the final decision of the design
    signal en          : std_logic; -- enable bit used in the majority vote component

    component MajorityVote
        port(
            enable : in  std_logic;
            a      : in  std_logic_vector(3 downto 0);
            b      : in  std_logic_vector(3 downto 0);
            c      : in  std_logic_vector(3 downto 0);
            d      : in  std_logic_vector(3 downto 0);
            e      : in  std_logic_vector(3 downto 0);
            f      : in  std_logic_vector(3 downto 0);
            g      : in  std_logic_vector(3 downto 0);
            h      : in  std_logic_vector(3 downto 0);
            i      : in  std_logic_vector(3 downto 0);
            j      : in  std_logic_vector(3 downto 0);
            class  : out std_logic_vector
        );
    end component;

    component DecisionTree
        port(
            tree_number  : in  integer;
            sepal_length : in  std_logic_vector(3 downto 0);
            sepal_width  : in  std_logic_vector(3 downto 0);
            petal_length : in  std_logic_vector(3 downto 0);
            petal_width  : in  std_logic_vector(3 downto 0);
            class_out    : out std_logic_vector(3 downto 0)
        );
    end component;

begin
    -- 10 instances of the DT component are called, each given a unique tree_number and the same sl, sw, pl, pw values to calculate their decisions simultaniously
    -- the calculated decision is then stored in results(tree_number) which will then be used in the majority_vote component.
    decisionTree0 : DecisionTree port map(tree_number => 0, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(0));
    decisionTree1 : DecisionTree port map(tree_number => 1, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(1));
    decisionTree2 : DecisionTree port map(tree_number => 2, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(2));
    decisionTree3 : DecisionTree port map(tree_number => 3, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(3));
    decisionTree4 : DecisionTree port map(tree_number => 4, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(4));
    decisionTree5 : DecisionTree port map(tree_number => 5, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(5));
    decisionTree6 : DecisionTree port map(tree_number => 6, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(6));
    decisionTree7 : DecisionTree port map(tree_number => 7, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(7));
    decisionTree8 : DecisionTree port map(tree_number => 8, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(8));
    decisionTree9 : DecisionTree port map(tree_number => 9, sepal_length => sepal_length, sepal_width => sepal_width, petal_length => petal_length, petal_width => petal_width, class_out => results(9));

    -- delay used to wait for the calculated decision from each of the 10 decision trees
    en <= '1' after 3 ns;

    -- within the majority vote component the most frequent decision is calculated and given back as finalresult
    majorityVote1 : MajorityVote port map(
        enable => en,
        a => results(0),
        b => results(1),
        c => results(2),
        d => results(3),
        e => results(4),
        f => results(5),
        g => results(6),
        h => results(7),
        i => results(8),
        j => results(9),
        class => finalresult
    );

    class_out <= finalresult;

end arch;
