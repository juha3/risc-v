MEM_BYTES		= 1024
MEM_WORDS       = 256

TOOLS_PREFIX    = /home/juha/digital/tools/xpack-riscv-none-embed-gcc-10.2.0-1.2/bin
TARGET          = $(TOOLS_PREFIX)/riscv-none-embed
AS              = $(TARGET)-as
ASFLAGS         = -march=rv32imc -mabi=ilp32
LD              = $(TARGET)-gcc
LDFLAGS         = -march=rv32imc -mabi=ilp32 -Wl,-Tsections.lds,-Map,progmem.map -ffreestanding -nostartfiles
CC              = $(TARGET)-gcc
CFLAGS          = -march=rv32imc -mabi=ilp32 -Wall -Wextra -Wpedantic -DFREQ=$(FREQ_PLL)000000 -Os
#CFLAGS          += -DSIM
OBJCOPY         = $(TARGET)-objcopy
OBJDUMP         = $(TARGET)-objdump

OBJ_FILES       = start.o main.o irq.o

progmem.mem: progmem1k.bin
	../tools/convert < progmem1k.bin >progmem.mem
progmem.hex: progmem1k.bin
	$(OBJCOPY) --change-addresses 0x80000000 -O ihex -I binary $< $@

progmem1k.bin: progmem.elf
	$(OBJCOPY) --pad-to=$(MEM_BYTES) -O binary $< $@

progmem.bin: progmem.elf
	$(OBJCOPY) -O binary $< $@

progmem.elf: $(OBJ_FILES) 
	$(LD) $(LDFLAGS) -s -o $@ $(OBJ_FILES) > progmem.map
	$(OBJDUMP) -D progmem.elf > progmem.lst
clean:
	rm -rf *.o *.hex *.elf *.dis *.bin *.coe *.map *.mif *.mem *.lst



