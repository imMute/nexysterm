library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.SSD_Hex_Pkg.all;

entity SSD_Hex is
    port (
        clk         : in  std_logic;
        data        : in  std_logic_vector(15 downto 0);
        segments    : out std_logic_vector(7 downto 0);
        anodes      : out std_logic_vector(3 downto 0)
    );
end SSD_Hex;

architecture BEHAV of SSD_Hex is
    signal s_driver_data        : std_logic_vector(31 downto 0);
begin

s_driver_data( 7 downto  0) <= hexssd(data( 3 downto 0));
s_driver_data(15 downto  8) <= hexssd(data( 7 downto 4));
s_driver_data(23 downto 16) <= hexssd(data(11 downto 8));
s_driver_data(31 downto 24) <= hexssd(data(15 downto 12));

SSD_Driver_i: entity SSD_Driver
    port map (
        clk         => clk,
        data        => s_driver_data,
        segments    => segments,
        anodes      => anodes
    );

end architecture;
