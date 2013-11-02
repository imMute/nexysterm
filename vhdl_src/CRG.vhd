-------------------------------------------------------------------------------
-- Title        : Clock and Reset Generator
-- Design       : NexysTerm
-- Author       : Matt
-------------------------------------------------------------------------------
-- Description : Generates all the clocks and resets used in the design
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity CRG is
    port (
        i_board_clk     : in  std_logic;
        i_async_reset   : in  std_logic;
        
        o_VGA_clk       : out std_logic;
        o_VGA_reset     : out std_logic;
        
        o_SYS_clk       : out std_logic;
        o_SYS_reset     : out std_logic
    );
end CRG;

architecture behavioral of CRG is
    signal board_clk_ibufg      : std_logic; -- I: 50 MHz
    signal dcm_reset            : std_logic;
    
    signal clk0,    clk0_bufg   : std_logic; -- O: 50 MHz
    signal clk2x,   clk2x_bufg  : std_logic; -- O: 100 MHz
    signal clkfx,   clkfx_bufg  : std_logic; -- O: 40 MHz
    
    signal s_sysclk             : std_logic;
    
    signal s_locked : std_logic;
    signal s_status : std_logic_vector(7 downto 0);
begin

board_clk_ibufg_i : IBUFG  port map (I => i_board_clk, O => board_clk_ibufg);

dcm_reset <= '1' when (i_async_reset='1' OR (s_locked='0' AND s_status(2)='1')) else '0';

dcm_sp_inst : DCM_SP
    generic map (
        CLK_FEEDBACK => "1X",
        CLKDV_DIVIDE => 2.0,
        CLKFX_DIVIDE => 5,
        CLKFX_MULTIPLY => 4,
        CLKIN_DIVIDE_BY_2 => FALSE,
        CLKIN_PERIOD => 20.000, --ns
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
        CLKFB       => clk0_bufg,   -- I: feedback clock
        CLKIN       => board_clk_ibufg, -- I: 50 MHz board clock
        DSSEN       => '0',
        PSCLK       => '0',
        PSEN        => '0',
        PSINCDEC    => '0',
        RST         => dcm_reset,
        CLKDV       => open,
        CLKFX       => clkfx,
        CLKFX180    => open,
        CLK0        => clk0,
        CLK2X       => clk2x,
        CLK2X180    => open,
        CLK90       => open,
        CLK180      => open,
        CLK270      => open,
        LOCKED      => s_locked,
        PSDONE      => open,
        STATUS      => s_status
        -- s_status[0] = Variable phase shift overflow.
        -- s_status[1] = CLKIN Input Stopped Indicator.
        -- s_status[2] = CLKFX or CLKFX180 output stopped indicator.
    );

clk0_bufg_i:  BUFG port map (I => clk0,  O => clk0_bufg);
clk2x_bufg_i: BUFG port map (I => clk2x, O => clk2x_bufg);
clkfx_bufg_i: BUFG port map (I => clkfx, O => clkfx_bufg);

s_sysclk <= clk0_bufg;
--s_sysclk <= clk2x_bufg;



o_VGA_clk   <= clkfx_bufg;
process (i_async_reset, s_locked, clkfx_bufg)
    variable ctr : std_logic_vector(3 downto 0);
begin
    if (i_async_reset='1' OR s_locked='0') then
        o_VGA_reset <= '1';
        ctr := "1111";
    elsif (rising_edge(clkfx_bufg)) then
        if (ctr /= "0000") then
            ctr := ctr - '1';
            o_VGA_reset <= '1';
        else
            ctr := "0000";
            o_VGA_reset <= '0';
        end if;
    end if;
end process;

o_SYS_clk   <= s_sysclk;
process (i_async_reset, s_locked, s_sysclk)
    variable ctr : std_logic_vector(3 downto 0);
begin
    if (i_async_reset='1' OR s_locked='0') then
        o_SYS_reset <= '1';
        ctr := "1111";
    elsif (rising_edge(s_sysclk)) then
        if (ctr /= "0000") then
            ctr := ctr - '1';
            o_SYS_reset <= '1';
        else
            ctr := "0000";
            o_SYS_reset <= '0';
        end if;
    end if;
end process;


end architecture;

