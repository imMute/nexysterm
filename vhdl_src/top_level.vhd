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
-- Generated   : Wed Jul  4 22:06:12 2012
-- From        : U:\workspace\nexysterm\Aldec\src\top_level.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
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
        data : in  STD_LOGIC_VECTOR (31 downto 0);
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

---- Constant declarations ----
constant C_PL_SWITCH            : std_logic_vector(7 downto 0) := X"00";
constant C_PL_BTN               : std_logic_vector(7 downto 0) := X"01";
constant C_PL_LED               : std_logic_vector(7 downto 0) := X"02";
constant C_PL_SSD1              : std_logic_vector(7 downto 0) := X"03";
constant C_PL_SSD2              : std_logic_vector(7 downto 0) := X"04";
constant C_PL_SSD3              : std_logic_vector(7 downto 0) := X"05";
constant C_PL_SSD4              : std_logic_vector(7 downto 0) := X"06";
constant C_PL_SRL_CTRL          : std_logic_vector(7 downto 0) := X"11";
constant C_PL_SRL_STATUS        : std_logic_vector(7 downto 0) := X"12";
constant C_PL_SRL_READ          : std_logic_vector(7 downto 0) := X"13";
constant C_PL_SRL_WRITE         : std_logic_vector(7 downto 0) := X"14";
constant C_PL_TRAM_ADDR_LOW     : std_logic_vector(7 downto 0) := X"21";
constant C_PL_TRAM_ADDR_HIGH    : std_logic_vector(7 downto 0) := X"22";
constant C_PL_TRAM_DATA_CHAR    : std_logic_vector(7 downto 0) := X"23";
constant C_PL_TRAM_DATA_COLOR   : std_logic_vector(7 downto 0) := X"24";

---- Signal declarations used on the diagram ----
---- Signals ---
signal s_kc_clk         : STD_LOGIC;
signal s_vga_clk        : STD_LOGIC;
signal s_srl_clkx16     : STD_LOGIC;
signal s_sys_dll_locked : STD_LOGIC;
signal s_sys_reset      : STD_LOGIC;

-- kc signals
signal prog_addr    : STD_LOGIC_VECTOR (9 downto 0);
signal prog_inst    : STD_LOGIC_VECTOR (17 downto 0);
signal port_id      : STD_LOGIC_VECTOR (7 downto 0);
signal in_port      : STD_LOGIC_VECTOR (7 downto 0);
signal wr_strobe    : STD_LOGIC;
signal out_port     : STD_LOGIC_VECTOR (7 downto 0);
signal out_port_q   : STD_LOGIC_VECTOR (7 downto 0);
signal rd_strobe    : STD_LOGIC;

-- io stuff
signal s_button     : std_logic_vector(7 downto 0);
signal s_switch     : std_logic_vector(7 downto 0);
signal s_ssd_data   : std_logic_vector(31 downto 0);
signal s_tram_addr  : std_logic_vector(10 downto 0);
signal s_tram_data  : std_logic_vector(15 downto 0);
signal s_tram_wr_en : std_logic;
signal s_srl_status     : std_logic_vector(7 downto 0);
signal s_srl_dout       : std_logic_vector(7 downto 0);
signal s_srl_din        : std_logic_vector(7 downto 0);
signal s_srl_wr_strobe  : std_logic;
signal s_srl_rd_strobe  : std_logic;

begin
CRG_inst : CRG
    port map (
        board_clk => i_board_clk,
        i_reset => '0',
        kc_clk => s_kc_clk,
        locked => s_sys_dll_locked,
        srl_clkx16 => s_srl_clkx16,
        vga_clk => s_vga_clk
    );
s_sys_reset <= not s_sys_dll_locked;

pico : kcpsm3
    port map (
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
    port map (
        address => prog_addr,
        clk => s_kc_clk,
        instruction => prog_inst
    );

-------------------
--   Input Ports
-------------------
input_stage_1: process (s_kc_clk) begin
    if rising_edge(s_kc_clk) then
        s_button <= "0000" & i_button;
        s_switch <= i_switch;
    end if;
end process;

input_stage_2: process (s_kc_clk) begin
    if rising_edge(s_kc_clk) then
        s_srl_rd_strobe <= '0';
        if rd_strobe='1' then
            case (port_id) is
                when C_PL_SWITCH =>
                    in_port <= s_switch;
                when C_PL_BTN =>
                    in_port <= s_button;
                when C_PL_SRL_STATUS =>
                    in_port <= s_srl_status;
                when C_PL_SRL_READ =>
                    in_port <= s_srl_dout;
                    s_srl_rd_strobe <= '1';
                when others =>
                    in_port <= "XXXXXXXX";
            end case;
        end if;
    end if;
end process;

-------------------
--   Output Ports
-------------------
output_stage_1: process (s_kc_clk) begin
    if rising_edge(s_kc_clk) then
        s_tram_wr_en <= '0';
        s_srl_wr_strobe <= '0';
        if wr_strobe='1' then
            case (port_id) is
                when C_PL_LED =>
                    o_led <= out_port;
                when C_PL_SSD1 =>
                    s_ssd_data(7 downto 0) <= out_port;
                when C_PL_SSD2 =>
                    s_ssd_data(15 downto 8) <= out_port;
                when C_PL_SSD3 =>
                    s_ssd_data(23 downto 16) <= out_port;
                when C_PL_SSD4 =>
                    s_ssd_data(31 downto 24) <= out_port;
                when C_PL_TRAM_ADDR_LOW =>
                    s_tram_addr(7 downto 0) <= out_port;
                when C_PL_TRAM_ADDR_HIGH =>
                    s_tram_addr(10 downto 8) <= out_port(2 downto 0);
                when C_PL_TRAM_DATA_CHAR =>
                    s_tram_data(7 downto 0) <= out_port;
                when C_PL_TRAM_DATA_COLOR =>
                    s_tram_data(15 downto 8) <= out_port;
                    s_tram_wr_en <= '1';
                when C_PL_SRL_WRITE =>
                    s_srl_din <= out_port;
                    s_srl_wr_strobe <= '1';
                when others => null;
            end case;
        end if;
    end if;
end process;


-------------------
--   Output Drivers
-------------------
vga_top_inst : vga_top
    port map (
        i_sys_reset => s_sys_reset,
        i_tram_addr => s_tram_addr,
        i_tram_clk => s_kc_clk,
        i_tram_data => s_tram_data,
        i_tram_en => s_tram_wr_en,
        i_vga_refclk => s_vga_clk,
        o_vga_blu => o_vga_blu,
        o_vga_grn => o_vga_grn,
        o_vga_hsync => o_vga_hsync,
        o_vga_red => o_vga_red,
        o_vga_vsync => o_vga_vsync
    );

SSD_Driver_inst : SSD_Driver
    port map (
        anodes => o_ssd_an,
        clk => s_kc_clk,
        data => s_ssd_data,
        segments => o_ssd_seg
    );

uart_rx_inst : uart_rx
    port map (
        buffer_data_present => s_srl_status(0),
        buffer_full => s_srl_status(1),
        buffer_half_full => s_srl_status(2),
        clk => s_kc_clk,
        data_out => s_srl_dout,
        en_16_x_baud => s_srl_clkx16,
        read_buffer => s_srl_rd_strobe,
        reset_buffer => '0',
        serial_in => i_serial_rx
    );

uart_tx_inst : uart_tx
    port map (
        buffer_full => s_srl_status(4),
        buffer_half_full => s_srl_status(5),
        clk => s_kc_clk,
        data_in => s_srl_din,
        en_16_x_baud => s_srl_clkx16,
        reset_buffer => '0',
        serial_out => o_serial_tx,
        write_buffer => s_srl_wr_strobe
    );

-------------------
--   Intermediate signal assignments
-------------------



end top_level;
