/*
 * main.c
 *
 *  Created on: 2016/10/14
 *      Author: User
 */

#include <stdio.h>
#include "system.h"
#include "esp8266.h"
#include <altera_avalon_pio_regs.h>

int main()
{
    printf("Hello from Nios II! Modified!\n");

    esp8266_init(true);
    hello_world();
    //esp8266_listen();

    return 0;
}

const char *pc_server_domain = "192.168.10.55";
const char *get_time_request = "hello world";

void hello_world()
{
    bool success = true;
    char cmd_buffer[100];
    char buffer[1000];
    if (success) {
        sprintf(cmd_buffer, "AT+CIPSTART=\"UDP\",\"%s\",8080",
        		pc_server_domain);
        success = esp8266_send_command(cmd_buffer);
    }

    else{
    	printf("failed at point 1");
    }

    if (success) {
        sprintf(cmd_buffer, "AT+CIPSEND=%d", strlen(get_time_request));
        success = esp8266_send_command(cmd_buffer);
    }
    else{
    	printf("failed at point 2");
    }

    if (success) {
        success = esp8266_send_data(get_time_request, strlen(get_time_request));
    }
    else{
    	printf("failed at point 3");
    }
    printf("attempted");

    while(1){
    	usleep(3 * 1000 * 1000);
    	int sw;
    	sw = IORD_ALTERA_AVALON_PIO_DATA(0x81060);
    	char str[10];
    	sprintf(str, "%d", sw);
    	bool success = true;
    	char cmd_buffer[100];
    	char buffer[1000];
   	    if (success) {
   	        sprintf(cmd_buffer, "AT+CIPSEND=%d", strlen(str));
   	        printf(str);
   	        success = esp8266_send_command(cmd_buffer);
   	    }
   	    else{
   	    	sprintf(cmd_buffer, "AT+CIPSEND=%d", strlen(str));
   	    	printf(str);
   	    	printf("failed at point 2, %d", strlen(str));
   	    }
   	    if (success) {
   	        success = esp8266_send_data(&str, strlen(&str));
   	    }
   	    else{
   	    	printf("failed at point 3");
   	    }
   	    printf("attempted");
    }

}
