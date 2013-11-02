library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package SSD_Hex_Pkg is
    function hexssd(signal input : std_logic_vector(3 downto 0)) return std_logic_vector;
end SSD_Hex_Pkg;

package body SSD_Hex_Pkg is
    function hexssd(signal input : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable ssd : std_logic_vector(7 downto 0);
    begin
        case input is
            when X"0" =>   ssd := X"3F"; -- 0    7E
            when X"1" =>   ssd := X"06"; -- 1    30
            when X"2" =>   ssd := X"5B"; -- 2    6D
            when X"3" =>   ssd := X"4F"; -- 3    79
            when X"4" =>   ssd := X"66"; -- 4    33
            when X"5" =>   ssd := X"6D"; -- 5    5B
            when X"6" =>   ssd := X"7D"; -- 6    5F
            when X"7" =>   ssd := X"07"; -- 7    70
            when X"8" =>   ssd := X"7F"; -- 8    7F
            when X"9" =>   ssd := X"6F"; -- 9    7B
            when X"A" =>   ssd := X"77"; -- A    77
            when X"B" =>   ssd := X"7C"; -- b    1F
            when X"C" =>   ssd := X"39"; -- C    4E
            when X"D" =>   ssd := X"5E"; -- d    3D
            when X"E" =>   ssd := X"79"; -- E    4F
            when X"F" =>   ssd := X"71"; -- F    47
            when others => ssd := X"80"; -- .
        end case;
        return ssd;
    end hexssd;
end SSD_Hex_Pkg;
