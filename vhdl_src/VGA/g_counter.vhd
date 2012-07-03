library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity g_counter is
    Generic ( N : integer := 08 );
    Port (
        clk : in  STD_LOGIC;
        rs  : in  STD_LOGIC;
        en  : in  STD_LOGIC;
        do  : out integer range (N-1) downto 0
    );
end g_counter;

architecture BEHAV of g_counter is
    signal c : integer range (N-1) downto 0 := 0;
begin
    process (clk) begin
        if rising_edge(clk) then
            if rs = '1' then
                c <= 0;
            elsif en = '1' then
                c <= c + 1;
            end if;
        end if;
    end process;
    do <= c;
end BEHAV;
