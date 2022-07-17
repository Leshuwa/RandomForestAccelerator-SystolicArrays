library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;



-- node calculates the next node, and returns the address of the left/right child of current node.
-- node has:
-- 3 input --> all_info(20 bit data of all node information containing threshold, feature, lc, rc, and class
--             feature_to_compare: given from the DT design and is used by the comparator.
--             current_node
-- 1 output --> next_node: returns next_node to continue iteration through decision tree

entity Node is
    port(
        all_info           : in  std_logic_vector(19 downto 0);
        feature_to_compare : in  std_logic_vector(3 downto 0);
        current_node       : in  std_logic_vector(3 downto 0);
        next_node          : out std_logic_vector(3 downto 0)
    );
end Node;



architecture arch of Node is

    component Comparator_n_Bit is
		generic(
			INPUT_BITS : integer := 4
		);
        port(
			in_threshold : in  std_logic_vector(INPUT_BITS-1 downto 0);
			in_value     : in  std_logic_vector(INPUT_BITS-1 downto 0);
			out_equal    : out std_logic;
			out_greater  : out std_logic;
			out_less     : out std_logic
        );
    end component;

    signal childL    : std_logic_vector(3 downto 0);
    signal childR    : std_logic_vector(3 downto 0);
	signal feature   : std_logic_vector(3 downto 0);
    signal threshold : std_logic_vector(3 downto 0);
	
	signal greater : std_logic;

begin
    -- Read 4-Bit fields from loaded node information.
	threshold <= all_info(19 downto 16);
    feature   <= all_info(15 downto 12);
    childL    <= all_info(11 downto 8);
	childR    <= all_info(7 downto 4);

    -- Passing feature and threshold to the comparator; we only care about the 'greater'-bit.
    comparator0 : Comparator_n_Bit
	port map(
        in_threshold => threshold,
        in_value     => feature,
        out_greater  => greater
    );

	-- Select right child as next node if the feature exceeded its threshold, the left child otherwise.
    process(greater)
    begin
        if (feature /= "1111") then
			if (greater = '1') then
				next_node <= childR;
			else
				next_node <= childL;
			end if;
        else
			next_node <= current_node;
        end if;
    end process;

end arch;
