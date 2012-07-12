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

entity RAMB16_S16_S16 is
    Port (
        -- Port A (writer)
        CLKA    : in std_logic;
        ENA     : in std_logic;
        ADDRA   : in std_logic_vector(10 downto 0);
        DATAA   : in std_logic_vector(15 downto 0);
        -- Port B (reader)
        CLKB    : in std_logic;
        --i_rd_en     : in std_logic;
        ADDRB   : in std_logic_vector(10 downto 0);
        DATAB   : out std_logic_vector(15 downto 0)
    );
end RAMB16_S16_S16;

architecture Behavioral of RAMB16_S16_S16 is
    signal DIA,DOB      : std_logic_vector(7 downto 0);
    signal DIAx,DOBx    : std_logic_vector(7 downto 0);
    signal WEA          : std_logic;
begin
DATAB(7 downto 0) <= DOB;
DATAB(15 downto 8) <= DOBx;
WEA <= ENA;
DIA <= DATAA(7 downto 0);
DIAx <= DATAA(15 downto 8);


text_ram_bram : RAMB16_S9_S9
    generic map (
        INIT_A => X"000", -- Value of output RAM registers on Port A at startup
        INIT_B => X"000", -- Value of output RAM registers on Port B at startup
        SRVAL_A => X"000", -- Port A ouput value upon SSR assertion
        SRVAL_B => X"000", -- Port B ouput value upon SSR assertion
        WRITE_MODE_A => "READ_FIRST", -- WRITE_FIRST, READ_FIRST or NO_CHANGE
        WRITE_MODE_B => "READ_FIRST", -- WRITE_FIRST, READ_FIRST or NO_CHANGE
        SIM_COLLISION_CHECK => "NONE", -- "NONE", "WARNING", "GENERATE_X_ONLY", "ALL"
        INIT_00 => X"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100",
        INIT_01 => X"3f3e3d3c3b3a393837363534333231302f2e2d2c2b2a29282726252423222120",
        INIT_02 => X"5f5e5d5c5b5a595857565554535251504f4e4d4c4b4a49484746454443424140",
        INIT_03 => X"7f7e7d7c7b7a797877767574737271706f6e6d6c6b6a69686766656463626160",
        INIT_04 => X"9f9e9d9c9b9a999897969594939291908f8e8d8c8b8a89888786858483828180",
        INIT_05 => X"bfbebdbcbbbab9b8b7b6b5b4b3b2b1b0afaeadacabaaa9a8a7a6a5a4a3a2a1a0",
        INIT_06 => X"dfdedddcdbdad9d8d7d6d5d4d3d2d1d0cfcecdcccbcac9c8c7c6c5c4c3c2c1c0",
        INIT_07 => X"fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0"
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

control_ram_bram : RAMB16_S9_S9
    generic map (
        INIT_A => X"000", -- Value of output RAM registers on Port A at startup
        INIT_B => X"000", -- Value of output RAM registers on Port B at startup
        SRVAL_A => X"000", -- Port A ouput value upon SSR assertion
        SRVAL_B => X"000", -- Port B ouput value upon SSR assertion
        WRITE_MODE_A => "READ_FIRST", -- WRITE_FIRST, READ_FIRST or NO_CHANGE
        WRITE_MODE_B => "READ_FIRST", -- WRITE_FIRST, READ_FIRST or NO_CHANGE
        SIM_COLLISION_CHECK => "NONE", -- "NONE", "WARNING", "GENERATE_X_ONLY", "ALL"
        INIT_00 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
        INIT_01 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
        INIT_02 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
        INIT_03 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
        INIT_04 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
        INIT_05 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
        INIT_06 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
        INIT_07 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
        INIT_08 => X"2525252525252525252525252525252525252525252525252525252525252525",
        INIT_09 => X"2525252525252525252525252525252525252525252525252525252525252525",
        INIT_0A => X"2525252525252525252525252525252525252525252525252525252525252525",
        INIT_0B => X"2525252525252525252525252525252525252525252525252525252525252525",
        INIT_0C => X"2525252525252525252525252525252525252525252525252525252525252525",
        INIT_0D => X"2525252525252525252525252525252525252525252525252525252525252525",
        INIT_0E => X"2525252525252525252525252525252525252525252525252525252525252525",
        INIT_0F => X"2525252525252525252525252525252525252525252525252525252525252525"
    )
    port map (
        DOA     => open,
        DOPA    => open,
        ADDRA   => ADDRA,
        CLKA    => CLKA,
        DIA     => DIAx,
        DIPA    => (others => '0'),
        ENA     => ENA,
        SSRA    => '0',
        WEA     => WEA,
        
        DOB     => DOBx,
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
