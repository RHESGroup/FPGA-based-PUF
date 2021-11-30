#include "main.h"
#include "usart.h"
#include "FPGA.h"
#include "FPGA_Setup.h"
#include <string.h>
#include <stdio.h>

#define COMMAND_SIZE 4
#define BUFFER_SIZE 16

extern UART_HandleTypeDef huart1;
uint8_t command[COMMAND_SIZE];
uint8_t uart_char_received = 1;
uint16_t led_address = 0;
uint16_t run_number = 0;


uint16_t previous_count = 0;

void parseCommand(uint8_t *command);
void printConsole(char* string);
void sendPacketSerial(uint8_t *data, int size);

void ConsoleTask(void)
{
	/*if (uart_char_received == 1)
	{
		uart_char_received = 0;
		parseCommand(command);
		HAL_UART_Receive_DMA(&huart1, command, COMMAND_SIZE);
	}*/
	if (HAL_UART_Receive(&huart1, command, COMMAND_SIZE, 1000) == HAL_OK)
		parseCommand(command);
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	uart_char_received = 1;
}


void parseCommand(uint8_t *command)
{
	uint8_t buffer[BUFFER_SIZE];

	if (!strncmp(command, "helo", 4))
	{
		memset(buffer,0, BUFFER_SIZE);
		memcpy(buffer, "Hello world!\n\0", 14);
		sendPacketSerial(buffer, 16);
		return;
	}

	else if (!strncmp(command, "fpga", 4))
	{
		memset(buffer,0, BUFFER_SIZE);
		memcpy(buffer, "fpgaprog", 8);
		sendPacketSerial(buffer, 8);
		B5_FPGA_Programming();
		memcpy(buffer, "fpgaredy", 8);
		sendPacketSerial(buffer, 8);
		return;
	}

	else if (!strncmp(command, "chal", 4))
	{
		uint16_t challengeH, challengeL, challengeHH, challengeLL;

		HAL_UART_Receive(&huart1, buffer, 10, 1000);

		challengeHH = *(uint16_t*)(buffer);
		challengeH = *(uint16_t*)(buffer+2);
		challengeL = *(uint16_t*)(buffer+4);
		challengeLL = *(uint16_t*)(buffer+6);

		run_number = *(uint16_t*)(buffer+8);

		FPGA_write((uint8_t) 0x2, &challengeHH);
		FPGA_write((uint8_t) 0x3, &challengeH);
		FPGA_write((uint8_t) 0x4, &challengeL);
		FPGA_write((uint8_t) 0x5, &challengeLL);

	}

	else if (!strncmp(command, "puff", 4))
	{
		uint16_t run_puf_mask = 16;
		uint16_t responseH, responseL, responseHH, responseLL;
		int i;

		for (i=0; i<run_number; i++)
		{
			run_puf_mask = 16;
			FPGA_write((uint8_t) 0x1, &run_puf_mask);

			while(run_puf_mask & 16)
			{
				FPGA_read((uint8_t) 0x1, &run_puf_mask);
			}

			FPGA_read((uint8_t) 0x6, &responseHH);
			FPGA_read((uint8_t) 0x7, &responseH);
			FPGA_read((uint8_t) 0x8, &responseL);
			FPGA_read((uint8_t) 0x9, &responseLL);

			memset(buffer,0, BUFFER_SIZE);

			memcpy(buffer, &responseLL, 2);
			memcpy(buffer+2, &responseL, 2);
			memcpy(buffer+4, &responseH, 2);
			memcpy(buffer+6, &responseHH, 2);

			sendPacketSerial(buffer, 8);
		}

		return;
	}

}

void printConsole(char* string)
{
	HAL_UART_Transmit(&huart1, (uint8_t*) string, COMMAND_SIZE, 1000);
}

void sendPacketSerial(uint8_t *data, int size)
{
	HAL_UART_Transmit(&huart1, data, size, 1000);
}
