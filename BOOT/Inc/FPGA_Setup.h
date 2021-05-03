#ifndef __FPGA_SETUP_H
#define __FPGA_SETUP_H


#include "stm32f4xx_hal.h"
#include "stm32f4xx_hal_sram.h"
#include "stm32f4xx.h"
//TODO: added this files directly to project
#include "stm32f4xx_exti.h"
#include "stm32f4xx_syscfg.h"
#include "misc.h"


#define FPGA_SRAM_BASE_ADDR    0x60000000U

//Initialize FPGA for communicating using FMC
int FPGA_init();

//Read from FPGA
int FPGA_read(uint8_t address, uint16_t *dataPtr);

//Write to FPGA
int FPGA_write(uint8_t address, uint16_t *dataPtr);


#endif
