SetActiveLib -work
comp -include "$dsn\TestBench\VGA_Timing_TB.vhd"
#comp -include "$dsn\src\TestBench\video_in_out_TB.vhd" 
asim +access +r TESTBENCH_FOR_VGA_Timing_TB 
wave 
wave -noreg ref_clk
wave -noreg reset
wave -noreg x_blank
wave -noreg x_sync
wave -noreg y_blank
wave -noreg y_sync

wave -noreg UUT/hvisi
wave -noreg UUT/vvisi

wave -noreg x_pos
wave -noreg UUT/hctr_en
wave -noreg UUT/hctr_rs
wave -noreg y_pos
wave -noreg UUT/vctr_en
wave -noreg UUT/vctr_rs

wave -noreg schrx
wave -noreg UUT/schrx_en
wave -noreg UUT/schrx_rs
wave -noreg chrx
wave -noreg UUT/chrx_en
wave -noreg UUT/chrx_rs

wave -noreg schry
wave -noreg UUT/schry_en
wave -noreg UUT/schry_rs
wave -noreg chry 
wave -noreg UUT/chry_en
wave -noreg UUT/chry_rs

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\video_in_out_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_video_in_out 
