#!/bin/bash

ip addr|grep "altname eth0" > /dev/null
if [ "$?" != "0" ]; then
    echo setting up alternate interface name eth0 for license manager
    sudo ip link property add dev enp1s0 altname eth0
else 
    echo "altname eth0 already set"
fi 

source ~/opt/Xilinx/Vivado/2015.4/settings64.sh

if [ "$1" != "" ]; then
    cp bootloader/progmem.mem .
else 
    cp src/progmem.mem .
fi 

vivado -mode batch -source build.tcl
#vivado -mode batch -nolog -nojournal -source build.tcl


