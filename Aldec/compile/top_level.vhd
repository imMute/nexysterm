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
-- Generated   : Wed Jul  4 12:24:46 2012
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
       i_button : in STD_LOGIC_VECTOR(3 downto 0);
       i_switch : in STD_LOGIC_VECTOR(7 downto 0);
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
component g_ireg
  generic(
       ID : STD_LOGIC_VECTOR(7 downto 0) := X"00"
  );
  port (
       addr : in STD_LOGIC_VECTOR(7 downto 0);
       clk : in STD_LOGIC;
       d : in STD_LOGIC_VECTOR(7 downto 0);
       q : out STD_LOGIC_VECTOR(7 downto 0)
  );
end component;
component g_oreg
  generic(
       ID : STD_LOGIC_VECTOR(7 downto 0) := X"00"
  );
  port (
       addr : in STD_LOGIC_VECTOR(7 downto 0);
       clk : in STD_LOGIC;
       d : in STD_LOGIC_VECTOR(7 downto 0);
       we : in STD_LOGIC;
       q : out STD_LOGIC_VECTOR(7 downto 0)
  );
end component;
component kcpsm3
  port (
       clk : in STD_LOGIC;
       in_port : in STD_LOGIC_VECTOR(7 downto 0);
       instruction : in STD_LOGIC_VECTOR(17 downto 0);
       interrupt : in STD_LOGIC;
       reset : in STD_LOGIC;
       address : out STD_LOGIC_VECTOR(9 downto 0);
       interrupt_ack : out STD_LOGIC;
       out_port : out STD_LOGIC_VECTOR(7 downto 0);
       port_id : out STD_LOGIC_VECTOR(7 downto 0);
       read_strobe : out STD_LOGIC;
       write_strobe : out STD_LOGIC
  );
end component;
component nterm
  port (
       address : in STD_LOGIC_VECTOR(9 downto 0);
       clk : in STD_LOGIC;
       instruction : out STD_LOGIC_VECTOR(17 downto 0)
  );
end component;
component SSD_Driver
  port (
       clk : in STD_LOGIC;
       data1 : in STD_LOGIC_VECTOR(7 downto 0);
       data2 : in STD_LOGIC_VECTOR(7 downto 0);
       data3 : in STD_LOGIC_VECTOR(7 downto 0);
       data4 : in STD_LOGIC_VECTOR(7 downto 0);
       anodes : out STD_LOGIC_VECTOR(3 downto 0);
       segments : out STD_LOGIC_VECTOR(7 downto 0)
  );
end component;
component vga_top
  port (
       i_sys_reset : in STD_LOGIC;
       i_tram_addr : in STD_LOGIC_VECTOR(10 downto 0);
       i_tram_clk : in STD_LOGIC;
       i_tram_data : in STD_LOGIC_VECTOR(15 downto 0);
       i_tram_en : in STD_LOGIC;
       i_vga_refclk : in STD_LOGIC;
       o_vga_blu : out STD_LOGIC_VECTOR(1 downto 0);
       o_vga_grn : out STD_LOGIC_VECTOR(2 downto 0);
       o_vga_hsync : out STD_LOGIC;
       o_vga_red : out STD_LOGIC_VECTOR(2 downto 0);
       o_vga_vsync : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal rd_strobe : STD_LOGIC;
signal s_sys_clk1 : STD_LOGIC;
signal s_sys_clk2 : STD_LOGIC;
signal s_sys_clk3 : STD_LOGIC;
signal s_sys_clk4 : STD_LOGIC;
signal s_sys_dll_locked : STD_LOGIC;
signal s_sys_reset : STD_LOGIC;
signal wr_strobe : STD_LOGIC;
signal BUS4544 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS4553 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS4558 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS4567 : STD_LOGIC_VECTOR (7 downto 0);
signal in_port : STD_LOGIC_VECTOR (7 downto 0);
signal out_port : STD_LOGIC_VECTOR (7 downto 0);
signal port_id : STD_LOGIC_VECTOR (7 downto 0);
signal prog_addr : STD_LOGIC_VECTOR (9 downto 0);
signal prog_inst : STD_LOGIC_VECTOR (17 downto 0);
signal s_reg_button : STD_LOGIC_VECTOR (7 downto 0);

begin

---- User Signal Assignments ----
s_reg_button <= i_button & "0000";

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

SSD_Driver_inst : SSD_Driver
  port map(
       anodes => o_ssd_an,
       clk => s_sys_clk1,
       data1 => BUS4567,
       data2 => BUS4558,
       data3 => BUS4553,
       data4 => BUS4544,
       segments => o_ssd_seg
  );

s_sys_reset <= not(s_sys_dll_locked);

pico : kcpsm3
  port map(
       address => prog_addr,
       clk => s_sys_clk4,
       in_port => in_port,
       instruction => prog_inst,
       interrupt => '0',
       interrupt_ack => open,
       out_port => out_port,
       port_id => port_id,
       read_strobe => rd_strobe,
       reset => s_sys_reset,
       write_strobe => wr_strobe
  );

prog_rom : nterm
  port map(
       address => prog_addr,
       clk => s_sys_clk4,
       instruction => prog_inst
  );

ri_button : g_ireg
  generic map (
       ID => X"01"
  )
  port map(
       addr => port_id,
       clk => s_sys_clk4,
       d => s_reg_button,
       q => in_port
  );

ri_switch : g_ireg
  generic map (
       ID => X"00"
  )
  port map(
       addr => port_id,
       clk => s_sys_clk4,
       d => i_switch,
       q => in_port
  );

ro_led : g_oreg
  generic map (
       ID => X"02"
  )
  port map(
       addr => port_id,
       clk => s_sys_clk4,
       d => out_port,
       q => o_led,
       we => wr_strobe
  );

ro_ssd1 : g_oreg
  generic map (
       ID => X"03"
  )
  port map(
       addr => port_id,
       clk => s_sys_clk4,
       d => out_port,
       q => BUS4567,
       we => wr_strobe
  );

ro_ssd2 : g_oreg
  generic map (
       ID => X"04"
  )
  port map(
       addr => port_id,
       clk => s_sys_clk4,
       d => out_port,
       q => BUS4558,
       we => wr_strobe
  );

ro_ssd3 : g_oreg
  generic map (
       ID => X"05"
  )
  port map(
       addr => port_id,
       clk => s_sys_clk4,
       d => out_port,
       q => BUS4553,
       we => wr_strobe
  );

ro_ssd4 : g_oreg
  generic map (
       ID => X"06"
  )
  port map(
       addr => port_id,
       clk => s_sys_clk4,
       d => out_port,
       q => BUS4544,
       we => wr_strobe
  );

vga_top_inst : vga_top
  port map(
       i_sys_reset => s_sys_reset,
       i_tram_addr => "00000000000",
       i_tram_clk => '0',
       i_tram_data => X"0000",
       i_tram_en => '0',
       i_vga_refclk => s_sys_clk1,
       o_vga_blu => o_vga_blu,
       o_vga_grn => o_vga_grn,
       o_vga_hsync => o_vga_hsync,
       o_vga_red => o_vga_red,
       o_vga_vsync => o_vga_vsync
  );


end top_level;
