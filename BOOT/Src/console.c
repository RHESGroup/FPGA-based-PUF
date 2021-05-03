#include "main.h"
#include "usart.h"
#include "FPGA.h"
#include "FPGA_Setup.h"
#include <string.h>

extern UART_HandleTypeDef huart1;
uint8_t uart_rx_char;
uint8_t uart_char_received = 1;

void parseCommand(char command);
void printConsole(char* string);
uint16_t leds = 0xAAAA;

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
		FPGA_write((uint8_t) 0x0, &leds);
		leds = (leds << 1 | leds >> 15);
	}

}

void printConsole(char* string)
{
	HAL_UART_Transmit(&huart1, (uint8_t*) string, strlen(string), 100);
}
