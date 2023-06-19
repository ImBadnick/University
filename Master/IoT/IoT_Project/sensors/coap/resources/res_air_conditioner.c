#include <stdlib.h>
#include <string.h>
#include "contiki.h"
#include "coap-engine.h"
#include "os/dev/leds.h"

#include "sys/log.h"

/* Log configuration */
#define LOG_MODULE "ac-control"
#define LOG_LEVEL LOG_LEVEL_APP


static void ac_put_handler(coap_message_t *request, coap_message_t *response, uint8_t *buffer, uint16_t preferred_size, int32_t *offset);

RESOURCE(res_ac_system,
         "title=\"AC System\";rt=\"Control\"",
         NULL,
		 NULL,
         ac_put_handler,
         NULL);



//sets the AC ON/OFF -> default off 
bool ac_on = false;

//sets the default working temperature for the AC
int ac_temperature = 22;


//change the AC status (ON/OFF) based on a CoAP request from the collector
static bool change_ac_status(int len, const char* status) {

    if(strncmp(status, "ON", len) == 0) {
		if (!ac_on){
			ac_on = true;
			LOG_INFO("AC system ON\n");
		} 
	} 
	else if(strncmp(status, "OFF", len) == 0) {
		if (ac_on){
			ac_on = false;
			LOG_INFO("AC System OFF\n");
		} 
	} 
	else {
		return false; // return false = Error
	}

    return true;
}

//change the AC working temperature based on a CoAP request from the collector
static bool change_ac_temp(int len, const char* temp) {
    int set_temperature = atoi(temp);

	if (set_temperature >= 16 && set_temperature<=32){
	    ac_temperature = set_temperature;
		LOG_INFO("Changed AC temperature to %d \n", ac_temperature);
		return true;
    } 
	else{ 
		return false; 
	}

}

//checks if the CoAP request from the collector wants to set the AC working temperature
//or change the status of the AC
static void ac_put_handler(coap_message_t *request, coap_message_t *response, uint8_t *buffer, uint16_t preferred_size, int32_t *offset) {
	size_t len = 0;
	const char *text = NULL;

    bool response_status = false;

	if ((len = coap_get_post_variable(request, "ac_status", &text))) { //If the requests is a PUT command with ac_status variable
		response_status = change_ac_status(len, text);
	} 
	else if ((len = coap_get_post_variable(request, "ac_temp", &text))){
		response_status = change_ac_temp(len, text);
	}

	if (!response_status) {
		coap_set_status_code(response, BAD_REQUEST_4_00);
	}
}


//manual on-off with the sensor button 
void manual_handler() {
    ac_on = !ac_on;

    if (ac_on) {
        LOG_INFO("AC is ON \n");
    } else {
        LOG_INFO("AC is OFF\n");
    }
}