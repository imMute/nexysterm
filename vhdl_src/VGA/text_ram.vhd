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
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity text_ram is
    Port (
        -- Port A (writer)
        i_wr_clk    : in std_logic;
        i_wr_en     : in std_logic;
        i_wr_addr   : in std_logic_vector(12 downto 0);
        i_wr_data   : in std_logic_vector(15 downto 0);
        -- Port B (reader)
        i_rd_clk    : in std_logic;
        --i_rd_en     : in std_logic;
        i_rd_addr   : in std_logic_vector(12 downto 0);
        o_rd_data   : out std_logic_vector(15 downto 0)
    );
end text_ram;

architecture Behavioral of text_ram is
    component RAMB16_S16_S16
        Port (
            -- Port A (writer)
            CLKA    : in std_logic;
            ENA     : in std_logic;
            ADDRA   : in std_logic_vector(10 downto 0);
            DATAA   : in std_logic_vector(15 downto 0);
            -- Port B (reader)
            CLKB    : in std_logic;
            --i_rd_en     : in std_logic;
            ADDRB   : in std_logic_vector(10 downto 0);
            DATAB   : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- signals
    signal wr_addr_sub : std_logic_vector(10 downto 0);
    signal wr_enA, wr_enB, wr_enC, wr_enD : std_logic;
    
    signal rd_addr_sub : std_logic_vector(10 downto 0);
    signal rd_dataA, rd_dataB, rd_dataC, rd_dataD : std_logic_vector(15 downto 0);
begin
wr_addr_sub <= i_wr_addr(10 downto 0);
rd_addr_sub <= i_rd_addr(10 downto 0);

wr_enA <= '1' when ((i_wr_addr(12 downto 11)="00") and (i_wr_en='1')) else '0';
wr_enB <= '1' when ((i_wr_addr(12 downto 11)="01") and (i_wr_en='1')) else '0';
wr_enC <= '1' when ((i_wr_addr(12 downto 11)="10") and (i_wr_en='1')) else '0';
wr_enD <= '1' when ((i_wr_addr(12 downto 11)="11") and (i_wr_en='1')) else '0';

tram_A: RAMB16_S16_S16
    port map (
        CLKA  => i_wr_clk,
        ENA   => wr_enA,
        ADDRA => wr_addr_sub,
        DATAA => i_wr_data,
        
        CLKB  => i_rd_clk,
        ADDRB => rd_addr_sub,
        DATAB => rd_dataA
    );

tram_B: RAMB16_S16_S16
    port map (
        CLKA  => i_wr_clk,
        ENA   => wr_enB,
        ADDRA => wr_addr_sub,
        DATAA => i_wr_data,
        
        CLKB  => i_rd_clk,
        ADDRB => rd_addr_sub,
        DATAB => rd_dataB
    );

tram_C: RAMB16_S16_S16
    port map (
        CLKA  => i_wr_clk,
        ENA   => wr_enC,
        ADDRA => wr_addr_sub,
        DATAA => i_wr_data,
        
        CLKB  => i_rd_clk,
        ADDRB => rd_addr_sub,
        DATAB => rd_dataC
    );

tram_D: RAMB16_S16_S16
    port map (
        CLKA  => i_wr_clk,
        ENA   => wr_enD,
        ADDRA => wr_addr_sub,
        DATAA => i_wr_data,
        
        CLKB  => i_rd_clk,
        ADDRB => rd_addr_sub,
        DATAB => rd_dataD
    );

o_rd_data <= rd_dataA when i_rd_addr(12 downto 11) = "00" else 
             rd_dataB when i_rd_addr(12 downto 11) = "01" else 
             rd_dataC when i_rd_addr(12 downto 11) = "10" else 
             rd_dataD when i_rd_addr(12 downto 11) = "11" else 
             (others => '0');

end architecture;
