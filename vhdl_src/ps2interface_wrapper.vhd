----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:06:45 07/01/2012 
-- Design Name: 
-- Module Name:    ps2interface_wrapper - behavioral 
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
use IEEE.NUMERIC_STD.ALL;
library unisim;
use unisim.vcomponents.all;

entity ps2interface_wrapper is
    port (
        ps2_clk  : inout std_logic;
        ps2_data : inout std_logic;
        clk         : in std_logic;
        rst         : in std_logic;
        rx_rdy      : out std_logic;
        rx_data     : out std_logic_vector(7 downto 0);
        rx_strobe   : in std_logic
    );
end ps2interface_wrapper;


architecture macro_level_definition of ps2interface_wrapper is
component ps2interface
    port(
        ps2_clk  : inout std_logic;
        ps2_data : inout std_logic;
        clk      : in std_logic;
        rst      : in std_logic;
        tx_data  : in std_logic_vector(7 downto 0);
        write    : in std_logic;
        rx_data  : out std_logic_vector(7 downto 0);
        read     : out std_logic;
        busy     : out std_logic;
        err      : out std_logic
    );
end component;

component bbfifo_16x8 
    Port (       data_in : in std_logic_vector(7 downto 0);
                data_out : out std_logic_vector(7 downto 0);
                   reset : in std_logic;               
                   write : in std_logic; 
                    read : in std_logic;
                    full : out std_logic;
               half_full : out std_logic;
            data_present : out std_logic;
                     clk : in std_logic);
end component;

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

ps2interface_isnt: ps2interface
    port map (
        ps2_clk  => ps2_clk,
        ps2_data => ps2_data,
        clk      => clk,
        rst      => rst,
        tx_data  => ps2tx,
        write    => ps2tx_strobe,
        rx_data  => ps2rx,
        read     => ps2rx_strobe,
        busy     => ps2busy,
        err      => ps2err
    );

output_fifo: bbfifo_16x8 
    port map (
        data_in         => uf_din,
        write           => uf_wr_strobe,
        data_out        => rx_data,
        read            => rx_strobe,
        full            => uf_full,
        half_full       => uf_half_full,
        data_present    => uf_rdy,
        clk             => clk,
        reset           => rst
    );
rx_rdy <= uf_rdy;


-- dead simple read-only implementation
uf_din <= ps2rx;
uf_wr_strobe <= ps2rx_strobe;
ps2tx <= X"00";
ps2tx_strobe <= '0';

end macro_level_definition;
