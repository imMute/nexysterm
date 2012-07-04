library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library unisim;
use unisim.vcomponents.all;

entity g_ireg is
    generic (
        ID : std_logic_vector(7 downto 0) := X"FF"
    );
    port (
        clk : in std_logic;
        addr : in std_logic_vector(7 downto 0);
        d : in std_logic_vector(7 downto 0);
        q : out std_logic_vector(7 downto 0)
    );
end g_ireg;

architecture low_level_definition of g_ireg is
    signal reg : std_logic_vector(7 downto 0);
begin
    
process (clk) begin
    if rising_edge(clk) then
        reg <= d;
    end if;
end process;

process (clk) begin
    if rising_edge(clk) then
        if (addr = ID) then
            q <= reg;
        else
            q <= (others => 'Z');
        end if;
    end if;
end process;


end architecture;
