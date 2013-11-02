-------------------------------------------------------------------------------
-- Title        : VGA Toplevel
-- Design       : NexysTerm
-- Author       : Matt
-------------------------------------------------------------------------------
-- Description : ...
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library unisim;
use unisim.vcomponents.all;
use work.VGA_TIMING.all;

entity vga_top is
    port (
        i_KC_tram_clk      : in  std_logic;
        i_KC_tram_en       : in  std_logic;
        i_KC_tram_addr     : in  std_logic_vector(12 downto 0);
        i_KC_tram_data     : in  std_logic_vector(15 downto 0);
        --
        i_clk           : in  std_logic;
        i_reset         : in  std_logic;
        o_vga_hsync     : out std_logic;
        o_vga_vsync     : out std_logic;
        o_vga_blu       : out std_logic_vector(1 downto 0);
        o_vga_grn       : out std_logic_vector(2 downto 0);
        o_vga_red       : out std_logic_vector(2 downto 0)
    );
end vga_top;

architecture vga_top of vga_top is
-- VGA Timer output signals
signal s_tmr_chrx    : integer range 99 downto 0;
signal s_tmr_chry    : integer range 49 downto 0;
signal s_tmr_schrx   : integer range 7 downto 0;
signal s_tmr_schry   : integer range 11 downto 0;
signal s_tmr_x_blank : std_logic;
signal s_tmr_y_blank : std_logic;
signal s_tmr_x_sync  : std_logic;
signal s_tmr_y_sync  : std_logic;

signal s_rd_addr : std_logic_vector(12 downto 0);

-- TRAM output signals
signal s_tram_x_blank : std_logic;
signal s_tram_y_blank : std_logic;
signal s_tram_x_sync  : std_logic;
signal s_tram_y_sync  : std_logic;
signal s_tram_row   : std_logic_vector(3 downto 0);
signal s_tram_col   : std_logic_vector(2 downto 0);
signal s_tram_data  : std_logic_vector(15 downto 0);
signal s_tram_char  : std_logic_vector(7 downto 0);

-- CROM output signals
signal s_crom_x_blank : std_logic;
signal s_crom_y_blank : std_logic;
signal s_crom_x_sync  : std_logic;
signal s_crom_y_sync  : std_logic;
signal s_crom_color   : std_logic_vector(7 downto 0);
signal s_crom_bit     : std_logic;


begin

vga_timer_inst : entity VGA_Timer
    port map (
        ref_clk     => i_clk,
        reset       => i_reset,
        
        o_x_pos     => open,
        o_y_pos     => open,
        
        o_chrx      => s_tmr_chrx,
        o_chry      => s_tmr_chry,
        
        o_schrx     => s_tmr_schrx,
        o_schry     => s_tmr_schry,
        
        o_x_blank   => s_tmr_x_blank,
        o_y_blank   => s_tmr_y_blank,
        o_x_sync    => s_tmr_x_sync,
        o_y_sync    => s_tmr_y_sync
    );

-- ----------

s_rd_addr <= std_logic_vector(to_unsigned((s_tmr_chrx + (100*s_tmr_chry)),s_rd_addr'length));

tram_inst : entity text_ram
    port map (
        -- Port A - KC's Port
        i_wr_clk    => i_KC_tram_clk,
        i_wr_addr   => i_KC_tram_addr,
        i_wr_en     => i_KC_tram_en,
        i_wr_data   => i_KC_tram_data,
        
        -- Port B - VGA's Port
        i_rd_clk    => i_clk,
        i_rd_addr   => s_rd_addr,
        o_rd_data   => s_tram_data
    );

-- Delay everything that didn't go through the TRAM
process (i_clk)  begin
    if rising_edge(i_clk) then
        s_tram_col <= std_logic_vector(to_unsigned(s_tmr_schrx,s_tram_col'length));
        s_tram_row <= std_logic_vector(to_unsigned(s_tmr_schry,s_tram_row'length));
        --s_tram_col <= std_logic_vector(to_unsigned(s_tmr_chrx,s_tram_col'length));
        --s_tram_row <= std_logic_vector(to_unsigned(s_tmr_chry,s_tram_row'length));
        s_tram_x_blank <= s_tmr_x_blank;
        s_tram_y_blank <= s_tmr_y_blank;
        s_tram_x_sync  <= s_tmr_x_sync;
        s_tram_y_sync  <= s_tmr_y_sync;
    end if;
end process;

-- ----------

s_tram_char <= s_tram_data(7 downto 0);

crom_inst : entity char_rom
    port map (
        CLK => i_clk,
        i_char => s_tram_char,
        i_col => s_tram_col,
        i_row => s_tram_row,
        o_bit => s_crom_bit
    );

-- Delay everything that didn't go through the CROM
process (i_clk)  begin
    if rising_edge(i_clk) then
        s_crom_color <= s_tram_data(15 downto 8);
        s_crom_x_blank <= s_tram_x_blank;
        s_crom_y_blank <= s_tram_y_blank;
        s_crom_x_sync  <= s_tram_x_sync;
        s_crom_y_sync  <= s_tram_y_sync;
    end if;
end process;

-- ----------

process (i_clk)  begin
    if rising_edge(i_clk) then
        o_vga_hsync <= s_crom_x_sync;
        o_vga_vsync <= s_crom_y_sync;
        if (s_crom_x_blank='0' and s_crom_y_blank='0' and s_crom_bit='1') then
            o_vga_red <= s_crom_color(7 downto 5);
            o_vga_grn <= s_crom_color(4 downto 2);
            o_vga_blu <= s_crom_color(1 downto 0);
        else
            o_vga_red <= (others => '0');
            o_vga_grn <= (others => '0');
            o_vga_blu <= (others => '0');
        end if;
    end if;
end process;

end architecture;
