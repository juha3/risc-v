# read sources
read_verilog "top.v"
read_verilog "picorv32.v"
read_verilog "uart.v"
read_verilog "trng.v"
read_verilog "pll.v"

# read constraints
read_xdc "basys.xdc"

# synthesize 
synth_design -top "top" -part "xc7a35tcpg236-1"

# P&R 
opt_design
place_design
route_design

# optional timing analysis
report_timing_summary -file timing.rpt
report_timing -delay_type max -sort_by group -max_paths 10 -input_pins -file timing.rpt

# write bit stream
write_bitstream -force "gpio.bit"


