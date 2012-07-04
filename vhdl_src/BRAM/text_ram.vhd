----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:06:45 07/01/2012 
-- Design Name: 
-- Module Name:    CRG - behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity text_ram is
    Port (
        -- Port A (writer)
        i_wr_clk    : in std_logic;
        i_wr_en     : in std_logic;
        i_wr_addr   : in std_logic_vector(10 downto 0);
        i_wr_data   : in std_logic_vector(7 downto 0);
        -- Port B (reader)
        i_rd_clk    : in std_logic;
        --i_rd_en     : in std_logic;
        i_rd_addr   : in std_logic_vector(10 downto 0);
        o_rd_data   : out std_logic_vector(7 downto 0)
    );
end text_ram;

architecture Behavioral of text_ram is
    signal CLKA,CLKB    : std_logic;
    signal ADDRA,ADDRB  : std_logic_vector(10 downto 0);
    signal DIA,DOB      : std_logic_vector(7 downto 0);
    
    signal ENA,WEA      : std_logic;
begin
CLKB <= i_rd_clk;
ADDRB <= i_rd_addr;
o_rd_data <= DOB;

CLKA <= i_wr_clk;
ENA <= i_wr_en;
WEA <= ENA;
DIA <= i_wr_data;


text_ram_bram : RAMB16_S9_S9
    generic map (
        INIT_A => X"000", -- Value of output RAM registers on Port A at startup
        INIT_B => X"000", -- Value of output RAM registers on Port B at startup
        SRVAL_A => X"000", -- Port A ouput value upon SSR assertion
        SRVAL_B => X"000", -- Port B ouput value upon SSR assertion
        WRITE_MODE_A => "READ_FIRST", -- WRITE_FIRST, READ_FIRST or NO_CHANGE
        WRITE_MODE_B => "READ_FIRST", -- WRITE_FIRST, READ_FIRST or NO_CHANGE
        SIM_COLLISION_CHECK => "NONE", -- "NONE", "WARNING", "GENERATE_X_ONLY", "ALL"
        INIT_00 => X"000000000000000000000000000000000f0e0d0c0b0a09080706050403020100",
        INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_02 => X"000000000000000000000000000000000f0e0d0c0b0a09080706050403020100",
        INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000"
    )
    port map (
        DOA     => open,
        DOPA    => open,
        ADDRA   => ADDRA,
        CLKA    => CLKA,
        DIA     => DIA,
        DIPA    => (others => '0'),
        ENA     => ENA,
        SSRA    => '0',
        WEA     => WEA,
        
        DOB     => DOB,
        DOPB    => open,
        ADDRB   => ADDRB,
        CLKB    => CLKB,
        DIB     => (others => '0'),
        DIPB    => (others => '0'),
        ENB     => '1',
        SSRB    => '0',
        WEB     => '0'
    );


end architecture;
