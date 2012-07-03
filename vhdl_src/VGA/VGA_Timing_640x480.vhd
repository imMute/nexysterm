library IEEE;
use IEEE.STD_LOGIC_1164.all;

package VGA_TIMING is
--                                      ___________________________ 
--  \__________________________________/                           \
--  ___________              _______________________________________
--             \____________/                                       
--
--  |          |            |          |                           |
--  |    FP    |     SP     |    BP    |          VISIBLE          |
                                                        
--  |    16    |     96     |    48    |            640            |
--  |          |            |          |                           |
                                                        
--  |    10    |     02     |    33    |            480            |
--  |          |            |          |                           |


--    VGA Timings for 640x480
    constant H_FPORCH  : integer := 16;
    constant H_SPULSE  : integer := 96;
    constant H_BPORCH  : integer := 48;
    constant H_VISIBLE : integer := 640;

    constant V_FPORCH  : integer := 10;
    constant V_SPULSE  : integer := 2;
    constant V_BPORCH  : integer := 33;
    constant V_VISIBLE : integer := 480;
    
-- Calculated values.
    constant H_FPORCH_S : integer := 0;
    constant H_FPORCH_E : integer := H_FPORCH-1;
    constant H_SPULSE_S : integer := H_FPORCH;
    constant H_SPULSE_E : integer := H_FPORCH+H_SPULSE-1;
    constant H_BPORCH_S : integer := H_FPORCH+H_SPULSE;
    constant H_BPORCH_E : integer := H_FPORCH+H_SPULSE+H_BPORCH-1;
    constant H_VIS_S    : integer := H_FPORCH+H_SPULSE+H_BPORCH;
    constant H_VIS_E    : integer := H_FPORCH+H_SPULSE+H_BPORCH+H_VISIBLE-1;
    constant H_TOTAL    : integer := H_FPORCH+H_SPULSE+H_BPORCH+H_VISIBLE;
   
    constant V_FPORCH_S : integer := 0;
    constant V_FPORCH_E : integer := V_FPORCH-1;
    constant V_SPULSE_S : integer := V_FPORCH;
    constant V_SPULSE_E : integer := V_FPORCH+V_SPULSE-1;
    constant V_BPORCH_S : integer := V_FPORCH+V_SPULSE;
    constant V_BPORCH_E : integer := V_FPORCH+V_SPULSE+V_BPORCH-1;
    constant V_VIS_S    : integer := V_FPORCH+V_SPULSE+V_BPORCH;
    constant V_VIS_E    : integer := V_FPORCH+V_SPULSE+V_BPORCH+V_VISIBLE-1;
    constant V_TOTAL    : integer := V_FPORCH+V_SPULSE+V_BPORCH+V_VISIBLE;
end VGA_TIMING;