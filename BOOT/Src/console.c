#include "main.h"
#include "usart.h"
#include "FPGA.h"
#include "FPGA_Setup.h"
#include <string.h>
#include <stdio.h>

#define MAX_OSC 400
#define COMMAND_SIZE 4
#define N_BISTABLES 8
#define BUFFER_SIZE (2*N_BISTABLES*MAX_OSC)


extern uint8_t stlink_serial[12];
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

	else if (!strncmp(command, "seri", 4))
	{
		memcpy(buffer, stlink_serial, 12);
		sendPacketSerial(buffer, 25);
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
		uint16_t n_osc[N_BISTABLES*MAX_OSC];
		uint16_t n_osc_tmp;

		int i;
		int j;

		memset(n_osc, 0, sizeof(n_osc));

		for (i=0; i<run_number; i++)
		{
			run_puf_mask = 16;
			FPGA_write((uint8_t) 0x1, &run_puf_mask);

			while(run_puf_mask & 16)
			{
				FPGA_read((uint8_t) 0x1, &run_puf_mask);
			}


			for(j = 0; j<N_BISTABLES; j++)
			{
				FPGA_read((uint8_t) 0x6+j, &n_osc_tmp);
				if(n_osc_tmp < MAX_OSC)
					n_osc[MAX_OSC*j + n_osc_tmp]++;
			}


		}

		memset(buffer,0, BUFFER_SIZE);

		memcpy(buffer, n_osc, 2*N_BISTABLES*MAX_OSC);
		sendPacketSerial(buffer, 2*N_BISTABLES*MAX_OSC);

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
