# Clock pin
set_property PACKAGE_PIN W5 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

# LEDs
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]
set_property PACKAGE_PIN V3 [get_ports {led[9]}]
set_property PACKAGE_PIN W3 [get_ports {led[10]}]
set_property PACKAGE_PIN U3 [get_ports {led[11]}]
set_property PACKAGE_PIN P3 [get_ports {led[12]}]
set_property PACKAGE_PIN N3 [get_ports {led[13]}]
set_property PACKAGE_PIN P1 [get_ports {led[14]}]
set_property PACKAGE_PIN L1 [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]

# Clock constraints
# create_clock -period 10.0 [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 4} [get_ports { clk }];

# UART
set_property PACKAGE_PIN B18 [get_ports {rx}]
set_property PACKAGE_PIN A18 [get_ports {tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {rx}]

# LEDs
#set_property PACKAGE_PIN U16 [get_ports {led1}]
#set_property PACKAGE_PIN E19 [get_ports {led2}]
#set_property PACKAGE_PIN U19 [get_ports {led3}]
#set_property PACKAGE_PIN V19 [get_ports {led4}]
#set_property PACKAGE_PIN W18 [get_ports {q}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led1}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led2}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led3}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led4}]
#set_property IOSTANDARD LVCMOS33 [get_ports {q}]


# Buttons 
set_property PACKAGE_PIN U18 [get_ports { btnc }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { btnc }]; 
# 
set_property PACKAGE_PIN T18 [get_ports { btnu }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { btnu }];
#
set_property PACKAGE_PIN U17 [get_ports { btnd }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { btnd }];
#
set_property PACKAGE_PIN T17 [get_ports { btnr }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { btnr }];
#
set_property PACKAGE_PIN W19 [get_ports { btnl }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { btnl }];

# slide switches

set_property PACKAGE_PIN V17 [get_ports { sw[0] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[0] }];

set_property PACKAGE_PIN V16 [get_ports { sw[1] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[1] }];

set_property PACKAGE_PIN W16 [get_ports { sw[2] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[2] }];

set_property PACKAGE_PIN W17 [get_ports { sw[3] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[3] }];

set_property PACKAGE_PIN W15 [get_ports { sw[4] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[4] }];

set_property PACKAGE_PIN V15 [get_ports { sw[5] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[5] }];

set_property PACKAGE_PIN W14 [get_ports { sw[6] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[6] }];

set_property PACKAGE_PIN W13 [get_ports { sw[7] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[7] }];

set_property PACKAGE_PIN V2 [get_ports { sw[8] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[8] }];

set_property PACKAGE_PIN T3 [get_ports { sw[9] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[9] }];

set_property PACKAGE_PIN T2 [get_ports { sw[10] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[10] }];

set_property PACKAGE_PIN R3 [get_ports { sw[11] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[11] }];

set_property PACKAGE_PIN W2 [get_ports { sw[12] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[12] }];

set_property PACKAGE_PIN U1 [get_ports { sw[13] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[13] }];

set_property PACKAGE_PIN T1 [get_ports { sw[14] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[14] }];

set_property PACKAGE_PIN R2 [get_ports { sw[15] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { sw[15] }];

# Seven-Segment Display
set_property PACKAGE_PIN W7 [get_ports { sevenseg[0] }]; 
set_property PACKAGE_PIN W6 [get_ports { sevenseg[1] }]; 
set_property PACKAGE_PIN U8 [get_ports { sevenseg[2] }]; 
set_property PACKAGE_PIN V8 [get_ports { sevenseg[3] }]; 
set_property PACKAGE_PIN U5 [get_ports { sevenseg[4] }]; 
set_property PACKAGE_PIN V5 [get_ports { sevenseg[5] }]; 
set_property PACKAGE_PIN U7 [get_ports { sevenseg[6] }]; 
set_property PACKAGE_PIN V7 [get_ports { sevenseg[7] }];

set_property IOSTANDARD LVCMOS33 [get_ports { sevenseg[0] }];
set_property IOSTANDARD LVCMOS33 [get_ports { sevenseg[1] }];
set_property IOSTANDARD LVCMOS33 [get_ports { sevenseg[2] }];
set_property IOSTANDARD LVCMOS33 [get_ports { sevenseg[3] }];
set_property IOSTANDARD LVCMOS33 [get_ports { sevenseg[4] }];
set_property IOSTANDARD LVCMOS33 [get_ports { sevenseg[5] }];
set_property IOSTANDARD LVCMOS33 [get_ports { sevenseg[6] }];
set_property IOSTANDARD LVCMOS33 [get_ports { sevenseg[7] }];

# Anodes
set_property PACKAGE_PIN U2 [get_ports { anode[0] }]; 
set_property PACKAGE_PIN U4 [get_ports { anode[1] }]; 
set_property PACKAGE_PIN V4 [get_ports { anode[2] }]; 
set_property PACKAGE_PIN W4 [get_ports { anode[3] }]; 
set_property IOSTANDARD LVCMOS33 [get_ports { anode[0] }];
set_property IOSTANDARD LVCMOS33 [get_ports { anode[1] }];
set_property IOSTANDARD LVCMOS33 [get_ports { anode[2] }];
set_property IOSTANDARD LVCMOS33 [get_ports { anode[3] }];
#

# chrono inputs (PMOD connector JA, left top corner)

#set_property PACKAGE_PIN J3 [get_ports { in1 }]; 
#set_property PACKAGE_PIN K3 [get_ports { in2 }]; 


