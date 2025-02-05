
.equ UART_DIVIDER_115200, 868
.equ BASE_UART, 0x03001000
.equ BASE_DEBUG, 0x03000000
.equ BASE_GPIO, 0x03003000

.section .text
	//.global start
	
.org 0x00000000
start2:
//	j start

.org 0xf00
start:

	li		a0, BASE_GPIO
	li		a1, 0xffc0
	li		a2, 0x1ffe0
	sw		a2,52(a0)
	sw		a1, 4(a0)

	li		a0, BASE_UART
	li		a1, UART_DIVIDER_115200
	sw		a1, 8(a0)

	lw		a1, 0xc(a0)
	li		a4, 0
	li		a5, 768
	li		a2, BASE_DEBUG
wait1:
	lw		a1, 0xc(a0)
	and		a1, a1, 2
	beqz	a1, wait1
	lw		a3, 4(a0)
	sb		a3, 0(a4)
	addi	a4, a4, 1
	sw		a4, 8(a2)
	blt		a4, a5, wait1

	li		a0, BASE_GPIO
	li		a1, 0x1ffe0
	sw		a1, 4(a0)
	j start2
	//li		a1, 0xaa
	//sw		a1, 4(a2)
//loop:
//	j	loop

//
//	// no more than 16 bytes here !
//	/* set stack pointer */
//	/* LUI loads immediate value to [31:12] */
//	//lui    sp, 0x1 // (1 << 12) = 4096
//	//srli   sp, sp, 2 // divide by 4. 
//
//	// li loads max 12-bit(?) value without tricks
//	li     sp, 4092
//	j      start2
//	ebreak
//
//start2:
//	
//	# zero-initialize register file
//	addi x1, zero, 0
//	# x2 (sp) is initialized by reset
//	addi x3, zero, 0
//	addi x4, zero, 0
//	addi x5, zero, 0
//	addi x6, zero, 0
//	addi x7, zero, 0
//	addi x8, zero, 0
//	addi x9, zero, 0
//	addi x10, zero, 0
//	addi x11, zero, 0
//	addi x12, zero, 0
//	addi x13, zero, 0
//	addi x14, zero, 0
//	addi x15, zero, 0
//	addi x16, zero, 0
//	addi x17, zero, 0
//	addi x18, zero, 0
//	addi x19, zero, 0
//	addi x20, zero, 0
//	addi x21, zero, 0
//	addi x22, zero, 0
//	addi x23, zero, 0
//	addi x24, zero, 0
//	addi x25, zero, 0
//	addi x26, zero, 0
//	addi x27, zero, 0
//	addi x28, zero, 0
//	addi x29, zero, 0
//	addi x30, zero, 0
//	addi x31, zero, 0
//
//	# copy data section
//	la a0, _sidata
//	la a1, _sdata
//	la a2, _edata
//	bge a1, a2, end_init_data
//loop_init_data:
//	lw a3, 0(a0)
//	sw a3, 0(a1)
//	addi a0, a0, 4
//	addi a1, a1, 4
//	blt a1, a2, loop_init_data
//end_init_data:
//
//	# zero-init bss section
//	la a0, _sbss
//	la a1, _ebss
//	bge a0, a1, end_init_bss
//loop_init_bss:
//	sw zero, 0(a0)
//	addi a0, a0, 4
//	blt a0, a1, loop_init_bss
//end_init_bss:
//
//	//csrr   t0, mstatus
//	//ori    t0, t0, 8 // set bit 3 - MSIE (is this correct?) */ 
//	//csrw   mstatus, t0
//	jal ra, main
//
//
//.balign 4
//end_start_code:

