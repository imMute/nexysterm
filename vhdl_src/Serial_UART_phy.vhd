-------------------------------------------------------------------------------
-- Title        : Serial UART "PHY"
-- Design       : NexysTerm
-- Author       : Matt
-------------------------------------------------------------------------------
-- Description : ...
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VComponents.all;

entity Serial_UART_PHY is
    port (
        i_clk           : in  std_logic;
        i_reset         : in  std_logic;
        
        i_serial_rx     : in  std_logic;
        o_serial_tx     : out std_logic;
        
        i_control       : in  std_logic_vector(7 downto 0);
        -- i_control[0] = RX Buffer Reset
        -- i_control[1] = 
        -- i_control[2] = 
        -- i_control[3] = 
        -- i_control[4] = TX Buffer Reset
        -- i_control[5] = 
        -- i_control[6] = 
        -- i_control[7] = 
        o_status        : out std_logic_vector(7 downto 0);
        -- o_status[0] = RX Buffer Data Present
        -- o_status[1] = RX Buffer Half Full
        -- o_status[2] = RX Buffer Full
        -- o_status[3] = 
        -- o_status[4] = 
        -- o_status[5] = TX Buffer Half Full
        -- o_status[6] = TX Buffer Full
        -- o_status[7] = 
        
        i_baud_divisor  : in  std_logic_vector(15 downto 0);
        
        o_data_rx           : out std_logic_vector(7 downto 0);
        i_data_rx_strobe    : in  std_logic;
        i_data_tx           : in  std_logic_vector(7 downto 0);
        i_data_tx_strobe    : in  std_logic
    );
end Serial_UART_PHY;

architecture RTL of Serial_UART_PHY is
    signal s_srl_clkx16     : std_logic;
    
    signal s_rx_strobe_dly  : std_logic;
    signal s_tx_strobe_dly  : std_logic;
begin

-- Baud Divider Process
process (i_clk)
    variable ctr    : std_logic_vector(15 downto 0);
begin
    if rising_edge(i_clk) then
        if i_reset='1' then
            s_srl_clkx16 <= '0';
        else
            if (ctr /= "0000000000000000") then
                ctr := ctr - '1';
                s_srl_clkx16 <= '0';
            else
                ctr := i_baud_divisor;
                s_srl_clkx16 <= '1';
            end if;
        end if;
    end if;
end process;


process (i_clk)  begin
    if rising_edge(i_clk) then
        s_rx_strobe_dly <= i_data_rx_strobe;
        s_tx_strobe_dly <= i_data_tx_strobe;
    end if;
end process;

rx_i : entity uart_rx
    port map (
        clk                 => i_clk,
        en_16_x_baud        => s_srl_clkx16,
        reset_buffer        => i_control(0),
        buffer_data_present => o_status(0),
        buffer_half_full    => o_status(1),
        buffer_full         => o_status(2),
        data_out            => o_data_rx,
        --read_buffer         => i_data_rx_strobe,
        read_buffer         => s_rx_strobe_dly,
        serial_in           => i_serial_rx
    );

tx_i : entity uart_tx
    port map (
        clk                 => i_clk,
        en_16_x_baud        => s_srl_clkx16,
        reset_buffer        => i_control(4),
        buffer_half_full    => o_status(5),
        buffer_full         => o_status(6),
        data_in             => i_data_tx,
        --write_buffer        => i_data_tx_strobe,
        write_buffer        => s_tx_strobe_dly,
        serial_out          => o_serial_tx
    );


-- Other Assignments
o_status(3) <= '0';
o_status(4) <= '0';
o_status(7) <= '0';
end architecture;
