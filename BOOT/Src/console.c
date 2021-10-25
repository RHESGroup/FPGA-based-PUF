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
uint16_t challenge = 0xACE1u;


uint16_t previous_count = 0;

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

	/*else if (command == 'e')
	{
		if (puf_conf & 0x0010)
		{
			puf_conf &= 0xFFEF;
			FPGA_write((uint8_t) 0x1, &puf_conf);
			printConsole("PUF pre-loaded\r\n");
		}
		else
		{
			uint16_t puf_response;
			char string[100];

			puf_conf |= 0x0010;
			FPGA_write((uint8_t) 0x1, &puf_conf);
			printConsole("PUF run!\r\n");
			FPGA_read((uint8_t) 0x2, &puf_response);
			puf_response &= 0x0001;
			sprintf(string, "Response: %d\r\n", puf_response);
			printConsole(string);
		}
	}*/

	else if (command == 'p')
	{
		char string[100];
		uint16_t run_puf_mask = 16;
		uint16_t responseH, responseL, responseHH, responseLL;
		uint16_t count;
		uint16_t media = 0x0;
		uint16_t zeros = 0x0;
		uint16_t bit;
		uint8_t run_count;
		int i;

		FPGA_write((uint8_t) 0x2, &zeros);
		FPGA_write((uint8_t) 0x3, &zeros);
		FPGA_write((uint8_t) 0x4, &zeros);
		FPGA_write((uint8_t) 0x5, &challenge);

		run_count = 0;
		for (i = 0; i < 100; i++)
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
			if(responseLL == 0xAAAA || responseLL == 0x5555)
			{
				media = media+responseL;
				run_count++;
			}

			//FPGA_read((uint8_t) 0x3, (uint16_t*) (&response+2));

		}
		media = media/run_count;

		sprintf(string, "\r\n\r\nChallenge: %04X.   Valid measures: %d\r\n", challenge, run_count);
		printConsole(string);

		sprintf(string, "Final value: %01X\r\n", responseLL);
		printConsole(string);

		/*responseLL = responseLL & 0xFFFE;
		count = 0;

		while (responseLL) {
				count += responseLL & 1;
				responseLL >>= 1;
		}

		while (responseL) {
		        count += responseL & 1;
		        responseL >>= 1;
		}

		while (responseH) {
				count += responseH & 1;
				responseH >>= 1;
		}

		while (responseHH) {
				count += responseHH & 1;
				responseHH >>= 1;
		}
*/


		count =  media;// - previous_count;
		sprintf(string, "Number of oscillations: %u\r\n", count);
		printConsole(string);
		printConsole("Number of oscillations: ");
		for(int bit=0;bit<(sizeof(count) * 8); bit++)
		{
		  sprintf(string, "%i", count & 0x1);
		  printConsole(string);
		  count = count >> 1;
		}

		printConsole("\r\n");

		//bit = ((challenge >> 0) ^ (challenge >> 2) ^ (challenge >> 3) ^ (challenge >> 5)) /* & 1u */;
		//challenge = (challenge >> 1) | (bit << 15);
		challenge = challenge+0x10;
	}

}

void printConsole(char* string)
{
	HAL_UART_Transmit(&huart1, (uint8_t*) string, strlen(string), 100);
}
