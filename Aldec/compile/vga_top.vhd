-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : top_level
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : U:\workspace\nexysterm\Aldec\compile\vga_top.vhd
-- Generated   : Tue Jul  3 18:49:44 2012
-- From        : U:\workspace\nexysterm\Aldec\src\vga_top.bde
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

entity vga_top is
  port(
       i_sys_reset : in STD_LOGIC;
       i_vga_refclk : in STD_LOGIC;
       o_vga_hsync : out STD_LOGIC;
       o_vga_vsync : out STD_LOGIC;
       o_vga_blu : out STD_LOGIC_VECTOR(1 downto 0);
       o_vga_grn : out STD_LOGIC_VECTOR(2 downto 0);
       o_vga_red : out STD_LOGIC_VECTOR(2 downto 0)
  );
end vga_top;

architecture vga_top of vga_top is

---- Component declarations -----

component VGA_Timer
  port (
       ref_clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       o_chrx : out STD_LOGIC_VECTOR(7 downto 0);
       o_chry : out STD_LOGIC_VECTOR(7 downto 0);
       o_schrx : out STD_LOGIC_VECTOR(3 downto 0);
       o_schry : out STD_LOGIC_VECTOR(3 downto 0);
       o_x_blank : out STD_LOGIC;
       o_x_pos : out STD_LOGIC_VECTOR(15 downto 0);
       o_x_sync : out STD_LOGIC;
       o_y_blank : out STD_LOGIC;
       o_y_pos : out STD_LOGIC_VECTOR(15 downto 0);
       o_y_sync : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal s_clk : STD_LOGIC;
signal s_hsync : STD_LOGIC;
signal s_reset : STD_LOGIC;
signal s_vsync : STD_LOGIC;
signal s_xblank : STD_LOGIC;
signal s_xsync : STD_LOGIC;
signal s_yblank : STD_LOGIC;
signal s_ysync : STD_LOGIC;
signal s_blu : STD_LOGIC_VECTOR (1 downto 0);
signal s_chrx : STD_LOGIC_VECTOR (7 downto 0);
signal s_chry : STD_LOGIC_VECTOR (7 downto 0);
signal s_grn : STD_LOGIC_VECTOR (2 downto 0);
signal s_red : STD_LOGIC_VECTOR (2 downto 0);
signal s_schrx : STD_LOGIC_VECTOR (3 downto 0);
signal s_schry : STD_LOGIC_VECTOR (3 downto 0);
signal s_xpos : STD_LOGIC_VECTOR (15 downto 0);
signal s_ypos : STD_LOGIC_VECTOR (15 downto 0);

begin

---- Processes ----

VGA_gen_proc :
process (s_clk, s_xpos, s_ypos, s_xblank, s_yblank, s_xsync, s_ysync, s_schrx, s_schry, s_chrx, s_chry)
begin

if rising_edge(s_clk) then
    s_hsync <= s_xsync;
    s_vsync <= s_ysync;
    
    s_red <= s_chrx(2 downto 0);
    s_grn <= s_chry(2 downto 0);
    s_blu <= "00";
end if;

end process;

----  Component instantiations  ----

vga_timer_inst : VGA_Timer
  port map(
       o_chrx => s_chrx,
       o_chry => s_chry,
       o_schrx => s_schrx,
       o_schry => s_schry,
       o_x_blank => s_xblank,
       o_x_pos => s_xpos,
       o_x_sync => s_xsync,
       o_y_blank => s_yblank,
       o_y_pos => s_ypos,
       o_y_sync => s_ysync,
       ref_clk => s_clk,
       reset => s_reset
  );


---- Terminal assignment ----

    -- Inputs terminals
	s_reset <= i_sys_reset;
	s_clk <= i_vga_refclk;

    -- Output\buffer terminals
	o_vga_blu <= s_blu;
	o_vga_grn <= s_grn;
	o_vga_hsync <= s_hsync;
	o_vga_red <= s_red;
	o_vga_vsync <= s_vsync;


end vga_top;
