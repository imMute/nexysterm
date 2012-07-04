library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library unisim;
use unisim.vcomponents.all;

entity g_oreg is
    generic (
        ID : std_logic_vector(7 downto 0) := X"FF"
    );
    port (
        clk : in std_logic;
        addr : in std_logic_vector(7 downto 0);
        we : in std_logic;
        d : in std_logic_vector(7 downto 0);
        q : out std_logic_vector(7 downto 0)
    );
end g_oreg;

architecture low_level_definition of g_oreg is
    signal reg : std_logic_vector(7 downto 0);
begin
    
process (clk) begin
    if rising_edge(clk) then
        if (addr = ID and we = '1') then
            reg <= d;
        end if;
    end if;
end process;

q <= reg;

end architecture;
