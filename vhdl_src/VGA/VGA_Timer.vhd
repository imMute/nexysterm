library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.VGA_TIMING.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity VGA_Timer is
    Port (
    -- Inputs
        ref_clk : in  std_logic;
        reset   : in  std_logic;
    -- Raw pixel outputs
        o_x_blank : out std_logic;
        o_y_blank : out std_logic;
        o_x_sync  : out std_logic;
        o_y_sync  : out std_logic;
        --o_x_pos   : out std_logic_vector(15 downto 0);
        --o_y_pos   : out std_logic_vector(15 downto 0);
        --o_schrx   : out std_logic_vector(3 downto 0);
        --o_schry   : out std_logic_vector(3 downto 0);
        --o_chrx    : out std_logic_vector(7 downto 0);
        --o_chry    : out std_logic_vector(7 downto 0)
        o_x_pos   : out integer range (H_TOTAL-1) downto 0;
        o_y_pos   : out integer range (V_TOTAL-1) downto 0;
        o_schrx   : out integer range 7 downto 0;
        o_schry   : out integer range 11 downto 0;
        o_chrx    : out integer range 99 downto 0;
        o_chry    : out integer range 49 downto 0
    );
end VGA_Timer;

architecture BEHAV of VGA_Timer is
    signal hctr : integer range (H_TOTAL-1) downto 0;
    signal vctr : integer range (V_TOTAL-1) downto 0;
    signal hctr_en,hctr_rs,vctr_en,vctr_rs : std_logic;
    
    signal schrx : integer range 7 downto 0;
    signal schry : integer range 11 downto 0;
    signal schrx_en,schry_en,schrx_rs,schry_rs : std_logic;
    
    signal chrx : integer range 99 downto 0;
    signal chry : integer range 49 downto 0;
    signal chrx_en,chry_en,chrx_rs,chry_rs : std_logic;
    
    signal hvisi,vvisi,bvisi : std_logic;
begin
U_HCTR:  entity g_counter generic map ( N => H_TOTAL ) port map ( ref_clk, hctr_rs, hctr_en, hctr );
U_VCTR:  entity g_counter generic map ( N => V_TOTAL ) port map ( ref_clk, vctr_rs, vctr_en, vctr );
U_SCHRX: entity g_counter generic map ( N =>   8 ) port map ( ref_clk, schrx_rs, schrx_en, schrx );
U_SCHRY: entity g_counter generic map ( N =>  12 ) port map ( ref_clk, schry_rs, schry_en, schry );
U_CHRX:  entity g_counter generic map ( N => 100 ) port map ( ref_clk, chrx_rs, chrx_en, chrx );
U_CHRY:  entity g_counter generic map ( N =>  50 ) port map ( ref_clk, chry_rs, chry_en, chry );

-- Counter reset & enable controls
hvisi <= '1' when (hctr >= H_VIS_S and hctr <= H_VIS_E) else '0';
vvisi <= '1' when (vctr >= V_VIS_S and vctr <= V_VIS_E) else '0';
bvisi <= hvisi and vvisi;

hctr_en <= '1';
vctr_en <= '1' when hctr=H_TOTAL-1 else '0';
hctr_rs <= vctr_en or reset;
vctr_rs <= '1' when (vctr=V_TOTAL-1 and hctr=H_TOTAL-1) or reset='1' else '0';

schrx_en <= '1' when (bvisi='1') else '0';
schrx_rs <= '1' when (schrx=7) or (hvisi='0') or (vvisi='0') else '0';
schry_en <= '1' when (vvisi='1') and (hctr=H_VIS_E) else '0';
schry_rs <= '1' when (schry=11 and hctr=H_VIS_E) or (vvisi='0') else '0';

chrx_en <= '1' when schrx_en='1' and schrx_rs='1' else '0';
chrx_rs <= '1' when hctr=H_VIS_E or hvisi='0' else '0';
chry_en <= '1' when schry_en='1' and schry_rs='1' else '0';
chry_rs <= '1' when (hctr=H_VIS_E and vctr=V_VIS_E) or vvisi='0' else '0';

o_x_blank <= not hvisi;
o_y_blank <= not vvisi;

o_x_sync <= '1' when hctr>=H_SPULSE_S and hctr<=H_SPULSE_E else '0';
o_y_sync <= '1' when vctr>=V_SPULSE_S and vctr<=V_SPULSE_E else '0';


-- Output assignments
--o_x_pos <= std_logic_vector(to_unsigned(hctr, o_x_pos'length));
--o_y_pos <= std_logic_vector(to_unsigned(vctr, o_y_pos'length));
o_x_pos <= hctr;
o_y_pos <= vctr;

--o_schrx <= std_logic_vector(to_unsigned(schrx, o_schrx'length));
--o_schry <= std_logic_vector(to_unsigned(schry, o_schry'length));
o_schrx <= schrx;
o_schry <= schry;

--o_chrx <= std_logic_vector(to_unsigned(chrx, o_chrx'length));
--o_chry <= std_logic_vector(to_unsigned(chry, o_chry'length));
o_chrx <= chrx;
o_chry <= chry;

end BEHAV;
