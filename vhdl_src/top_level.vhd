-------------------------------------------------------------------------------
-- Title        : NexysTerm Top-Level
-- Design       : NexysTerm
-- Author       : Matt "imMute" S
-------------------------------------------------------------------------------
-- Description : Top-level block that connects all the subcomponents together
--               and to the outside world.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library unisim;
use unisim.vcomponents.all;
use work.nexysterm_defines_pkg.all;

entity top_level is
    generic (
        GINT_NUM_SERIAL_PORTS : integer range 1 to 8 := 8
    );
    port (
        -- Serial Ports
        i_srl_rx        : in  std_logic_vector(GINT_NUM_SERIAL_PORTS-1 downto 0);
        o_srl_tx        : out std_logic_vector(GINT_NUM_SERIAL_PORTS-1 downto 0);
        -- Control Buttons
        i_btn           : in std_logic_vector(3 downto 0);
        -- Status/Debugging LEDs
        o_led           : out std_logic_vector(7 downto 0);
        -- SSD
        o_ssd_seg       : out std_logic_vector(7 downto 0);
        o_ssd_an        : out std_logic_vector(3 downto 0);
        -- VGA
        o_vga_hsync     : out std_logic;
        o_vga_vsync     : out std_logic;
        o_vga_blu       : out std_logic_vector(1 downto 0);
        o_vga_grn       : out std_logic_vector(2 downto 0);
        o_vga_red       : out std_logic_vector(2 downto 0);
        -- PS2 Keyboard
        io_ps2c         : inout std_logic;
        io_ps2d         : inout std_logic;
        -- Board Oscillator
        i_board_clk     : in std_logic
    );
end top_level;

architecture RTL of top_level is
---- Signal Declarations ----
--- Clocks and Resets
    signal s_VGA_clk    : std_logic;
    signal s_VGA_reset  : std_logic;
    signal s_SYS_clk    : std_logic;
    signal s_SYS_reset  : std_logic;
--- Serial Register Interface
    signal A_srl_control    : A_Gx8slv_t;
    signal A_srl_status     : A_Gx8slv_t;
    signal A_srl_bauddiv    : A_Gx16slv_t;
    signal A_srl_rxdata     : A_Gx8slv_t;
    signal s_srl_rxstrobe   : std_logic_vector(7 downto 0);
    signal A_srl_txdata     : A_Gx8slv_t;
    signal s_srl_txstrobe   : std_logic_vector(7 downto 0);
-- VGA Register Interface
    signal s_vga_tram_en        : std_logic;
    signal s_vga_tram_addr      : std_logic_vector(12 downto 0);
    signal s_vga_tram_data      : std_logic_vector(15 downto 0);
-- PS2 Register Interface
    signal s_ps2_rxdata         : std_logic_vector(7 downto 0);
    signal s_ps2_rx_strobe      : std_logic;
    signal s_ps2_txdata         : std_logic_vector(7 downto 0);
    signal s_ps2_tx_strobe      : std_logic;
    signal s_ps2_status         : std_logic_vector(7 downto 0);
    signal s_ps2_control        : std_logic_vector(7 downto 0);
-- 
    signal s_ssd_data           : std_logic_vector(15 downto 0);
    signal s_btn_data           : std_logic_vector(3 downto 0);
    signal s_btn_strobe         : std_logic;
-- KCPSM3 Program Storage
    signal s_kc_prog_addr        : std_logic_vector(9 downto 0);
    signal s_kc_prog_inst        : std_logic_vector(17 downto 0);
    signal s_kc_port_id          : std_logic_vector(7 downto 0);
    signal s_kc_rd_strobe        : std_logic;
    signal s_kc_in_port          : std_logic_vector(7 downto 0);
    signal s_kc_wr_strobe        : std_logic;
    signal s_kc_out_port         : std_logic_vector(7 downto 0);



begin
-------------------
--   CRG instance
-------------------
CRG_i : entity CRG
    port map (
        i_board_clk     => i_board_clk,
        i_async_reset   => '0',
        o_VGA_clk       => s_VGA_clk,
        o_VGA_reset     => s_VGA_reset,
        o_SYS_clk       => s_SYS_clk,
        o_SYS_reset     => s_SYS_reset
    );

-------------------
--   Serial Port PHY instance
-------------------
SRL_loop :
for I in 1 to GINT_NUM_SERIAL_PORTS generate

srl_phy_i : entity Serial_UART_PHY
    port map (
        i_clk          => s_SYS_clk,
        i_reset        => s_SYS_reset,
        i_serial_rx    => i_srl_rx(I-1),
        o_serial_tx    => o_srl_tx(I-1),
        i_control      => A_srl_control(I-1),
        o_status       => A_srl_status(I-1),
        i_baud_divisor => A_srl_bauddiv(I-1),
        o_data_rx           => A_srl_rxdata(I-1),
        i_data_rx_strobe    => s_srl_rxstrobe(I-1),
        i_data_tx           => A_srl_txdata(I-1),
        i_data_tx_strobe    => s_srl_txstrobe(I-1)
    );

end generate;


-------------------
--   VGA Toplevel
-------------------
VGA_i : entity VGA_top
    port map (
        -- KC's Port
        i_KC_tram_clk   => s_SYS_clk,
        i_KC_tram_en    => s_vga_tram_en,
        i_KC_tram_addr  => s_vga_tram_addr,
        i_KC_tram_data  => s_vga_tram_data,
        -- VGA's Port
        i_clk       => s_VGA_clk,
        i_reset     => s_VGA_reset,
        o_vga_hsync => o_vga_hsync,
        o_vga_vsync => o_vga_vsync,
        o_vga_blu   => o_vga_blu,
        o_vga_grn   => o_vga_grn,
        o_vga_red   => o_vga_red
    );


-------------------
--   PS2 Interface
-------------------
ps2interface_inst : entity ps2interface_wrapper
    port map (
        io_ps2c         => io_ps2c,
        io_ps2d         => io_ps2d,
        
        i_clk           => s_SYS_clk,
        i_reset         => s_SYS_reset,
        o_ps2_rxdata    => s_ps2_rxdata,
        i_ps2_rx_strobe => s_ps2_rx_strobe,
        i_ps2_txdata    => s_ps2_txdata,
        i_ps2_tx_strobe => s_ps2_tx_strobe,
        o_ps2_status    => s_ps2_status,
        i_ps2_control   => s_ps2_control
    );

-------------------
--   KCPSM3 and program ROM instances
-------------------
pico_i : entity kcpsm3
    port map (
        clk             => s_SYS_clk,
        reset           => s_SYS_reset,
        
        address         => s_kc_prog_addr,
        instruction     => s_kc_prog_inst,
        
        interrupt       => '0',
        interrupt_ack   => open,
        
        port_id         => s_kc_port_id,
        read_strobe     => s_kc_rd_strobe,
        in_port         => s_kc_in_port,
        write_strobe    => s_kc_wr_strobe,
        out_port        => s_kc_out_port
    );
prog_rom_i : entity nterm
    port map (
        clk         => s_SYS_clk,
        address     => s_kc_prog_addr,
        instruction => s_kc_prog_inst
    );

ssd_i : entity SSD_Hex
    port map (
        clk         => s_SYS_clk, 
        data        => s_ssd_data,
        segments    => o_ssd_seg,
        anodes      => o_ssd_an
    );

btn_debounce_i : entity grp_debouncer
    generic map (
        N       => 4,
        --CNT_VAL => 10000
        CNT_VAL => 500000
    )
    port map (
        clk_i   => s_SYS_clk,
        data_i  => i_btn,
        data_o  => s_btn_data,
        strb_o  => s_btn_strobe
    );
-------------------
--   KCPSM3 to Register Mapping
-------------------
regmap_i : entity KC_Register_Interface
    port map (
        -- KC Port
        i_kc_port_id    => s_kc_port_id,
        i_kc_rd_strobe  => s_kc_rd_strobe,
        o_kc_in_port    => s_kc_in_port,
        i_kc_wr_strobe  => s_kc_wr_strobe,
        i_kc_out_port   => s_kc_out_port,
        
        -- Serial Registers
        o_srl_control   => A_srl_control,
        i_srl_status    => A_srl_status,
        o_srl_bauddiv   => A_srl_bauddiv,
        i_srl_rxdata    => A_srl_rxdata,
        o_srl_rxstrobe  => s_srl_rxstrobe,
        o_srl_txdata    => A_srl_txdata,
        o_srl_txstrobe  => s_srl_txstrobe,
        
        -- VGA Registers
        o_vga_tram_en   => s_vga_tram_en,
        o_vga_tram_addr => s_vga_tram_addr,
        o_vga_tram_data => s_vga_tram_data,
        
        -- PS2 Registers
        i_ps2_rxdata    => s_ps2_rxdata,
        o_ps2_rx_strobe => s_ps2_rx_strobe,
        o_ps2_txdata    => s_ps2_txdata,
        o_ps2_tx_strobe => s_ps2_tx_strobe,
        i_ps2_status    => s_ps2_status,
        o_ps2_control   => s_ps2_control,
        
        -- IO Registers
        o_leds          => o_led,
        i_btn           => s_btn_data,
        o_ssd           => s_ssd_data,
        
        -- System Clk & Reset
        i_clk           => s_SYS_clk,
        i_reset         => s_SYS_reset
    );

end architecture;
