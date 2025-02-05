//#include "firmware.h"
#include <stdint.h>

uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	(void)irqs;

	return regs;
}

