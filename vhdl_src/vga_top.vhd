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
-- Generated   : Wed Jul  4 18:26:49 2012
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
use work.VGA_TIMING.all;

entity vga_top is
    port(
        i_sys_reset : in STD_LOGIC;
        i_tram_clk : in STD_LOGIC;
        i_tram_en : in STD_LOGIC;
        i_vga_refclk : in STD_LOGIC;
        i_tram_addr : in STD_LOGIC_VECTOR(10 downto 0);
        i_tram_data : in STD_LOGIC_VECTOR(15 downto 0);
        o_vga_hsync : out STD_LOGIC;
        o_vga_vsync : out STD_LOGIC;
        o_vga_blu : out STD_LOGIC_VECTOR(1 downto 0);
        o_vga_grn : out STD_LOGIC_VECTOR(2 downto 0);
        o_vga_red : out STD_LOGIC_VECTOR(2 downto 0)
    );
end vga_top;

architecture vga_top of vga_top is

---- Component declarations -----

component char_rom
    port (
        CLK : in STD_LOGIC;
        i_char : in STD_LOGIC_VECTOR(7 downto 0);
        i_col : in STD_LOGIC_VECTOR(2 downto 0);
        i_row : in STD_LOGIC_VECTOR(3 downto 0);
        o_bit : out STD_LOGIC
    );
end component;
component text_ram
    port (
        i_rd_addr : in STD_LOGIC_VECTOR(10 downto 0);
        i_rd_clk : in STD_LOGIC;
        i_wr_addr : in STD_LOGIC_VECTOR(10 downto 0);
        i_wr_clk : in STD_LOGIC;
        i_wr_data : in STD_LOGIC_VECTOR(15 downto 0);
        i_wr_en : in STD_LOGIC;
        o_rd_data : out STD_LOGIC_VECTOR(15 downto 0)
    );
end component;
component VGA_Timer
    port (
        ref_clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        o_chrx : out INTEGER range 79 downto 0;
        o_chry : out INTEGER range 39 downto 0;
        o_schrx : out INTEGER range 7 downto 0;
        o_schry : out INTEGER range 11 downto 0;
        o_x_blank : out STD_LOGIC;
        o_x_pos : out INTEGER range H_TOTAL-1 downto 0;
        o_x_sync : out STD_LOGIC;
        o_y_blank : out STD_LOGIC;
        o_y_pos : out INTEGER range V_TOTAL-1 downto 0;
        o_y_sync : out STD_LOGIC
    );
end component;

---- Signal declarations used on the diagram ----
signal s_bit : STD_LOGIC;
signal s_chrx : INTEGER range 79 downto 0;
signal s_chry : INTEGER range 39 downto 0;
signal s_clk : STD_LOGIC;
signal s_hsync : STD_LOGIC;
signal s_reset : STD_LOGIC;
signal s_schrx : INTEGER range 7 downto 0;
signal s_schry : INTEGER range 11 downto 0;
signal s_vsync : STD_LOGIC;
signal s_xblank : STD_LOGIC;
signal s_xpos : INTEGER range H_TOTAL-1 downto 0;
signal s_xsync : STD_LOGIC;
signal s_yblank : STD_LOGIC;
signal s_ypos : INTEGER range V_TOTAL-1 downto 0;
signal s_ysync : STD_LOGIC;
signal s_blu : STD_LOGIC_VECTOR (1 downto 0);
signal s_char : STD_LOGIC_VECTOR (15 downto 0);
signal s_col : STD_LOGIC_VECTOR (2 downto 0);
signal s_grn : STD_LOGIC_VECTOR (2 downto 0);
signal s_rd_addr : STD_LOGIC_VECTOR (10 downto 0);
signal s_red : STD_LOGIC_VECTOR (2 downto 0);
signal s_row : STD_LOGIC_VECTOR (3 downto 0);

begin

---- User Signal Assignments ----
-- chrx,chry  to address conversion
s_rd_addr <= std_logic_vector(to_unsigned((s_chrx + (5*s_chry)),s_rd_addr'length));

-- schrx,schry to col,row  (int -> slv) conversion
s_col <= std_logic_vector(to_unsigned(s_schrx,s_col'length));
s_row <= std_logic_vector(to_unsigned(s_schry,s_row'length));
-- same conversion, but on chrx,chry (bit letters)
--s_col <= std_logic_vector(to_unsigned(s_chrx,s_col'length));
--s_row <= std_logic_vector(to_unsigned(s_chry,s_row'length));
--s_red <= s_bit & s_bit & s_bit when s_xblank='0' and s_yblank='0' else "000";
--s_grn <= s_bit & s_bit & s_bit when s_xblank='0' and s_yblank='0' else "000";
--s_blu <= s_bit & s_bit when s_xblank='0' and s_yblank='0' else "00";
process (s_clk) begin
    if rising_edge(s_clk) then
        s_hsync <= s_xsync;
        s_vsync <= s_ysync;
        if (s_xblank='0' and s_yblank='0' and s_bit='1') then
            s_red <= s_char(15 downto 13);
            s_grn <= s_char(12 downto 10);
           s_blu <= s_char(9 downto 8);
        else
            s_red <= (others => '0');
            s_grn <= (others => '0');
            s_blu <= (others => '0');
        end if;
    end if;
end process;

----  Component instantiations  ----

crom_inst : char_rom
    port map(
        CLK => s_clk,
        i_char(0) => s_char(0),
        i_char(1) => s_char(1),
        i_char(2) => s_char(2),
        i_char(3) => s_char(3),
        i_char(4) => s_char(4),
        i_char(5) => s_char(5),
        i_char(6) => s_char(6),
        i_char(7) => s_char(7),
        i_col => s_col,
        i_row => s_row,
        o_bit => s_bit
    );

tram_inst : text_ram
    port map(
        i_rd_addr => s_rd_addr,
        i_rd_clk => s_clk,
        i_wr_addr => i_tram_addr,
        i_wr_clk => i_tram_clk,
        i_wr_data => i_tram_data,
        i_wr_en => i_tram_en,
        o_rd_data => s_char
    );

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
