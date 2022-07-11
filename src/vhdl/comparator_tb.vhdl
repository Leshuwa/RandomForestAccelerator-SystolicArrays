library IEEE;
use IEEE.std_logic_1164.all;



entity Comparator_tb is
end Comparator_tb;



architecture test of Comparator_tb is

    component Comparator is
        port(
            feature    : in  std_logic_vector(3 downto 0);
            threshold  : in  std_logic_vector(3 downto 0);
            greater    : out std_logic;
            less_equal : out std_logic
        );
    end component;
	
	signal feature    : std_logic_vector(3 downto 0);
	signal threshold  : std_logic_vector(3 downto 0);
	signal greater    : std_logic;
	signal less_equal : std_logic;

begin

    comparator1 : Comparator port map(
        feature    => feature,
		threshold  => threshold,
		greater    => greater,
		less_equal => less_equal
	);

    process begin

        feature   <= "0000";
		threshold <= "0000";
		wait for 1 ns;
        assert greater = '0' and less_equal = '1'
	     report "Error: 0x10"
         severity ERROR;

		feature   <= "0001";
		threshold <= "0000";
		wait for 1 ns;
        assert greater = '1' and less_equal = '0'
	     report "Error: 0x20"
         severity ERROR;

		feature   <= "1010";
		threshold <= "0000";
		wait for 1 ns;
        assert greater = '1' and less_equal = '0'
	     report "Error: 0x21"
         severity ERROR;

		feature   <= "1111";
		threshold <= "0000";
		wait for 1 ns;
        assert greater = '1' and less_equal = '0'
	     report "Error: 0x22"
         severity ERROR;

		feature   <= "0110";
		threshold <= "0101";
		wait for 1 ns;
        assert greater = '1' and less_equal = '0'
	     report "Error: 0x30"
         severity ERROR;

		feature   <= "0110";
		threshold <= "0110";
		wait for 1 ns;
        assert greater = '0' and less_equal = '1'
	     report "Error: 0x31"
         severity ERROR;

		feature   <= "0110";
		threshold <= "1000";
		wait for 1 ns;
        assert greater = '0' and less_equal = '1'
	     report "Error: 0x32"
         severity ERROR;
		
		wait;
    end process;

end test;