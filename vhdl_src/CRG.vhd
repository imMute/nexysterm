----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:06:45 07/01/2012 
-- Design Name: 
-- Module Name:    CRG - behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity CRG is
    Generic (
        G_BAUD_DIVIDER : integer
    );
    Port (
        board_clk   : in  std_logic; -- 50 MHz
        i_reset     : in  std_logic;
        
        vga_clk     : out std_logic; 
        kc_clk      : out std_logic;
        srl_clkx16  : out std_logic; -- serial clock * 16

        status : out std_logic_vector(7 downto 0);
        locked : out std_logic
    );
end CRG;

architecture behavioral of CRG is
    signal CLKIN_IBUFG : std_logic;
    signal CLKDV_BUF,  CLKFX_BUF,  CLK0_BUF,  CLK2X_BUF  : std_logic;
    signal CLKDV_BUFG, CLKFX_BUFG, CLK0_BUFG, CLK2X_BUFG : std_logic;
    signal baud_cntr : integer range 0 to (G_BAUD_DIVIDER-1);
begin

clkin_ibufg_inst : IBUFG  port map (I => board_clk, O => CLKIN_IBUFG);

dcm_sp_inst : DCM_SP
    generic map(
        CLK_FEEDBACK => "1X",
        CLKDV_DIVIDE => 2.0,
        CLKFX_DIVIDE => 1,
        CLKFX_MULTIPLY => 2,
        CLKIN_DIVIDE_BY_2 => FALSE,
        CLKIN_PERIOD => 20.000,
        CLKOUT_PHASE_SHIFT => "NONE",
        DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
        DFS_FREQUENCY_MODE => "LOW",
        DLL_FREQUENCY_MODE => "LOW",
        DUTY_CYCLE_CORRECTION => TRUE,
        FACTORY_JF => x"C080",
        PHASE_SHIFT => 0,
        STARTUP_WAIT => TRUE
    )
    port map (
        CLKFB => CLK0_BUF,   -- I: feedback clock
        CLKIN => CLKIN_IBUFG, -- I: 50 MHz board clock
        DSSEN => '0',
        PSCLK => '0',
        PSEN => '0',
        PSINCDEC => '0',
        RST => i_reset,
        CLKDV => open,
        CLKFX => open,
        CLKFX180 => open,
        CLK0 => CLK0_BUF,
        CLK2X => CLK2X_BUF,
        CLK2X180 => open,
        CLK90 => open,
        CLK180 => open,
        CLK270 => open,
        LOCKED => locked,
        PSDONE => open,
        STATUS(7 downto 0) => status(7 downto 0)
    );

clk0_bufg_inst:  BUFG port map (I => CLK0_BUF, O => CLK0_BUFG);
clk2x_bufg_inst: BUFG port map (I => CLK2X_BUF, O => CLK2X_BUFG);

vga_clk <= CLK0_BUFG;
kc_clk <= CLK2X_BUFG;

-- TODO: make the baud counter frequency independent, and make sure it's clocked with the kc_clk
baud_timer: process(CLK2X_BUFG) begin
    if rising_edge(CLK2X_BUFG) then
        if baud_cntr=(G_BAUD_DIVIDER-1) then
            baud_cntr <= 0;
            srl_clkx16 <= '1';
        else
            baud_cntr <= baud_cntr + 1;
            srl_clkx16 <= '0';
        end if;
    end if;
end process;



end behavioral;

