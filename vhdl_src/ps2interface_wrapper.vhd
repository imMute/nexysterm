-------------------------------------------------------------------------------
-- Title        : KC Register Interface
-- Design       : NexysTerm
-- Author       : Matt
-------------------------------------------------------------------------------
-- Description : ...
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library unisim;
use unisim.vcomponents.all;

entity ps2interface_wrapper is
    port (
        io_ps2c         : inout std_logic;
        io_ps2d         : inout std_logic;
        
        i_clk           : in  std_logic;
        i_reset         : in  std_logic;
        o_ps2_rxdata    : out std_logic_vector(7 downto 0);
        i_ps2_rx_strobe : in  std_logic;
        i_ps2_txdata    : in  std_logic_vector(7 downto 0);
        i_ps2_tx_strobe : in  std_logic;
        o_ps2_status    : out std_logic_vector(7 downto 0);
        i_ps2_control   : in  std_logic_vector(7 downto 0)
    );
end ps2interface_wrapper;


architecture macro_level_definition of ps2interface_wrapper is
    signal ps2tx : std_logic_vector(7 downto 0);
    signal ps2tx_strobe : std_logic;
    signal ps2rx : std_logic_vector(7 downto 0);
    signal ps2rx_strobe : std_logic;
    signal ps2busy : std_logic;
    signal ps2err : std_logic;
    
    signal uf_full : std_logic;
    signal uf_half_full : std_logic;
    signal uf_rdy : std_logic;
    signal uf_din : std_logic_vector(7 downto 0);
    signal uf_wr_strobe : std_logic;

begin

ps2interface_i: entity ps2interface
    port map (
        ps2_clk  => io_ps2c,
        ps2_data => io_ps2d,
        
        clk      => i_clk,
        rst      => i_reset,
        
        tx_data  => ps2tx,
        write    => ps2tx_strobe,
        rx_data  => ps2rx,
        read     => ps2rx_strobe,
        busy     => ps2busy,
        err      => ps2err
    );

output_fifo_i: entity bbfifo_16x8
    port map (
        data_in         => uf_din,
        write           => uf_wr_strobe,
        
        data_out        => o_ps2_rxdata,
        read            => i_ps2_rx_strobe,
        data_present    => o_ps2_status(0),
        full            => o_ps2_status(1),
        half_full       => o_ps2_status(2),
        
        clk             => i_clk,
        reset           => i_reset
    );
o_ps2_status(3) <= ps2err;
o_ps2_status(4) <= ps2busy;
o_ps2_status(7 downto 5) <= (others => '0');


-- dead simple read-only implementation
uf_din <= ps2rx;
uf_wr_strobe <= ps2rx_strobe;
ps2tx <= X"00";
ps2tx_strobe <= '0';

end macro_level_definition;
