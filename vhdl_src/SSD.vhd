library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SSD_Driver is
    Port (
        clk : in  STD_LOGIC;
        data1 : in  STD_LOGIC_VECTOR (7 downto 0);
        data2 : in  STD_LOGIC_VECTOR (7 downto 0);
        data3 : in  STD_LOGIC_VECTOR (7 downto 0);
        data4 : in  STD_LOGIC_VECTOR (7 downto 0);
        segments : out  STD_LOGIC_VECTOR (7 downto 0);
        anodes : out  STD_LOGIC_VECTOR (3 downto 0)
    );
end SSD_Driver;

architecture BEHAV of SSD_Driver is
   signal data : std_logic_vector(31 downto 0);
   signal clk_cnt : integer := 0;
   signal ssd : std_logic_vector(7 downto 0);
   signal ssd_an : std_logic_vector(3 downto 0);
   signal actr : std_logic_vector(3 downto 0);
   signal actr_en : std_logic;
begin
    data <= data4 & data3 & data2 & data1;
    
    -- Clock Division
    process (clk) begin
        if rising_edge(clk) then
            if clk_cnt = 0 then
                clk_cnt <= 1000;
                actr_en <= '1';
            else
                clk_cnt <= clk_cnt - 1;
                actr_en <= '0';
            end if;
        end if;
    end process;

    -- Anode rolling
    process (clk) begin
        if rising_edge(clk) then
            if (actr_en = '1') then
                case actr is
                    when "0001" =>
                        actr <= "0010";
                        ssd <= data(7 downto 0);
                        ssd_an <= "1110";
                    when "0010" =>
                        actr <= "0100";
                        ssd <= data(15 downto 8);
                        ssd_an <= "1101";
                    when "0100" =>
                        actr <= "1000";
                        ssd <= data(23 downto 16);
                        ssd_an <= "1011";
                    when "1000" =>
                        actr <= "0001";
                        ssd <= data(31 downto 24);
                        ssd_an <= "0111";
                    when others =>
                        actr <= "0001";
                        ssd <= "ZZZZZZZZ";
                        ssd_an <= "1111";
                end case;
            end if;
        end if;
    end process;

    -- Actual decoding
    segments <= not ssd;
    anodes <= ssd_an;
end BEHAV;