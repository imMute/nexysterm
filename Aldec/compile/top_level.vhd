-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : top_level
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : U:\workspace\nexysterm\Aldec\compile\top_level.vhd
-- Generated   : Mon Jul  2 23:05:03 2012
-- From        : U:\workspace\nexysterm\Aldec\src\top_level.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;


entity top_level is
  port(
       i_board_clk : in STD_LOGIC;
       i_ps2d : in STD_LOGIC;
       i_serial_rx : in STD_LOGIC;
       i_button : in STD_LOGIC_VECTOR(3 downto 0);
       i_switch : in STD_LOGIC_VECTOR(7 downto 0);
       o_ps2c : out STD_LOGIC;
       o_serial_tx : out STD_LOGIC;
       o_vga_hsync : out STD_LOGIC;
       o_vga_vsync : out STD_LOGIC;
       o_led : out STD_LOGIC_VECTOR(7 downto 0);
       o_ssd_an : out STD_LOGIC_VECTOR(3 downto 0);
       o_ssd_seg : out STD_LOGIC_VECTOR(7 downto 0);
       o_vga_blu : out STD_LOGIC_VECTOR(1 downto 0);
       o_vga_grn : out STD_LOGIC_VECTOR(2 downto 0);
       o_vga_red : out STD_LOGIC_VECTOR(2 downto 0)
  );
end top_level;

architecture top_level of top_level is

---- Component declarations -----

component CRG
  port (
       board_clk : in STD_LOGIC;
       i_reset : in STD_LOGIC;
       clk1 : out STD_LOGIC;
       clk2 : out STD_LOGIC;
       clk3 : out STD_LOGIC;
       clk4 : out STD_LOGIC;
       locked : out STD_LOGIC;
       status : out STD_LOGIC_VECTOR(7 downto 0)
  );
end component;

---- Signal declarations used on the diagram ----

signal s_sys_clk1 : STD_LOGIC;
signal s_sys_clk2 : STD_LOGIC;
signal s_sys_clk3 : STD_LOGIC;
signal s_sys_clk4 : STD_LOGIC;
signal s_sys_dll_locked : STD_LOGIC;
signal s_sys_reset : STD_LOGIC;

begin

----  Component instantiations  ----

CRG_inst : CRG
  port map(
       board_clk => i_board_clk,
       clk1 => s_sys_clk1,
       clk2 => s_sys_clk2,
       clk3 => s_sys_clk3,
       clk4 => s_sys_clk4,
       i_reset => '0',
       locked => s_sys_dll_locked
  );

s_sys_reset <= not(s_sys_dll_locked);


end top_level;
