#include "custom_ops.S"

.section .text
	.global start
	.global main
	.global irq
	.global set_timer
	.global flag
	
.org 0x00000000
start:
	// no more than 16 bytes here !
	/* set stack pointer */
	/* LUI loads immediate value to [31:12] */
	//lui    sp, 0x1 // (1 << 12) = 4096
	//srli   sp, sp, 2 // divide by 4. 

	// li loads max 12-bit(?) value without tricks
	li     sp, 0xffc

	// write 32 bit value
//	li a0, 0xfc	
//	li a1, 0xa5a5c3c3
//	sw a1, 0(a0)
//	nop
//	// write 16 bit value
//	li a0, 0xfe	
//	li a1, 0xa5a5
//	sh a1, 0(a0)

//	lui    x1, 0x1
//	srli   x1, x1, 5 // (1 << 7)
//	csrr   x3, mie
//	or     x3, x3, x1
//	csrw   mie, x3
//
//	li a0, 0xc0000000
//	li a1, 0x65
//	sw a1, 0(a0)
//
//	// write 0x12345678 to 0x100 to stop simulation
//	li a0, 0x100	
//	li a1, 0x12345678
//	sw a1, 0(a0)

	//j      start2

	//addi sp, sp, 32
	//picorv32_waitirq_insn(zero)
	//picorv32_maskirq_insn(zero, zero)

	//lui    x1, 0x1
	//srli   x1, x1, 5 // (1 << 7)
	//csrr   x3, mie
	//or     x3, x3, x1
	//csrw   mie, x3
	//la     x3, irq_vec
	//csrw   mtvec, x3

//	csrr   t0, mstatus
//	ori    t0, t0, 8 // set bit 3 - MSIE (is this correct?) */ 
//	csrw   mstatus, t0

	//csrw   mepc, x0
	j      start2
	ebreak

.org 0x10
	
	j 0xf00

/*
	mcause [3:0]
		7 ext int
		3 ebreak
	   11 ecall
		4 misaligned read
		6 misaligned store
		0 misaligned jump
*/

// must be 4-byte aligned
.org 0x00000040
irq_vec:
	//picorv32_setq_insn(q2, a0)
	//picorv32_setq_insn(q3, a1)
	csrr   t0, mcause
	andi   t0, t0, 0xf
	li     t1, 7
	beq    t1, t0, int_handler
hang:
	j      hang
int_handler:
//	j int_handler

//	addi   sp, sp, -17 * 4
//	sw     ra, 0 * 4(sp)
//	sw     ra, 0 * 4(sp)
//    sw     a0, 1 * 4(sp)
//    sw     a1, 2 * 4(sp)
//    sw     a2, 3 * 4(sp)
//    sw     a3, 4 * 4(sp)
//    sw     a4, 5 * 4(sp)
//    sw     a5, 6 * 4(sp)
//    sw     a6, 7 * 4(sp)
//    sw     a7, 8 * 4(sp)
//    sw     t0, 9 * 4(sp)
//    sw     t1, 10 * 4(sp)
//    sw     t2, 11 * 4(sp)
//    sw     t3, 12 * 4(sp)
//    sw     t4, 13 * 4(sp)
//    sw     t5, 14 * 4(sp)
//    sw     t6, 15 * 4(sp)
//
//    jal    irq_handler
//  
//    lw     ra, 0 * 4(sp)
//    lw     a0, 1 * 4(sp)
//    lw     a1, 2 * 4(sp)
//    lw     a2, 3 * 4(sp)
//    lw     a3, 4 * 4(sp)
//    lw     a4, 5 * 4(sp)
//    lw     a5, 6 * 4(sp)
//    lw     a6, 7 * 4(sp)
//    lw     a7, 8 * 4(sp)
//    lw     t0, 9 * 4(sp)
//    lw     t1, 10 * 4(sp)
//    lw     t2, 11 * 4(sp)
//    lw     t3, 12 * 4(sp)
//    lw     t4, 13 * 4(sp)
//    lw     t5, 14 * 4(sp)
//    lw     t6, 15 * 4(sp)
//
//    addi   sp, sp, 17 * 4
				
//	mret
//	addi a0, zero, 1
//	la a1, flag
//	sw a0, 0(a1)
	
	//picorv32_getq_insn(a0, q2)
	//picorv32_getq_insn(a1, q3)
	//picorv32_retirq_insn()
	
start2:
//	addi a0, zero, 0
//	addi a1, zero, 0
//loop1:
//	addi a0, a0, 1
//	sw a0, 0(a1)
//	lw a2, 0(a1)
//	sw a2, 4(a1)
//	j loop1

	//li		a1, 1
	//li		a0, 0xfffffff7 // enable IRQ3 (first 3 are reserved: timer, EBREAK, bus error)
	//picorv32_maskirq_insn(a1, a0)
	
	# zero-initialize register file
	addi x1, zero, 0
	# x2 (sp) is initialized by reset
	addi x3, zero, 0
	addi x4, zero, 0
	addi x5, zero, 0
	addi x6, zero, 0
	addi x7, zero, 0
	addi x8, zero, 0
	addi x9, zero, 0
	addi x10, zero, 0
	addi x11, zero, 0
	addi x12, zero, 0
	addi x13, zero, 0
	addi x14, zero, 0
	addi x15, zero, 0
	addi x16, zero, 0
	addi x17, zero, 0
	addi x18, zero, 0
	addi x19, zero, 0
	addi x20, zero, 0
	addi x21, zero, 0
	addi x22, zero, 0
	addi x23, zero, 0
	addi x24, zero, 0
	addi x25, zero, 0
	addi x26, zero, 0
	addi x27, zero, 0
	addi x28, zero, 0
	addi x29, zero, 0
	addi x30, zero, 0
	addi x31, zero, 0

	# copy data section
	la a0, _sidata
	la a1, _sdata
	la a2, _edata
	bge a1, a2, end_init_data
loop_init_data:
	lw a3, 0(a0)
	sw a3, 0(a1)
	addi a0, a0, 4
	addi a1, a1, 4
	blt a1, a2, loop_init_data
end_init_data:

	# zero-init bss section
	la a0, _sbss
	la a1, _ebss
	bge a0, a1, end_init_bss
loop_init_bss:
	sw zero, 0(a0)
	addi a0, a0, 4
	blt a0, a1, loop_init_bss
end_init_bss:

	//csrr   t0, mstatus
	//ori    t0, t0, 8 // set bit 3 - MSIE (is this correct?) */ 
	//csrw   mstatus, t0
	jal ra, main

set_timer:
	picorv32_maskirq_insn(zero, zero)
	picorv32_timer_insn(a1, a0)
	mv a0, a1
	ret

.balign 4
end_start_code:

