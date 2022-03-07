library IEEE;
use IEEE.std_logic_1164.all;

entity Comparator is
	port(
		feature : in std_logic_vector(3 downto 0);
		threshold : in std_logic_vector(3 downto 0);
		greater : out std_logic;
		less_equal : out std_logic
		);
end Comparator;

architecture behavior of Comparator is
	procedure comp1bit(
					ft: in std_logic;
					th: in std_logic;
					Gin: in std_logic;
					Lin: in std_logic;
					Gout: out std_logic;
					Lout: out std_logic;
					Eout: out std_logic) is
	begin
		Gout:= (ft and not th) or (ft and Gin) or (not th and Gin);
		Eout:= (not ft and not ft and not Gin and not Lin) or
		       (ft and th and not Gin and not Lin);
		Lout := (not ft and th) or (not ft and Lin) or (th and Lin);
	end procedure;
	
begin
	process(feature,threshold)
	variable G, L, E: std_logic_vector(4 downto 0);
	begin
		G(0) := '0';
		L(0) := '0';
		for i in 0 to 3 loop
			comp1bit(feature(i),threshold(i),G(i),L(i),G(i+1),L(i+1),E(i+1));
		end loop;
		greater <= G(4);
		less_equal <= E(4) or L(4);
	end process;
end behavior;
		
