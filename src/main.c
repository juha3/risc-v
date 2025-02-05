#include <stdint.h>

#define DBG0_BASE  0x03000000
#define UART0_BASE 0x03001000
#define RNG0_BASE  0x03002000
#define GPIO_BASE  0x03003000

#define REG_DBG0 *((volatile uint32_t*)(DBG0_BASE + 0x4))
#define REG_DBG1 *((volatile uint32_t*)(DBG0_BASE + 0x8))
#define REG_LED *((volatile uint32_t*)(DBG0_BASE + 0xc))

#define REG_RNG_OUT *((volatile uint32_t*)(RNG0_BASE + 0x0))
#define REG_RNG_STATUS *((volatile uint32_t*)(RNG0_BASE + 0x4))
#define REG_RNG_CTRL *((volatile uint32_t*)(RNG0_BASE + 0x8))

#define REG_UART_TX_DATA *((volatile uint32_t*)(UART0_BASE + 0x0))
#define REG_UART_RX_DATA *((volatile uint32_t*)(UART0_BASE + 0x4))
#define REG_UART_CTRL *((volatile uint32_t*)(UART0_BASE + 0x8))
#define REG_UART_STATUS *((volatile uint32_t*)(UART0_BASE + 0xc))

#define REG_GPIO_DATA0 *((volatile uint32_t*)(GPIO_BASE + 0x0))
#define REG_GPIO_DATA1 *((volatile uint32_t*)(GPIO_BASE + 0x4))
#define REG_GPIO_PIN0 *((volatile uint32_t*)(GPIO_BASE + 0x10))
#define REG_GPIO_PIN1 *((volatile uint32_t*)(GPIO_BASE + 0x14))
#define REG_GPIO_DIR0 *((volatile uint32_t*)(GPIO_BASE + 0x30))
#define REG_GPIO_DIR1 *((volatile uint32_t*)(GPIO_BASE + 0x34))

#define RNG_EN (1 << 0)
#define RNG_RDY (1 << 0)

#define SIM (1 << 0)

#define BAUDRATE_115200 868
#define UART_BUSY (1 << 0)
#define UART_DATA_READY (1 << 1)
#define UART_OVERFLOW (1 << 2)
/*
	GPIO 

     DATA0 R/W 0x0300 3000
     DATA1 R/W 0x0300 3004
     PIN0  R   0x0300 3010
     PIN1  R   0x0300 3014
     DIR0  R/W 0x0300 3030
     DIR1  R/W 0x0300 3034
	.port0({sw, led}),
	.port1({sevenseg, anode, btnc, btnu, btnr, btnl, btnd}),
 */
#define SEVEN_SEG_PINS (0xfff << 5)

#define LEDS_ALL 0xff
#define BTND (1 << 0)
#define BTNL (1 << 1)
#define BTNR (1 << 2
#define BTNU (1 << 3)
#define BTNC (1 << 4)
#define ANODE0 (0xe << 5)
#define ANODE1 (0xd << 5)
#define ANODE2 (0xb << 5)
#define ANODE3 (0x7 << 5)
#define SEVEN_SEG_A (0xfe << 9)
#define SEVEN_SEG_B (0xfd << 9)
#define SEVEN_SEG_C (0xfb << 9)
#define SEVEN_SEG_D (0xf7 << 9)
#define SEVEN_SEG_E (0xef << 9)
#define SEVEN_SEG_F (0xdf << 9)
#define SEVEN_SEG_G (0xbf << 9)
#define SEVEN_SEG_P (0x7f << 9)
#define ZERO (SEVEN_SEG_A & SEVEN_SEG_B & SEVEN_SEG_C & SEVEN_SEG_D & SEVEN_SEG_E & SEVEN_SEG_F)
#define ONE (SEVEN_SEG_C & SEVEN_SEG_B)
#define TWO (SEVEN_SEG_A & SEVEN_SEG_B & SEVEN_SEG_G & SEVEN_SEG_D & SEVEN_SEG_E )
#define THREE (SEVEN_SEG_A & SEVEN_SEG_B & SEVEN_SEG_G & SEVEN_SEG_D & SEVEN_SEG_C)
#define FOUR (SEVEN_SEG_B & SEVEN_SEG_G & SEVEN_SEG_F & SEVEN_SEG_C)
#define FIVE (SEVEN_SEG_A & SEVEN_SEG_F & SEVEN_SEG_G & SEVEN_SEG_D & SEVEN_SEG_C )
#define SIX (SEVEN_SEG_A & SEVEN_SEG_F & SEVEN_SEG_G & SEVEN_SEG_D & SEVEN_SEG_C & SEVEN_SEG_E)
#define SEVEN (SEVEN_SEG_C & SEVEN_SEG_B & SEVEN_SEG_A)
#define EIGHT (SEVEN_SEG_A & SEVEN_SEG_B & SEVEN_SEG_C & SEVEN_SEG_D & SEVEN_SEG_E & SEVEN_SEG_F &SEVEN_SEG_G)
#define NINE (SEVEN_SEG_A & SEVEN_SEG_B & SEVEN_SEG_C & SEVEN_SEG_D & SEVEN_SEG_F &SEVEN_SEG_G)

#define NUMBERS {ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE}

/*


     aa 
    f  b
    f  b
     gg 
    e  c 
    e  c 
     dd  p 

*/

 
//#define REG_TIMER *((volatile uint32_t*)(0x80000000))
//#define REG_FINISH *((volatile uint32_t*)(0xffc))

//#define UART_DATA *((volatile uint32_t*)(0xc0000000))
//#define UART_STATUS *((volatile uint32_t*)(0xc0000004))
//#define UART_CTRL *((volatile uint32_t*)(0xc0000008))
//
//#define UART_DATA_TX_BUSY (1 << 0)
//#define UART_DATA_RDY (1 << 1)
//
//#define UART_CTRL_IEN (1 << 0)

//volatile uint32_t flag;
//volatile uint8_t uart_byte;
//volatile uint8_t uart_data_rdy;

/* general IRQ handler */
//void irq_handler()
//{
//	REG_TIMER += 1000000;
//
//	if (UART_STATUS & UART_DATA_RDY) {
//		uart_byte = UART_DATA;
//		uart_data_rdy = 1;
//	}
//}

//void dbg_print_str(char *s)
//{
//	(void)s;
//#ifdef SIM
//	while(1) {
//		if (*s == 0) break;
//		REG_DBG = *s++;
//	}
//#endif
//}

//void dbg_print_int(int32_t v)
//{
//	int v1 = 1000000000;
//	int v2;
//	char b[2] = {0};
//
//	if (v == 0) {
//		dbg_print_str("0");
//		return;
//	}
//	while(1) {
//		v2 = v / v1;
//		if (b[0] || v2 || v1 <= 10) {
//			b[0] = 0x30 + v2;
//			dbg_print_str(b); 
//		}
//		v = v % v1;
//		v1 = v1 / 10;
//		if (v1 == 0) break;
//	}
//}

//uint32_t set_timer(uint32_t t);
volatile uint16_t c;


int loop()
{
//	uint32_t v;

	//char b[2] = {0};
	//int i;
	//if (UART_STATUS == 0x00) while(1);	

//	for (c = 0; ; c++) {
//		REG_LED = (c & (1 << 13)) ? 1 : 0;
////		if (c == (1 << 12)) 
////			REG_UART = 'a';
//	}
//	REG_UART = 'x';
	//UART_DATA = 'x';
	//while((UART_STATUS & UART_DATA_TX_BUSY));
	
//	while(1) {
//		v = UART_STATUS;
//		if ((v & UART_DATA_RDY)) {
//			v = UART_DATA;
//			UART_DATA = v & 0xff;
//			break;
//		}
//	}
//	while(uart_data_rdy == 0);
//	uart_data_rdy = 0;
//	v = uart_byte;
//	UART_DATA = v & 0xff;
//
//	while((UART_STATUS & UART_DATA_TX_BUSY));
//	//REG_UART = 0xbb;
//	//for (c = 0; c < 100; c++) {
//	//	REG_LED = (c & (1 << 4)) ? 1 : 0;
//	//}
//	v &= 0xff;
//	if (v == '1') REG_LED = 1;
//	if (v == '0') REG_LED = 0;

//	for (i = 0; i < 10; i++) {
//		b[0] = i + 0x30;
//		dbg_print_str(b);
//	}
//	dbg_print_str("\n");
//	dbg_print_int(1500);
//	dbg_print_str("\n");
//	i = set_timer(100);
//	while(flag == 0);
//	dbg_print_str("done\n");

//	while(1);
//	return 0;
	return 0;
}


int main()
{
    //int i;
    //int n; 
    uint32_t v;
	uint32_t cnt = 0;
    uint32_t n[] = {ZERO, ONE, TWO, THREE};
    //n = (REG_DBG0 & SIM) ? 10 : 100000000;
    
    REG_GPIO_DIR1 = SEVEN_SEG_PINS;
    REG_GPIO_DATA1 = FOUR | ANODE1;

    REG_GPIO_DIR0 = 0xffff;
    REG_GPIO_DATA0 = 0xaaaa;

    REG_RNG_CTRL = RNG_EN;
    while(1) {
        v = REG_GPIO_PIN1; // btnd to toggle led0
        //if (v & 1) REG_GPIO_DATA0 |= 1;
        //else REG_GPIO_DATA0 &= ~(0x1);
        if (v & 1) {
            while(!(REG_RNG_STATUS & RNG_RDY));
            cnt = REG_RNG_OUT & 0x3;
            //cnt = (cnt + 1);
            //if (cnt == 4) cnt = 0;
        }
        REG_GPIO_DATA1 = n[cnt] | ANODE1;
    }
    //for (i = 0; i < n; i++) {
    //    while(!(REG_RNG_STATUS & RNG_RDY));
    //    while(REG_UART_STATUS & UART_BUSY);
    //    REG_UART_TX_DATA = REG_RNG_OUT;
    //}
    //    
    //while(REG_UART_STATUS & UART_BUSY);

    REG_DBG0 = 0xaa;
    while(1);

    return 0;
}

