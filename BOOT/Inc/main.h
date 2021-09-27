/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f4xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define FPGA_TCK_Pin GPIO_PIN_4
#define FPGA_TCK_GPIO_Port GPIOE
#define FPGA_TDI_Pin GPIO_PIN_3
#define FPGA_TDI_GPIO_Port GPIOE
#define FPGA_TDO_Pin GPIO_PIN_2
#define FPGA_TDO_GPIO_Port GPIOE
#define SC_ON_OFF_Pin GPIO_PIN_1
#define SC_ON_OFF_GPIO_Port GPIOE
#define SC_RST_Pin GPIO_PIN_0
#define SC_RST_GPIO_Port GPIOE
#define FPGA_TMS_Pin GPIO_PIN_5
#define FPGA_TMS_GPIO_Port GPIOE
#define FPGA_PROGRAMN_Pin GPIO_PIN_6
#define FPGA_PROGRAMN_GPIO_Port GPIOE
#define FPGA_INTN_Pin GPIO_PIN_9
#define FPGA_INTN_GPIO_Port GPIOA
#define SD_DETECT_Pin GPIO_PIN_10
#define SD_DETECT_GPIO_Port GPIOF
#define GPIO0_RST_OUT_Pin GPIO_PIN_3
#define GPIO0_RST_OUT_GPIO_Port GPIOG
#define FPGA_RST_Pin GPIO_PIN_2
#define FPGA_RST_GPIO_Port GPIOG
/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
