library IEEE;
use IEEE.STD_LOGIC_1164.all;

package nexysterm_defines_pkg is
    type A_Gx8slv_t  is array(7 downto 0) of std_logic_vector(7 downto 0);
    type A_Gx16slv_t is array(7 downto 0) of std_logic_vector(15 downto 0);
end nexysterm_defines_pkg;
