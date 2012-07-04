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
-- Generated   : Wed Jul  4 00:56:26 2012
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
use IEEE.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity top_level is
  port(
       i_board_clk : in STD_LOGIC;
       i_switch : in STD_LOGIC_VECTOR(7 downto 0);
       o_vga_hsync : out STD_LOGIC;
       o_vga_vsync : out STD_LOGIC;
       o_led : out STD_LOGIC_VECTOR(7 downto 0);
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
component vga_top
  port (
       i_sys_reset : in STD_LOGIC;
       i_vga_refclk : in STD_LOGIC;
       o_vga_blu : out STD_LOGIC_VECTOR(1 downto 0);
       o_vga_grn : out STD_LOGIC_VECTOR(2 downto 0);
       o_vga_hsync : out STD_LOGIC;
       o_vga_red : out STD_LOGIC_VECTOR(2 downto 0);
       o_vga_vsync : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal s_sys_clk1 : STD_LOGIC;
signal s_sys_clk2 : STD_LOGIC;
signal s_sys_clk3 : STD_LOGIC;
signal s_sys_clk4 : STD_LOGIC;
signal s_sys_dll_locked : STD_LOGIC;
signal s_sys_reset : STD_LOGIC;
signal BUS853 : STD_LOGIC_VECTOR (7 downto 0);

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

vga_top_inst : vga_top
  port map(
       i_sys_reset => s_sys_reset,
       i_vga_refclk => s_sys_clk1,
       o_vga_blu => o_vga_blu,
       o_vga_grn => o_vga_grn,
       o_vga_hsync => o_vga_hsync,
       o_vga_red => o_vga_red,
       o_vga_vsync => o_vga_vsync
  );


---- Terminal assignment ----

    -- Inputs terminals
	BUS853 <= i_switch;

    -- Output\buffer terminals
	o_led <= BUS853;


end top_level;
