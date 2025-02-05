all: convert load_fw

convert: main.c
	gcc -o convert main.c 

load_fw: load_fw.o 
	gcc -o load_fw load_fw.o
load_fw.o: load_fw.c 
	gcc -c load_fw.c 
clean:
	rm -f *.o convert load_fw

