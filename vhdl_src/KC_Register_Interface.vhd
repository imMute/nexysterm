-------------------------------------------------------------------------------
-- Title        : KC Register Interface
-- Design       : NexysTerm
-- Author       : Matt
-------------------------------------------------------------------------------
-- Description : ...
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.nexysterm_defines_pkg.all;

entity KC_Register_Interface is
    port (
        -- KC Port
        i_kc_port_id    : in  std_logic_vector(7 downto 0);
        i_kc_rd_strobe  : in  std_logic;
        o_kc_in_port    : out std_logic_vector(7 downto 0);
        i_kc_wr_strobe  : in  std_logic;
        i_kc_out_port   : in  std_logic_vector(7 downto 0);
        
        -- Serial Registers
        o_srl_control   : out A_Gx8slv_t;
        i_srl_status    : in  A_Gx8slv_t;
        o_srl_bauddiv   : out A_Gx16slv_t;
        i_srl_rxdata    : in  A_Gx8slv_t;
        o_srl_rxstrobe  : out std_logic_vector(7 downto 0);
        o_srl_txdata    : out A_Gx8slv_t;
        o_srl_txstrobe  : out std_logic_vector(7 downto 0);
        
        -- VGA Registers
        o_vga_tram_en   : out std_logic;
        o_vga_tram_addr : out std_logic_vector(12 downto 0);
        o_vga_tram_data : out std_logic_vector(15 downto 0);
        
        -- PS2 Registers
        i_ps2_rxdata    : in  std_logic_vector(7 downto 0);
        o_ps2_rx_strobe : out std_logic;
        o_ps2_txdata    : out std_logic_vector(7 downto 0);
        o_ps2_tx_strobe : out std_logic;
        i_ps2_status    : in  std_logic_vector(7 downto 0);
        o_ps2_control   : out std_logic_vector(7 downto 0);
        
        -- IO Registers
        o_leds          : out std_logic_vector(7 downto 0);
        o_ssd           : out std_logic_vector(15 downto 0);
        i_btn           : in  std_logic_vector(3 downto 0);
        
        -- System Clk & Reset
        i_clk           : in  std_logic;
        i_reset         : in  std_logic
    );
end KC_Register_Interface;

architecture behav of KC_Register_Interface is
    signal s_vga_tram_column    : integer range 0 to 255;
    signal s_vga_tram_row       : integer range 0 to 255;
    signal s_vga_tram_rcaddr    : integer;
begin

-------------------
--   Input Ports
-------------------
process (i_clk)  begin
    if rising_edge(i_clk) then
        case (i_kc_port_id) is
            when X"00" => o_kc_in_port <= i_srl_rxdata(0); 
            when X"01" => o_kc_in_port <= i_srl_rxdata(1); 
            when X"02" => o_kc_in_port <= i_srl_rxdata(2); 
            when X"03" => o_kc_in_port <= i_srl_rxdata(3); 
            when X"04" => o_kc_in_port <= i_srl_rxdata(4); 
            when X"05" => o_kc_in_port <= i_srl_rxdata(5); 
            when X"06" => o_kc_in_port <= i_srl_rxdata(6); 
            when X"07" => o_kc_in_port <= i_srl_rxdata(7); 
            
            when X"08" => o_kc_in_port <= i_srl_status(0);
            when X"09" => o_kc_in_port <= i_srl_status(1);
            when X"0A" => o_kc_in_port <= i_srl_status(2);
            when X"0B" => o_kc_in_port <= i_srl_status(3);
            when X"0C" => o_kc_in_port <= i_srl_status(4);
            when X"0D" => o_kc_in_port <= i_srl_status(5);
            when X"0E" => o_kc_in_port <= i_srl_status(6);
            when X"0F" => o_kc_in_port <= i_srl_status(7);
            
            --when X"10" .. X"1F"
            
            --when X"20" .. X"2F"
            
            when X"30" => o_kc_in_port <= i_ps2_rxdata;
            when X"31" => o_kc_in_port <= i_ps2_status;
            -- when X"32" .. X"3F"
            
            -- when X"40" .. X"44"
            when X"45" => o_kc_in_port <= "0000" & i_btn;
            
            when others => o_kc_in_port <= (others => 'X');
        end case;
    end if;
end process;

srl_rxstrobe_gen:
for I in 0 to 7 generate
o_srl_rxstrobe(I) <= '1' when (i_kc_port_id=I and i_kc_rd_strobe='1') else '0';
end generate;
o_ps2_rx_strobe <= '1' when (i_kc_port_id=X"30" and i_kc_rd_strobe='1') else '0';


-------------------
--   Output Ports
-------------------
process (i_clk)  begin
    if rising_edge(i_clk) then
        -- Strobes
        o_srl_txstrobe <= (others => '0');
        o_vga_tram_en <= '0';
        o_ps2_tx_strobe <= '0';
        if i_kc_wr_strobe='1' then
            case (i_kc_port_id) is
                when X"00" => o_srl_txdata(0) <= i_kc_out_port; o_srl_txstrobe(0) <= '1';
                when X"01" => o_srl_txdata(1) <= i_kc_out_port; o_srl_txstrobe(1) <= '1';
                when X"02" => o_srl_txdata(2) <= i_kc_out_port; o_srl_txstrobe(2) <= '1';
                when X"03" => o_srl_txdata(3) <= i_kc_out_port; o_srl_txstrobe(3) <= '1';
                when X"04" => o_srl_txdata(4) <= i_kc_out_port; o_srl_txstrobe(4) <= '1';
                when X"05" => o_srl_txdata(5) <= i_kc_out_port; o_srl_txstrobe(5) <= '1';
                when X"06" => o_srl_txdata(6) <= i_kc_out_port; o_srl_txstrobe(6) <= '1';
                when X"07" => o_srl_txdata(7) <= i_kc_out_port; o_srl_txstrobe(7) <= '1';
                
                when X"08" => o_srl_control(0) <= i_kc_out_port;
                when X"09" => o_srl_control(1) <= i_kc_out_port;
                when X"0A" => o_srl_control(2) <= i_kc_out_port;
                when X"0B" => o_srl_control(3) <= i_kc_out_port;
                when X"0C" => o_srl_control(4) <= i_kc_out_port;
                when X"0D" => o_srl_control(5) <= i_kc_out_port;
                when X"0E" => o_srl_control(6) <= i_kc_out_port;
                when X"0F" => o_srl_control(7) <= i_kc_out_port;
                
                when X"10" => o_srl_bauddiv(0)( 7 downto 0) <= i_kc_out_port;
                when X"11" => o_srl_bauddiv(0)(15 downto 8) <= i_kc_out_port;
                when X"12" => o_srl_bauddiv(1)( 7 downto 0) <= i_kc_out_port;
                when X"13" => o_srl_bauddiv(1)(15 downto 8) <= i_kc_out_port;
                when X"14" => o_srl_bauddiv(2)( 7 downto 0) <= i_kc_out_port;
                when X"15" => o_srl_bauddiv(2)(15 downto 8) <= i_kc_out_port;
                when X"16" => o_srl_bauddiv(3)( 7 downto 0) <= i_kc_out_port;
                when X"17" => o_srl_bauddiv(3)(15 downto 8) <= i_kc_out_port;
                when X"18" => o_srl_bauddiv(4)( 7 downto 0) <= i_kc_out_port;
                when X"19" => o_srl_bauddiv(4)(15 downto 8) <= i_kc_out_port;
                when X"1A" => o_srl_bauddiv(5)( 7 downto 0) <= i_kc_out_port;
                when X"1B" => o_srl_bauddiv(5)(15 downto 8) <= i_kc_out_port;
                when X"1C" => o_srl_bauddiv(6)( 7 downto 0) <= i_kc_out_port;
                when X"1D" => o_srl_bauddiv(6)(15 downto 8) <= i_kc_out_port;
                when X"1E" => o_srl_bauddiv(7)( 7 downto 0) <= i_kc_out_port;
                when X"1F" => o_srl_bauddiv(7)(15 downto 8) <= i_kc_out_port;
                
                
                --when X"20" => o_vga_tram_addr( 7 downto 0) <= i_kc_out_port;
                --when X"21" => o_vga_tram_addr(12 downto 8) <= i_kc_out_port(4 downto 0);
                when X"20" => s_vga_tram_column <= to_integer(unsigned(i_kc_out_port));
                when X"21" => s_vga_tram_row    <= to_integer(unsigned(i_kc_out_port));
                when X"22" => o_vga_tram_data( 7 downto 0) <= i_kc_out_port;
                when X"23" => o_vga_tram_data(15 downto 8) <= i_kc_out_port;
                when X"24" => o_vga_tram_en <= '1';
                -- when X"25" .. X"2F"
                
                when X"30" => o_ps2_txdata <= i_kc_out_port; o_ps2_tx_strobe <= '1';
                when X"31" => o_ps2_control <= i_kc_out_port;
                -- when X"32" .. X"3F"
                
                when X"40" => o_leds <= i_kc_out_port;
                when X"41" => o_ssd( 7 downto  0) <= i_kc_out_port;
                when X"42" => o_ssd(15 downto  8) <= i_kc_out_port;
                -- when X"43" - X"44"
                -- when X"45"
                
                when others => null;
            end case;
        end if;
    end if;
end process;

s_vga_tram_rcaddr <= s_vga_tram_column + (s_vga_tram_row*100);
o_vga_tram_addr <= std_logic_vector(to_unsigned(s_vga_tram_rcaddr, 13));

end architecture;
