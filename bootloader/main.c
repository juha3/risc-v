#include <stdint.h>

#define REG_DBG *((volatile uint32_t*)(0x0000a000))
#define REG_LED *((volatile uint32_t*)(0x40000000))
#define REG_TIMER *((volatile uint32_t*)(0x80000000))
#define REG_FINISH *((volatile uint32_t*)(0x1ffc))

#define UART_DATA *((volatile uint32_t*)(0xc0000000))
#define UART_STATUS *((volatile uint32_t*)(0xc0000004))
#define UART_CTRL *((volatile uint32_t*)(0xc0000008))

#define UART_DATA_TX_BUSY (1 << 0)
#define UART_DATA_RDY (1 << 1)

#define UART_CTRL_IEN (1 << 0)

#define RAMFUNC  __attribute__((section(".data"))) __attribute__ ((__used__))

volatile uint32_t flag;
volatile uint8_t uart_byte;
volatile uint8_t uart_data_rdy;

///* general IRQ handler */
//void irq_handler()
//{
//	REG_TIMER += 1000000;
//
//	if (UART_STATUS & UART_DATA_RDY) {
//		uart_byte = UART_DATA;
//		uart_data_rdy = 1;
//	}
//}

RAMFUNC void dbg_print_str(char *s)
{
	(void)s;
#ifdef SIM
	while(1) {
		if (*s == 0) break;
		REG_DBG = *s++;
	}
#endif
}

//uint32_t set_timer(uint32_t t);
//volatile uint16_t c;



extern void start(void);

RAMFUNC int main()
{
	int i;
	uint32_t v;
	uint8_t magic[4] = {0x52, 0x56, 0x33, 0x32};
	int32_t length = 0;
	uint8_t *p = 0;
	/* make this local variable, otherwise it will be overwritten by new FW */
	char final_msg[] = "payload received, booting...\n";

	dbg_print_str("bootloader!\n");
	REG_LED = 1;

	/* wait for magic sequence */
	for (i = 0; i < 4;) {
		v = UART_STATUS;
		if ((v & UART_DATA_RDY)) {
			if (UART_DATA == magic[i]) {
				dbg_print_str("*");
				i++;
				REG_LED = 0;
			}
			else {
				dbg_print_str("#");
				i = 0;
				REG_LED = 1;
			}
		}
	}
	dbg_print_str("valid magic detected\n");
	/* receive payload length */
	for (i = 0; i < 4;) {
		v = UART_STATUS;
		if ((v & UART_DATA_RDY)) {
			length |= (UART_DATA << (i * 8));
			i++;
		}
	}
	dbg_print_str("payload length received\n");

	for (i = 0; i < length;) {
		v = UART_STATUS;
		if ((v & UART_DATA_RDY)) {
			p[i] = UART_DATA;
			i++;
		}
	
	}
	dbg_print_str(final_msg);
	start();

//#ifdef SIM
//	REG_FINISH = 0x12345678;
//#endif

	while(1);
	return 0;
}

