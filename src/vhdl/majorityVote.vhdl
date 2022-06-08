library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.ALL;



--within the majority vote component the most frequent decision is calculated and given back as finalresult

entity MajorityVote is
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
end MajorityVote;



architecture arch of MajorityVote is

   type mem is array(0 to 9) of std_logic_vector(3 downto 0); -- holds all decisions from all decision trees
   signal tempresults : mem;
   signal temp        : std_logic_vector(3 downto 0);

begin
     
    -- each input in the port is stored as an element in tempresults
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

    -- process below calculates the most frequent element in the array (the element that is repeated the most)
    -- it then stores the most frequent element in signal temp
    -- temp is finally given to the class as a final result
    process(tempresults, enable)
        variable countFreq, maxFreq, mostFreq : std_logic_vector(3 downto 0);
    begin
        
        -- when enable bit is 1 most frequent element is calculated.
        if (enable = '1') then
            maxFreq := "0000";
            mostFreq := "1111";
        
            --embedded for loop used to go through all the stored results in the array while keeping their frequency at hand.
            for q in 0 to 9 loop
                countFreq := "0001";
                for r in 0 to 9 loop
                    if ((tempresults(q) = tempresults(r)) and (q/=r)) then
                        countFreq := std_logic_vector(to_unsigned((to_integer(unsigned(countFreq)) + 1), countFreq'length));
                    end if; 
                    if (to_integer(unsigned(maxFreq)) < to_integer(unsigned(countFreq))) then
                        maxFreq  := countFreq;
                        mostFreq := tempresults(q);
                    end if;
                end loop;  
            end loop;
            temp <= mostFreq;
        end if;
    
    end process;
    --returns class/most frequent element
    class <= temp;

end arch;
