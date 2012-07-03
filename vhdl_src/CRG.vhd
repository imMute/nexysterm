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
    Port (
        board_clk : in  std_logic;
        i_reset : in  std_logic;
        
        clk1 : out std_logic; -- clk * 1
        clk2 : out std_logic; -- clk / 2
        clk3 : out std_logic; -- clk * 2
        clk4 : out std_logic; -- clk * 4
        status : out std_logic_vector(7 downto 0);
        locked : out std_logic
    );
end CRG;

architecture behavioral of CRG is
    signal CLKIN_IBUFG : std_logic;
    signal CLKDV_BUF, CLKFX_BUF, CLK0_BUF, CLK2X_BUF : std_logic;
    signal CLK0_IBUF : std_logic;
begin

CLKIN_IBUFG_INST : IBUFG  port map (I => board_clk, O => CLKIN_IBUFG);

DCM_SP_INST : DCM_SP
    generic map(
        CLK_FEEDBACK => "1X",
        CLKDV_DIVIDE => 2.0,
        CLKFX_DIVIDE => 1,
        CLKFX_MULTIPLY => 4,
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
        CLKFB => CLK0_IBUF,
        CLKIN => CLKIN_IBUFG,
        DSSEN => '0',
        PSCLK => '0',
        PSEN => '0',
        PSINCDEC => '0',
        RST => i_reset,
        CLKDV => CLKDV_BUF,
        CLKFX => CLKFX_BUF,
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

CLK0_BUFG_INST  : BUFG  port map (I => CLK0_BUF,  O => CLK0_IBUF);
clk1 <= CLK0_IBUF;
CLKDV_BUFG_INST : BUFG  port map (I => CLKDV_BUF, O => clk2);
CLK2X_BUFG_INST : BUFG  port map (I => CLK2X_BUF, O => clk3);
CLKFX_BUFG_INST : BUFG  port map (I => CLKFX_BUF, O => clk4);


end behavioral;

