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

volatile uint16_t c;



int main()
{
    uint32_t v;
	uint32_t cnt = 0;
    uint32_t n[] = {ZERO, ONE, TWO, THREE};
    
    REG_GPIO_DIR1 = SEVEN_SEG_PINS;
    REG_GPIO_DATA1 = FOUR | ANODE1;

    REG_GPIO_DIR0 = 0xffff;
    REG_GPIO_DATA0 = 0xaaaa;

    REG_RNG_CTRL = RNG_EN;
    while(1) {
        v = REG_GPIO_PIN1;
        if (v & 1) {
            while(!(REG_RNG_STATUS & RNG_RDY));
            cnt = REG_RNG_OUT & 0x3;
        }
        REG_GPIO_DATA1 = n[cnt] | ANODE1;
    }

    REG_DBG0 = 0xaa;
    while(1);

    return 0;
}

