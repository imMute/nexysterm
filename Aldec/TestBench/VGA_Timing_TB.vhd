library ieee;
use ieee.std_logic_1164.all;

entity VGA_Timing_TB is
end VGA_Timing_TB;

architecture TB_ARCHITECTURE of VGA_Timing_TB is
    component VGA_Timer
        Port (
        -- Inputs
            ref_clk : in  std_logic;
            reset   : in  std_logic;
        -- Raw pixel outputs
            o_x_pos   : out std_logic_vector(15 downto 0);
            o_y_pos   : out std_logic_vector(15 downto 0);
            o_x_blank : out std_logic;
            o_y_blank : out std_logic;
            o_x_sync  : out std_logic;
            o_y_sync  : out std_logic;
            o_schrx   : out std_logic_vector(3 downto 0);
            o_schry   : out std_logic_vector(3 downto 0);
            o_chrx   : out std_logic_vector(7 downto 0);
            o_chry   : out std_logic_vector(7 downto 0)
        );
    end component;
    
-- Input signals
    signal ref_clk : std_logic := '0';
    signal reset : std_logic := '1';
-- Output signals
    signal en : std_logic;
    signal x_pos : std_logic_vector(15 downto 0);
    signal y_pos : std_logic_vector(15 downto 0);
    signal x_blank : std_logic;
    signal y_blank : std_logic;
    signal x_sync : std_logic;
    signal y_sync : std_logic;
    signal schrx  : std_logic_vector(3 downto 0);
    signal schry  : std_logic_vector(3 downto 0);
    signal chrx   : std_logic_vector(7 downto 0);
    signal chry   : std_logic_vector(7 downto 0);
begin

UUT: VGA_Timer port map (
    ref_clk => ref_clk,
    reset => reset,
    o_x_pos => x_pos,
    o_y_pos => y_pos,
    o_x_blank => x_blank,
    o_y_blank => y_blank,
    o_x_sync => x_sync,
    o_y_sync => y_sync,
    o_schrx => schrx,
    o_schry => schry,
    o_chrx => chrx,
    o_chry => chry
);

-- Clocking and reset
process begin
    ref_clk <= not ref_clk;
    wait for 5 ns;
    ref_clk <= not ref_clk;
    wait for 5 ns;
end process;
process begin
    reset <= '1';
    wait for 22 ns;
    reset <= '0';
    wait for 38 ns;
    
    
    wait;
end process;


end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_VGA_Timing_TB of VGA_Timing_TB is
	for TB_ARCHITECTURE
	end for;
end TESTBENCH_FOR_VGA_Timing_TB;
