#include "main.h"
#include "usart.h"
#include "FPGA.h"
#include "FPGA_Setup.h"
#include <string.h>
#include <stdio.h>

extern UART_HandleTypeDef huart1;
uint8_t uart_rx_char;
uint8_t uart_char_received = 1;
uint16_t led_address = 0;
uint16_t puf_conf = 0;

void parseCommand(char command);
void printConsole(char* string);

void ConsoleTask(void)
{
	if (uart_char_received == 1)
	{
		uart_char_received = 0;
		parseCommand(uart_rx_char);
		HAL_UART_Receive_IT(&huart1, &uart_rx_char, 1);
	}
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	uart_char_received = 1;
}


void parseCommand(char command)
{
	if (command == 'h')
	{
		printConsole("Hello world!\n\r");
	}

	else if (command == 'f')
	{
		printConsole("FPGA programming started\n\r");
		B5_FPGA_Programming();
		printConsole("FPGA programming completed\n\r");
	}

	else if (command == 'l')
	{
		printConsole("LED on\n\r");
		uint16_t leds = 0x1;
		for (int i = 0; i<8; i++)
		{
			FPGA_write((uint8_t) leds, &leds);
			leds++;
		}
	}

	else if (command == 's')
	{
		uint16_t data;
		char string[100];
		FPGA_write((uint8_t) 0x0, &led_address);
		if(FPGA_read(led_address, &data) == HAL_OK)
		{
			sprintf(string, "Showing led: %X\r\n", data);
			printConsole(string);
		}
		else
		{
			printConsole("Error reading from FPGA\r\n");
		}
		led_address = (led_address + 1) % 9;
	}

	else if (command == 'e')
	{
		if (puf_conf & 0x0010)
		{
			puf_conf &= 0xFFEF;
			FPGA_write((uint8_t) 0x1, &puf_conf);
			printConsole("PUF pre-loaded\r\n");
		}
		else
		{
			puf_conf |= 0x0010;
			FPGA_write((uint8_t) 0x1, &puf_conf);
			printConsole("PUF run!\r\n");
		}
	}

	else if (command == 'p')
	{
		uint8_t challenge;
		char string[100];

		challenge = 0x0F & puf_conf;
		challenge = (challenge+1)%16;
		puf_conf &= 0xFFF0;
		puf_conf |= challenge;
		sprintf(string, "Challenge: %X\r\n", challenge);
		printConsole(string);

	}

}

void printConsole(char* string)
{
	HAL_UART_Transmit(&huart1, (uint8_t*) string, strlen(string), 100);
}
