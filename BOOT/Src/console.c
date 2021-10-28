#include "main.h"
#include "usart.h"
#include "FPGA.h"
#include "FPGA_Setup.h"
#include <string.h>
#include <stdio.h>

#define PACKET_SIZE 16

extern UART_HandleTypeDef huart1;
uint8_t command[PACKET_SIZE];
uint8_t uart_char_received = 1;
uint16_t led_address = 0;
uint16_t challenge = 0xACE1u;


uint16_t previous_count = 0;

void parseCommand(uint8_t *command);
void printConsole(char* string);
void sendPacketSerial(uint8_t *data);

void ConsoleTask(void)
{
	if (uart_char_received == 1)
	{
		uart_char_received = 0;
		parseCommand(command);
		HAL_UART_Receive_DMA(&huart1, command, PACKET_SIZE);
	}
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	uart_char_received = 1;
}


void parseCommand(uint8_t *command)
{
	uint8_t out_buffer[PACKET_SIZE];

	if (!strncmp(command, "helo", 4))
	{
		memset(out_buffer,0, PACKET_SIZE);
		memcpy(out_buffer, "Hello world!\n\0", 14);
		sendPacketSerial(out_buffer);
		return;
	}

	else if (!strncmp(command, "fpga", 4))
	{
		memset(out_buffer,0, PACKET_SIZE);
		memcpy(out_buffer, "fpgaprog", 8);
		sendPacketSerial(out_buffer);
		B5_FPGA_Programming();
		memcpy(out_buffer, "fpgaredy", 8);
		sendPacketSerial(out_buffer);
		return;
	}

	else if (!strncmp(command, "puff", 4))
	{
		uint16_t run_puf_mask = 16;
		uint16_t responseH, responseL, responseHH, responseLL;
		uint16_t challengeH, challengeL, challengeHH, challengeLL;

		challengeHH = (uint16_t)*(command+4);
		challengeH = (uint16_t)*(command+6);
		challengeL = (uint16_t)*(command+8);
		challengeLL = (uint16_t)*(command+10);

		FPGA_write((uint8_t) 0x2, &challengeHH);
		FPGA_write((uint8_t) 0x3, &challengeH);
		FPGA_write((uint8_t) 0x4, &challengeL);
		FPGA_write((uint8_t) 0x5, &challengeLL);


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

		memset(out_buffer,0, PACKET_SIZE);

		memcpy(out_buffer, &responseL, 2);
		memcpy(out_buffer+2, &responseH, 2);
		memcpy(out_buffer+4, &responseHH, 2);
		memcpy(out_buffer+6, &responseLL, 2);

		sendPacketSerial(out_buffer);

		return;
	}

}

void printConsole(char* string)
{
	HAL_UART_Transmit_DMA(&huart1, (uint8_t*) string, strlen(string));
}

void sendPacketSerial(uint8_t *data)
{
	HAL_UART_Transmit(&huart1, data, PACKET_SIZE, 1000);
}
