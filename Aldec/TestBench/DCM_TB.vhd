library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity DCM_TB is
end DCM_TB;

architecture TB_ARCHITECTURE of DCM_TB is
-- Input signals
    signal board_clk : std_logic := '0';
    signal reset : std_logic := '1';
-- Output signals
    signal CLKIN_IBUFG : std_logic;
    signal CLKDV_BUF,  CLKFX_BUF,  CLK0_BUF,  CLK2X_BUF  : std_logic;
    signal CLKDV_BUFG, CLKFX_BUFG, CLK0_BUFG, CLK2X_BUFG : std_logic;
    signal baud_cntr : integer range 0 to (108-1);
    signal status : std_logic_vector(7 downto 0);
    signal locked : std_logic;
    signal srl_clkx16 : std_logic;
begin
-- Clocking and reset
process begin
    board_clk <= not board_clk;
    wait for 10 ns;
    board_clk <= not board_clk;
    wait for 10 ns;
end process;
process begin
    reset <= '1';
    wait for 102 ns;
    reset <= '0';
    wait for 38 ns;
    wait;
end process;

clkin_ibufg_inst : IBUFG  port map (I => board_clk, O => CLKIN_IBUFG);

dcm_sp_inst : DCM_SP
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
        CLKFB => CLK0_BUF,   -- I: feedback clock
        CLKIN => CLKIN_IBUFG, -- I: 50 MHz board clock
        DSSEN => '0',
        PSCLK => '0',
        PSEN => '0',
        PSINCDEC => '0',
        RST => reset,
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

clk0_bufg_inst:  BUFG port map (I => CLK0_BUF, O => CLK0_BUFG);
clkdv_bufg_inst: BUFG port map (I => CLKDV_BUF, O => CLKDV_BUFG);
clk2x_bufg_inst: BUFG port map (I => CLK2X_BUF, O => CLK2X_BUFG);
clkfx_bufg_inst: BUFG port map (I => CLKFX_BUF, O => CLKFX_BUFG);

baud_timer: process(CLKFX_BUFG) begin
    if rising_edge(CLKFX_BUFG) then
        if baud_cntr=107 then
            baud_cntr <= 0;
            srl_clkx16 <= '1';
        else
            baud_cntr <= baud_cntr + 1;
            srl_clkx16 <= '0';
        end if;
    end if;
end process;


end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_DCM_TB of DCM_TB is
	for TB_ARCHITECTURE
	end for;
end TESTBENCH_FOR_DCM_TB;
