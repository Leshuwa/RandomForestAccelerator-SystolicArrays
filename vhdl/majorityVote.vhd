--within the majority vote component the most frequent decision is calculated and given back as finalresult

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity majorityVote is
    Port ( 
        enable : in std_logic; --enable bit used to control implementation
        a,b,c,d,e,f,g,h,i,j : in std_logic_vector(3 downto 0); -- a to j each corresponding to one of the 10 calculated decisions
        class : out std_logic_vector
        );
end majorityVote;

architecture Behavioral of majorityVote is
--array tempresults to hold all the decisions from all decision trees
   type mem is array(0 to 9) of std_logic_vector(3 downto 0);
   signal tempresults : mem;
   signal temp : std_logic_vector(3 downto 0);

begin
     
     --each of the inputs in the port is stored as an element in array tempresults (line 23-33)
     tempresults(0) <= a;
     tempresults(1) <= b;
     tempresults(2) <= c;
     tempresults(3) <= d;
     tempresults(4) <= e;
     tempresults(5) <= f;
     tempresults(6) <= g;
     tempresults(7) <= h;
     tempresults(8) <= i;
     tempresults(9) <= j;

--process below calculates the most frequent element in the array (the element that is repeated the most)
--it then stores the most frequent element in signal temp
--temp is finally given to the class as a final result
     process(tempresults, enable)
     variable countFreq, maxFreq, mostFreq : std_logic_vector(3 downto 0);
     begin
     -- when enable bit is 1 most frequent element is calculated.
     if(enable = '1') then
     maxFreq := "0000";
     mostFreq := "1111";
     --embedded for loop used to go through all the stored results in the array while keeping their frequency at hand.
     for i in 0 to 9 loop
        countFreq := "0001";
        for j in 0 to 9 loop
            if((tempresults(i) = tempresults(j)) and (i/=j)) then
                countFreq := std_logic_vector(to_unsigned((to_integer(unsigned(countFreq)) + 1), countFreq'length));
            end if; 
            if (to_integer(unsigned(maxFreq)) < to_integer(unsigned(countFreq))) then
                maxFreq := countFreq;
                mostFreq := tempresults(i);
            end if;
         end loop;  
     end loop;
     temp <= mostFreq;
     end if;
     
     end process;
     --returns class/most frequent element
     class <= temp;

end Behavioral;
