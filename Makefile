all: sim1

sim1: picorv32.v top.v tb1.v uart.v trng.v pll.v
	cp src/progmem.mem progmem.mem
	iverilog -DSIM -o tb1 tb1.v picorv32.v top.v uart.v trng.v pll.v
	./tb1

clean:
	rm -f tb1


