#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "contiki.h"
#include "coap-engine.h"
#include "sys/node-id.h"
#include "random.h"

#include "global_variables.h"

#include "sys/log.h"

#define LOG_MODULE "ac-temperature-sensor"
#define LOG_LEVEL LOG_LEVEL_APP

//API FUNCTION DEFINITIONS
static void temperature_get_handler(coap_message_t *request, coap_message_t *response, uint8_t *buffer, uint16_t preferred_size, int32_t *offset);
static void temperature_event_handler(void);


//RESOURCE DEFINITION
EVENT_RESOURCE(res_temperature_sensor,
	"title=\"Temperature Sensor\";obs",
	temperature_get_handler,
	NULL,
	NULL,
	NULL,
	temperature_event_handler);

static int default_temperature = 30; //Default enviroment temperature
static int temperature = 30; //Starting temperature 

// Function used to simulate the env temperature with ac ON/OFF 
static void simulate_temperature_values () {
    int variation = 0;
	
	// If the AC is on  -> the temperature decrease/increase while it's not equal to ac_temperature 
	// If the AC is off -> the temperature decrease/increase while it's not equal to the env default temperature (default_temperature)
	if(ac_on) { 
	    if (temperature > ac_temperature) { variation = 1; }
		else if (temperature < ac_temperature) { variation = -1; }  

	    temperature = temperature - variation;

	} 
	else {
		if (temperature < default_temperature) { variation = 1; }
		else if (temperature > default_temperature) { variation = -1; }

		temperature = temperature + variation;
    }
}


// Simulates the temperature value and notifies the observers of the new temperature in the enviroment
static void temperature_event_handler(void) {
	simulate_temperature_values();
	LOG_INFO("temperature : %d ----------- ac_temperature: %d \n", temperature, ac_temperature);
    coap_notify_observers(&res_temperature_sensor);
}

// Function called when there is a GET request or used by the sensor for the notify function 
static void temperature_get_handler(coap_message_t *request, coap_message_t *response, uint8_t *buffer, uint16_t preferred_size, int32_t *offset){

	//Prepare the msg to send 
	snprintf((char *)buffer, COAP_MAX_CHUNK_SIZE, "{\"node\": %d, \"temp\": %d, \"time\": %lu, \"ac_temp\": %d}", node_id, temperature, clock_seconds(), ac_temperature);
	
	//Set the header and the payload of the msg
	coap_set_header_content_format(response, APPLICATION_JSON);
	coap_set_payload(response, buffer, strlen((char *)buffer));

}


