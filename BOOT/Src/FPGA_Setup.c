/*
 * FPGA_Setup.c
 *
 *  Created on: 30 Apr 2021
 *      Author: nico
 */

#include "FPGA_Setup.h"
#include "main.h"


static SRAM_HandleTypeDef SRAM_READ;
static SRAM_HandleTypeDef SRAM_WRITE;

int FPGA_init() {

  // CONFIGURE FMC -----------------------------------------------------------------

  // INIT FMC
  FMC_NORSRAM_TimingTypeDef Timing;
  FMC_NORSRAM_TimingTypeDef ExtTiming;

  /** Perform the FPGA CS1 memory initialization sequence */
  SRAM_READ.Instance = FMC_NORSRAM_DEVICE;
  SRAM_READ.Extended = FMC_NORSRAM_EXTENDED_DEVICE;

  /* SRAM_READ.Init */
  SRAM_READ.Init.NSBank = FMC_NORSRAM_BANK1;
  SRAM_READ.Init.DataAddressMux = FMC_DATA_ADDRESS_MUX_DISABLE;
  SRAM_READ.Init.MemoryType = FMC_MEMORY_TYPE_SRAM;
  SRAM_READ.Init.MemoryDataWidth = FMC_NORSRAM_MEM_BUS_WIDTH_16;
  SRAM_READ.Init.BurstAccessMode = FMC_BURST_ACCESS_MODE_DISABLE;
  SRAM_READ.Init.WaitSignalPolarity = FMC_WAIT_SIGNAL_POLARITY_LOW;
  SRAM_READ.Init.WrapMode = FMC_WRAP_MODE_DISABLE;
  SRAM_READ.Init.WaitSignalActive = FMC_WAIT_TIMING_BEFORE_WS;
  SRAM_READ.Init.WriteOperation = FMC_WRITE_OPERATION_ENABLE;
  SRAM_READ.Init.WaitSignal = FMC_WAIT_SIGNAL_DISABLE;
  SRAM_READ.Init.ExtendedMode = FMC_EXTENDED_MODE_ENABLE;
  SRAM_READ.Init.AsynchronousWait = FMC_ASYNCHRONOUS_WAIT_DISABLE;
  SRAM_READ.Init.WriteBurst = FMC_WRITE_BURST_DISABLE;
  SRAM_READ.Init.ContinuousClock = FMC_CONTINUOUS_CLOCK_SYNC_ONLY;

  // Timing (Read)

  Timing.AccessMode = FMC_ACCESS_MODE_A;
  Timing.AddressSetupTime = 2;
  Timing.AddressHoldTime = 0;
  Timing.DataSetupTime = 2;
  Timing.BusTurnAroundDuration = 0; // don't care
  Timing.CLKDivision = 10; // don't care
  Timing.DataLatency = 2; // don't care

  /** Perform the FPGA CS2 memory initialization sequence */
  SRAM_WRITE.Instance = FMC_NORSRAM_DEVICE;
  SRAM_WRITE.Extended = FMC_NORSRAM_EXTENDED_DEVICE;

  /* SRAM_WRITE.Init */
  SRAM_WRITE.Init.NSBank = FMC_NORSRAM_BANK2;
  SRAM_WRITE.Init.DataAddressMux = FMC_DATA_ADDRESS_MUX_DISABLE;
  SRAM_WRITE.Init.MemoryType = FMC_MEMORY_TYPE_SRAM;
  SRAM_WRITE.Init.MemoryDataWidth = FMC_NORSRAM_MEM_BUS_WIDTH_16;
  SRAM_WRITE.Init.BurstAccessMode = FMC_BURST_ACCESS_MODE_DISABLE;
  SRAM_WRITE.Init.WaitSignalPolarity = FMC_WAIT_SIGNAL_POLARITY_LOW;
  SRAM_WRITE.Init.WrapMode = FMC_WRAP_MODE_DISABLE;
  SRAM_WRITE.Init.WaitSignalActive = FMC_WAIT_TIMING_BEFORE_WS;
  SRAM_WRITE.Init.WriteOperation = FMC_WRITE_OPERATION_DISABLE;
  SRAM_WRITE.Init.WaitSignal = FMC_WAIT_SIGNAL_DISABLE;
  SRAM_WRITE.Init.ExtendedMode = FMC_EXTENDED_MODE_ENABLE;
  SRAM_WRITE.Init.AsynchronousWait = FMC_ASYNCHRONOUS_WAIT_DISABLE;
  SRAM_WRITE.Init.WriteBurst = FMC_WRITE_BURST_DISABLE;
  SRAM_WRITE.Init.ContinuousClock = FMC_CONTINUOUS_CLOCK_SYNC_ONLY;

  // ExtTiming (Write)
  ExtTiming.AccessMode = FMC_ACCESS_MODE_A;
  ExtTiming.AddressSetupTime = 2;
  ExtTiming.AddressHoldTime = 0;
  ExtTiming.DataSetupTime = 2;
  ExtTiming.BusTurnAroundDuration = 0; // don't care
  ExtTiming.CLKDivision = 10; // don't care
  ExtTiming.DataLatency = 2; // don't care


  HAL_SRAM_Init(&SRAM_READ, &Timing, &ExtTiming);
  HAL_SRAM_Init(&SRAM_WRITE, &Timing, &ExtTiming);



  // INIT GPIO
  GPIO_InitTypeDef GPIO_InitStruct;

  /* Peripheral clock enable */
  __FMC_CLK_ENABLE();

  __GPIOF_CLK_ENABLE();
  __GPIOE_CLK_ENABLE();
  __GPIOD_CLK_ENABLE();
  __GPIOG_CLK_ENABLE();

  /** FMC GPIO Configuration
  PF0   ------> FMC_A0
  PF1   ------> FMC_A1
  PF2   ------> FMC_A2
  PF3   ------> FMC_A3
  PF4   ------> FMC_A4
  PF5   ------> FMC_A5
  PE7   ------> FMC_D4
  PE8   ------> FMC_D5
  PE9   ------> FMC_D6
  PE10   ------> FMC_D7
  PE11   ------> FMC_D8
  PE12   ------> FMC_D9
  PE13   ------> FMC_D10
  PE14   ------> FMC_D11
  PE15   ------> FMC_D12
  PD8   ------> FMC_D13
  PD9   ------> FMC_D14
  PD10   ------> FMC_D15
  PD14   ------> FMC_D0
  PD15   ------> FMC_D1
  PD0   ------> FMC_D2
  PD1   ------> FMC_D3
  PD4   ------> FMC_NOE
  PD5   ------> FMC_NWE
  PD7   ------> FMC_NE1
  PG9   ------> FMC_NE2
  PE4 	------> FPGA TCK
  PE2 	------> FPGA TDO
  PE1   ------> SC ON OFF
  PE0 	------> SC RST
  PE5 	------> FPGA TMS
  PE6 	------> FPGA PROGRAMN
  PG3 	------> GPIO0_RST:OUT
  PG2 	------> FPGA RST
  PE3	------> FPGA TDI
  */

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOE, FPGA_TCK_Pin|FPGA_TDO_Pin|SC_ON_OFF_Pin|SC_RST_Pin
                          |FPGA_TMS_Pin|FPGA_PROGRAMN_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOG, GPIO0_RST_OUT_Pin|FPGA_RST_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pins : PEPin PEPin PEPin PEPin
                           PEPin PEPin */
  GPIO_InitStruct.Pin = FPGA_TCK_Pin|FPGA_TDI_Pin|SC_ON_OFF_Pin|SC_RST_Pin
                          |FPGA_TMS_Pin|FPGA_PROGRAMN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_LOW;
  HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);


  /*Configure GPIO pin : PtPin */
  GPIO_InitStruct.Pin = FPGA_TDO_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(FPGA_TDI_GPIO_Port, &GPIO_InitStruct);

  GPIO_InitStruct.Pin = GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_2 | GPIO_PIN_3 | GPIO_PIN_4 | GPIO_PIN_5;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FAST;
  GPIO_InitStruct.Alternate = GPIO_AF12_FMC;
  HAL_GPIO_Init(GPIOF, &GPIO_InitStruct);

  GPIO_InitStruct.Pin = GPIO_PIN_7 | GPIO_PIN_8 | GPIO_PIN_9 | GPIO_PIN_10 | GPIO_PIN_11 | GPIO_PIN_12 | GPIO_PIN_13 | GPIO_PIN_14 | GPIO_PIN_15;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FAST;
  GPIO_InitStruct.Alternate = GPIO_AF12_FMC;
  HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);

  GPIO_InitStruct.Pin = GPIO_PIN_8 | GPIO_PIN_9 | GPIO_PIN_10 | GPIO_PIN_14 | GPIO_PIN_15 | GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_4 | GPIO_PIN_5 | GPIO_PIN_7;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FAST;
  GPIO_InitStruct.Alternate = GPIO_AF12_FMC;
  HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);

  GPIO_InitStruct.Pin = GPIO_PIN_9;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FAST;
  GPIO_InitStruct.Alternate = GPIO_AF12_FMC;
  HAL_GPIO_Init(GPIOG, &GPIO_InitStruct);

  // CONFIGURE RESET ---------------------------------------------------------------

  /* Set pin PG2 as reset for the FPGA */
  GPIO_InitStruct.Pin = FPGA_RST_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FAST;
  HAL_GPIO_Init(GPIOG, &GPIO_InitStruct);



  // CONFIGURE OUTPUT CLOCK --------------------------------------------------------

  /* Enable clock for GPIOA */
  __HAL_RCC_GPIOA_CLK_ENABLE();
  /* Enable clock for SYSCFG */
  __HAL_RCC_SYSCFG_CLK_ENABLE();

  /* Set pin PA8 as clock for the FPGA */
  GPIO_InitStruct.Pin = GPIO_PIN_8;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FAST;
  GPIO_InitStruct.Alternate = GPIO_AF0_MCO;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  //Clock FPGA
  /* Set MCO1 output = PLLCLK with prescaler 2 -> 180MHz / 2 = 90MHz */
  __HAL_RCC_MCO1_CONFIG(RCC_MCO1SOURCE_PLLCLK, RCC_MCODIV_2);

  // CONFIGURE INTERRUPT -----------------------------------------------------------

  /* Set variables used */
  EXTI_InitTypeDef EXTI_InitStruct;
  NVIC_InitTypeDef NVIC_InitStruct;

  /* Set pin PA9 as interrupt line from the FPGA */
  GPIO_InitStruct.Pin = FPGA_INTN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FAST;
  HAL_GPIO_Init(FPGA_INTN_GPIO_Port, &GPIO_InitStruct);

  /* Tell system that you will use PA9 for EXTI_Line9 */
  SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOA, EXTI_PinSource9);

  /* PA9 is connected to EXTI_Line9 */
  EXTI_InitStruct.EXTI_Line = EXTI_Line9;
  /* Enable interrupt */
  EXTI_InitStruct.EXTI_LineCmd = ENABLE;
  /* Interrupt mode */
  EXTI_InitStruct.EXTI_Mode = EXTI_Mode_Interrupt;
  /* Triggers on rising edge */
  EXTI_InitStruct.EXTI_Trigger = EXTI_Trigger_Rising;
  /* Add to EXTI */
  EXTI_Init(&EXTI_InitStruct);

  /* Add IRQ vector to NVIC */
  /* PA9 is connected to EXTI_Line9, which has EXTI9_5_IRQn vector */
  NVIC_InitStruct.NVIC_IRQChannel = EXTI9_5_IRQn;
  /* Set priority */
  NVIC_InitStruct.NVIC_IRQChannelPreemptionPriority = 0x00;
  /* Set sub priority */
  NVIC_InitStruct.NVIC_IRQChannelSubPriority = 0x01;
  /* Enable interrupt */
  NVIC_InitStruct.NVIC_IRQChannelCmd = ENABLE;
  /* Add to NVIC */
  NVIC_Init(&NVIC_InitStruct);


  return 0;
}


int FPGA_read(uint8_t address, uint16_t *dataPtr) {
	HAL_StatusTypeDef status;

	uint32_t addr = (FPGA_SRAM_BASE_ADDR + 2 * address);
	status = HAL_SRAM_Read_16b(&SRAM_READ, (uint32_t*)addr, dataPtr, 1);
	return status == HAL_OK ? 0 : 1;
}


int FPGA_write(uint8_t address, uint16_t *dataPtr) {
	HAL_StatusTypeDef status;

	uint32_t addr = (FPGA_SRAM_BASE_ADDR + 2 * address);
	status = HAL_SRAM_Write_16b(&SRAM_WRITE, (uint32_t*)addr, dataPtr, 1);
	return status == HAL_OK ? 0 : 1;
}
