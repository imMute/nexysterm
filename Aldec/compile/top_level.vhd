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
-- Generated   : Wed Jul  4 15:01:50 2012
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
       i_serial_rx : in STD_LOGIC;
       i_button : in STD_LOGIC_VECTOR(3 downto 0);
       i_switch : in STD_LOGIC_VECTOR(7 downto 0);
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
  generic(
       G_BAUD_DIVIDER : INTEGER := 108
  );
  port (
       board_clk : in STD_LOGIC;
       i_reset : in STD_LOGIC;
       kc_clk : out STD_LOGIC;
       locked : out STD_LOGIC;
       srl_clkx16 : out STD_LOGIC;
       status : out STD_LOGIC_VECTOR(7 downto 0);
       vga_clk : out STD_LOGIC
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
component uart_rx
  port (
       clk : in STD_LOGIC;
       en_16_x_baud : in STD_LOGIC;
       read_buffer : in STD_LOGIC;
       reset_buffer : in STD_LOGIC;
       serial_in : in STD_LOGIC;
       buffer_data_present : out STD_LOGIC;
       buffer_full : out STD_LOGIC;
       buffer_half_full : out STD_LOGIC;
       data_out : out STD_LOGIC_VECTOR(7 downto 0)
  );
end component;
component uart_tx
  port (
       clk : in STD_LOGIC;
       data_in : in STD_LOGIC_VECTOR(7 downto 0);
       en_16_x_baud : in STD_LOGIC;
       reset_buffer : in STD_LOGIC;
       write_buffer : in STD_LOGIC;
       buffer_full : out STD_LOGIC;
       buffer_half_full : out STD_LOGIC;
       serial_out : out STD_LOGIC
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

----     Constants     -----
constant DANGLING_INPUT_CONSTANT : STD_LOGIC := 'Z';

---- Signal declarations used on the diagram ----

signal rd_strobe : STD_LOGIC;
signal s_kc_clk : STD_LOGIC;
signal s_srl_clkx16 : STD_LOGIC;
signal s_sys_dll_locked : STD_LOGIC;
signal s_sys_reset : STD_LOGIC;
signal s_vga_clk : STD_LOGIC;
signal wr_strobe : STD_LOGIC;
signal BUS4544 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS4553 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS4558 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS4567 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS4705 : STD_LOGIC_VECTOR (7 downto 0);
signal BUS4710 : STD_LOGIC_VECTOR (7 downto 0);
signal in_port : STD_LOGIC_VECTOR (7 downto 0);
signal out_port : STD_LOGIC_VECTOR (7 downto 0);
signal port_id : STD_LOGIC_VECTOR (7 downto 0);
signal prog_addr : STD_LOGIC_VECTOR (9 downto 0);
signal prog_inst : STD_LOGIC_VECTOR (17 downto 0);
signal s_reg_button : STD_LOGIC_VECTOR (7 downto 0);
signal s_srl_ctrl : STD_LOGIC_VECTOR (7 downto 0);
signal s_srl_status : STD_LOGIC_VECTOR (7 downto 0);

---- Declaration for Dangling input ----
signal Dangling_Input_Signal : STD_LOGIC;

begin

---- User Signal Assignments ----
s_reg_button <= i_button & "0000";

----  Component instantiations  ----

CRG_inst : CRG
  port map(
       board_clk => i_board_clk,
       i_reset => '0',
       kc_clk => s_kc_clk,
       locked => s_sys_dll_locked,
       srl_clkx16 => s_srl_clkx16,
       vga_clk => s_vga_clk
  );

SSD_Driver_inst : SSD_Driver
  port map(
       anodes => o_ssd_an,
       clk => s_kc_clk,
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
       clk => s_kc_clk,
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
       clk => s_kc_clk,
       instruction => prog_inst
  );

ri_button : g_ireg
  generic map (
       ID => X"01"
  )
  port map(
       addr => port_id,
       clk => s_kc_clk,
       d => s_reg_button,
       q => in_port
  );

ri_srl_data : g_ireg
  generic map (
       ID => X"13"
  )
  port map(
       addr => port_id,
       clk => s_kc_clk,
       d => BUS4705,
       q => in_port
  );

ri_srl_status : g_ireg
  generic map (
       ID => X"13"
  )
  port map(
       addr => port_id,
       clk => s_kc_clk,
       d => s_srl_status,
       q => in_port
  );

ri_switch : g_ireg
  generic map (
       ID => X"00"
  )
  port map(
       addr => port_id,
       clk => s_kc_clk,
       d => i_switch,
       q => in_port
  );

ro_led : g_oreg
  generic map (
       ID => X"02"
  )
  port map(
       addr => port_id,
       clk => s_kc_clk,
       d => out_port,
       q => o_led,
       we => wr_strobe
  );

ro_srl_ctrl : g_oreg
  generic map (
       ID => X"11"
  )
  port map(
       addr => port_id,
       clk => s_kc_clk,
       d => out_port,
       q => s_srl_ctrl,
       we => wr_strobe
  );

ro_srl_dout : g_oreg
  generic map (
       ID => X"14"
  )
  port map(
       addr => port_id,
       clk => s_kc_clk,
       d => out_port,
       q => BUS4710,
       we => wr_strobe
  );

ro_ssd1 : g_oreg
  generic map (
       ID => X"03"
  )
  port map(
       addr => port_id,
       clk => s_kc_clk,
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
       clk => s_kc_clk,
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
       clk => s_kc_clk,
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
       clk => s_kc_clk,
       d => out_port,
       q => BUS4544,
       we => wr_strobe
  );

uart_rx_inst : uart_rx
  port map(
       buffer_data_present => s_srl_status(0),
       buffer_full => s_srl_status(1),
       buffer_half_full => s_srl_status(2),
       clk => Dangling_Input_Signal,
       data_out => BUS4705,
       en_16_x_baud => Dangling_Input_Signal,
       read_buffer => Dangling_Input_Signal,
       reset_buffer => Dangling_Input_Signal,
       serial_in => i_serial_rx
  );

uart_tx_inst : uart_tx
  port map(
       buffer_full => s_srl_status(4),
       buffer_half_full => s_srl_status(5),
       clk => Dangling_Input_Signal,
       data_in => BUS4710,
       en_16_x_baud => Dangling_Input_Signal,
       reset_buffer => Dangling_Input_Signal,
       serial_out => o_serial_tx,
       write_buffer => Dangling_Input_Signal
  );

vga_top_inst : vga_top
  port map(
       i_sys_reset => s_sys_reset,
       i_tram_addr => "00000000000",
       i_tram_clk => '0',
       i_tram_data => X"0000",
       i_tram_en => '0',
       i_vga_refclk => s_vga_clk,
       o_vga_blu => o_vga_blu,
       o_vga_grn => o_vga_grn,
       o_vga_hsync => o_vga_hsync,
       o_vga_red => o_vga_red,
       o_vga_vsync => o_vga_vsync
  );


---- Dangling input signal assignment ----

Dangling_Input_Signal <= DANGLING_INPUT_CONSTANT;

end top_level;
