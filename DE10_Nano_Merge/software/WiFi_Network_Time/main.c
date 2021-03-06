/*
 * main.c
 *
 *  Created on: 2016/10/14
 *      Author: User
 */

#include <stdio.h>
#include <errno.h>
#include "system.h"
#include "esp8266.h"
#include <string.h>
#include <unistd.h>
#include <altera_avalon_pio_regs.h>
//#include "SEG7.h"
extern int errno ;

int main()
{
    printf("Hello from Nios II! Modified!\n");
    printf("done");
    while (esp8266_init(true) == false) {
    	printf("entered");
        usleep(3 * 1000 * 1000);
        printf("passed");
        int sw;
        sw = IORD_ALTERA_AVALON_PIO_DATA(PIO_X_BASE);
        char str1[8];
        sprintf(str1, "%d", sw);
        printf(str1);
    }

    hello_world();

    return 0;
}

const char *pc_server_domain = "192.168.10.55";//"192.168.12.108";
const char *greetings = "hello world";

void hello_world()
{
    bool success = true;
    char cmd_buffer[100];
    //char buffer[1000];
    if (success) {
        sprintf(cmd_buffer, "AT+CIPSTART=\"UDP\",\"%s\",8080",
        		pc_server_domain);
        success = esp8266_send_command(cmd_buffer);
    }

    else{
    	printf("failed at point 1");
    }

    if (success) {
        sprintf(cmd_buffer, "AT+CIPSEND=%d", strlen(greetings));
        success = esp8266_send_command(cmd_buffer);
    }
    else{
    	printf("failed at point 2");
    }

    if (success) {
        success = esp8266_send_data(greetings, strlen(greetings));
    }
    else{
    	printf("failed at point 3");
    }
    printf("attempted");

    while(1){
    	usleep(1 * 100 * 1000);
    	int sw1;
    	int sw2;
    	int sw3;
    	int sw4;
    	sw1 = IORD_ALTERA_AVALON_PIO_DATA(PIO_X_BASE);
    	//printf("Center X: %d\n", sw1);
    	char str1[20];

    	sw2 = IORD_ALTERA_AVALON_PIO_DATA(PIO_Y_BASE);

    	//printf("Center Y: %d\n", sw2);
    	sw3 = IORD_ALTERA_AVALON_PIO_DATA(PIO_WIDTH_BASE);
		//printf("Width: %d\n", sw3);

    	sw4 = IORD_ALTERA_AVALON_PIO_DATA(PIO_HEIGHT_BASE);
    	//printf("Height: %d\n", sw4);
    	sprintf(str1, "%d\n%d\n%d\n%d\n", sw1,sw2,sw3,sw4);

    	printf("%s\n", str1);
    	bool success = true;
    	char cmd_buffer[100];
    	//char buffer[1000];
   	    if (success) {
   	        sprintf(cmd_buffer, "AT+CIPSEND=%d", strlen(str1));
   	        //printf(str1);
   	        success = esp8266_send_command(cmd_buffer);
   	    }
   	    else{
   	    	sprintf(cmd_buffer, "AT+CIPSEND=%d", strlen(str1));
   	    	//printf(str1);
   	    	printf("failed at point 2, %d", strlen(str1));
   	    }
   	    if (success) {
   	        success = esp8266_send_data(str1, strlen(str1));
   	    }
   	    else{
   	    	printf("failed at point 3");
   	    }
   	    //printf("attempted");
    }

}
