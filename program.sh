#!/bin/bash
#
BITFILE=gpio.bit

stty -F /dev/ttyUSB1 115200 -crtscts -ixon raw

if [ "$1" == "save" ]; then
    openocd -f /opt/symbiflow/xc7/conda/envs/xc7/share/openocd/scripts/board/digilent_arty.cfg -c "init; jtagspi_init 0 tools/bscan_spi_xc7a35t.bit; jtagspi_program $BITFILE 0x0; exit"
else 
    openocd -f /opt/symbiflow/xc7/conda/envs/xc7/share/openocd/scripts/board/digilent_arty.cfg -c "init; pld load 0 $BITFILE; exit"
fi 


