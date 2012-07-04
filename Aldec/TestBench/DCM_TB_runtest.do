SetActiveLib -work
comp -include "$dsn\TestBench\DCM_TB.vhd"
#comp -include "$dsn\src\TestBench\video_in_out_TB.vhd" 
asim +access +r TESTBENCH_FOR_DCM_TB 
wave 

wave -noreg board_clk
wave -noreg reset
wave -noreg locked
wave -noreg status
wave -noreg CLK0_BUF
wave -noreg CLKDV_BUF
wave -noreg CLK2X_BUF
wave -noreg CLKFX_BUF
wave -noreg CLK0_BUFG
wave -noreg CLKDV_BUFG
wave -noreg CLK2X_BUFG
wave -noreg CLKFX_BUFG
wave -noreg baud_cntr
wave -noreg srl_clkx16

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\video_in_out_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_video_in_out 
