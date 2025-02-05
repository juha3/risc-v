# Small RISC-V MCU based on Picorv32 

* riscv32imc core: https://github.com/YosysHQ/picorv32
* UART bootloader
* tested on Xilinx Artix7 / BASYS3 devkit

Example code shows generates a new random number between 0 and 3 with each button 
press and shows it in seven segment display.

## Peripherals

* GPIO
* True random number generator
* UART
* 4kB RAM

### Memory

Memory map

address     | length | description
------------|--------|---------------
0x0000 0000 | 2048   | code RAM
0x0000 0800 | 2048   | data RAM
0x0300 0000 | 4096   | peripheral IO address space

### Bootloader

* located at 0x0000 0f00 (device reset address)
* size 74 bytes, bootloader/start.S 
* receives code fixed size image via UART and stores it in RAM



### GPIO

register map

register | access | address     |  bits
---------|--------|-------------|-----------
 DATA0   |  R/W   | 0x0300 3000 | 31:0
 DATA1   |  R/W   | 0x0300 3004 | 31:0
 PIN0    |   R    | 0x0300 3010 | 31:0
 PIN1    |   R    | 0x0300 3014 | 31:0
 DIR0    |  R/W   | 0x0300 3030 | 31:0
 DIR1    |  R/W   | 0x0300 3034 | 31:0

### UART

register map
    
register | access | address     | bits
---------|--------|-------------|-------
 TX_DATA |   W    | 0x0300 1000 | 7:0
 RX_DATA |   R    | 0x0300 1004 | 7:0
 CTRL    |   R/W  | 0x0300 1008 | 11:0
 STATUS  |   R    | 0x0300 100c | 2:0

    CTRL bits 11:0 clock divider
    baud rate = system clk / divider

    STATUS bit [2] overflow
    STATUS bit [1] data ready
    STATUS bit [0] transmitter busy

### True random number generator

register map
    
register | access | address     | bits
---------|--------|-------------|-------
 RNG_OUT |   W    | 0x0300 2000 | 7:0
 STATUS  |   R    | 0x0300 2004 | 7:0
 CTRL    |   W    | 0x0300 2008 | 7:0

     STATUS bit [0] data ready
     CTRL bit [0] enable

	PLL-based true random generator for FPGAs

	Random numbers are collected from phase noise of PLL block.
	
	Randomness is extracted by using two rationally related clock signals.
	Every once in a while clock edges align so that jitter of PLL output frequency
	causes sampled bit to be random.

	       v
	       |
	       | clk1 (12 MHz)
	   +---------+
	   |  PLL    |
	   +---------+
	       |
	       | clk2 (47.25 MHz)
		   |
	       |     +------+    +-----+   +-----------+   +------------+
	       +---->|      |--->|     |-->|           |-->|   von      |
	             | DFF  |    | DFF |   |   XOR     |   |  Neumann   |--> random bits
	           +-|>     |  +-|>    |   | decimator |   | randomness |
	           | +------+  | +-----+   |           |   | extractor  |
	           |           |           +-----------+   +------------+
        clk1   |           |                 |                |
	   --------+-----------+-----------------+----------------+

	parameter DEC_LEN adjusts decimation coefficient. Default is 1:128, 
	which means that 128 samples are fed to XOR decimator for one output bit.
	Decimator is XORing new input with old output and effectively calculating 
	parity (has there been even or odd amount of ones). Frequencies of clk1 
    and clk2 must be selected so, that at least one random bit is sampled in
    every DEC_LEN samples.

	Von Neumann randomness extractor removes possible bias from sequence of 
    collected random bits. It works by pairing consecutive bits and applying a rule:

    01 => 0
    10 => 1 
    00 => discard
    11 => discard


	Output rate depends on selected parameters. Test on Lattice ice40hx at 12 MHZ
    produced rate 
	
		12 MHz / (128 * 2 * 8) = ~5.8 kbytes / s

    Data produced by generator is not guaranteed to be random enough for any serious
    application, but it is uniformly distributed, has mean of ~128 and does not compress.



