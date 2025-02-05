
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
