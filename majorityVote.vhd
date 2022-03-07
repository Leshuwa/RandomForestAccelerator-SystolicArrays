library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity majorityVote is
    Port ( 
        enable : in std_logic;
        a,b,c,d,e,f,g,h,i,j : in std_logic_vector(3 downto 0);
        class : out std_logic_vector
        );
end majorityVote;

architecture Behavioral of majorityVote is
   type mem is array(0 to 9) of std_logic_vector(3 downto 0);
   signal khara : mem;
--   signal maxFreq, mostFreq : std_logic_vector(3 downto 0);
   signal kkk : std_logic_vector(3 downto 0);

begin
     
     khara(0) <= a;
     khara(1) <= b;
     khara(2) <= c;
     khara(3) <= d;
     khara(4) <= e;
     khara(5) <= f;
     khara(6) <= g;
     khara(7) <= h;
     khara(8) <= i;
     khara(9) <= j;

     
     

     process(khara, enable)
     variable countFreq, maxFreq, mostFreq : std_logic_vector(3 downto 0);
     begin
     if(enable = '1') then
     maxFreq := "0000";
     mostFreq := "1111";
     for i in 0 to 9 loop
        countFreq := "0001";
        for j in 0 to 9 loop
            if((khara(i) = khara(j)) and (i/=j)) then
                countFreq := std_logic_vector(to_unsigned((to_integer(unsigned(countFreq)) + 1), countFreq'length));
            end if; 
            if (to_integer(unsigned(maxFreq)) < to_integer(unsigned(countFreq))) then
                maxFreq := countFreq;
                mostFreq := khara(i);
            end if;
         end loop;  
     end loop;
     kkk <= mostFreq;
     end if;
     
     end process;
     
     class <= kkk;

end Behavioral;
