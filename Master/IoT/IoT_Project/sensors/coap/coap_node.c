#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "contiki.h"
#include "coap-engine.h"
#include "sys/etimer.h"
#include "os/dev/leds.h"
#include "coap-blocking-api.h"
#include "os/dev/button-hal.h"
#include "node-id.h"
#include "net/ipv6/simple-udp.h"
#include "net/ipv6/uip.h"
#include "net/ipv6/uip-ds6.h"
#include "net/ipv6/uip-debug.h"
#include "routing/routing.h"
#include "global_variables.h"
#include "sys/log.h"

//Address of the observing python collector
#define SERVER "coap://[fd00::1]:5683"

// Log configuration
#define LOG_MODULE "ac-system"
#define LOG_LEVEL LOG_LEVEL_APP

//Simulation interval between sensor measurements
#define SIMULATION_INTERVAL 5

//Interval for connection retries with the border router
#define CONNECTION_TEST_INTERVAL 2

//Registration status
static bool registered = false;

//Timer for simulations of sensor measurements
static struct etimer simulation_timer;

//Timer for connection retries with the border router
static struct etimer connectivity_timer;


// Test the connectivity with the border router
static bool is_connected() {
	if(NETSTACK_ROUTING.node_is_reachable()) {
		LOG_INFO("The Border Router is reachable\n");
		return true;
  } else {
		LOG_INFO("Waiting for connection with the Border Router\n");
	}
	return false;
}

void client_chunk_handler(coap_message_t *response) {
	const uint8_t *chunk;
	
	if(response == NULL) {
		LOG_INFO("Request timed out\n");
		return;
	}

	int len = coap_get_payload(response, &chunk);

	registered = true;
	
	LOG_INFO("|%.*s \n", len, (char *)chunk);
}

//Declare the two protothreads: one for the sensing subsystem,
//the other for handling leds blinking
PROCESS(air_conditioning_server, "Air Conditioning Server");
AUTOSTART_PROCESSES(&air_conditioning_server);


//Coap Resources for the AC (actuator), LEDS (actuator) and the temperature sensor (sensor)
extern coap_resource_t res_ac_system;
extern coap_resource_t res_temperature_sensor;
extern coap_resource_t res_leds;

PROCESS_THREAD(air_conditioning_server, ev, data){
	PROCESS_BEGIN();

	LOG_INFO("Starting air conditioning CoAP server\n");
	coap_activate_resource(&res_ac_system, "res_air_conditioner");
	coap_activate_resource(&res_temperature_sensor, "res_temperature_sensor");
	coap_activate_resource(&res_leds, "res_leds");


	// try to connect to the border router
	etimer_set(&connectivity_timer, CLOCK_SECOND * CONNECTION_TEST_INTERVAL);
	PROCESS_WAIT_UNTIL(etimer_expired(&connectivity_timer));
	while(!is_connected()) {
		etimer_reset(&connectivity_timer);
		PROCESS_WAIT_UNTIL(etimer_expired(&connectivity_timer));
	}

	static coap_endpoint_t server;
    static coap_message_t request[1];

	LOG_INFO("Sending registration message\n");
	//Server address parse into "server" variable
    coap_endpoint_parse(SERVER, strlen(SERVER), &server);
	//Prepare coap message for the coap server to the "registry" resource exposed by the server and wait for the response 
	coap_init_message(request, COAP_TYPE_CON, COAP_GET, 0);  
	coap_set_header_uri_path(request, "registry");
	COAP_BLOCKING_REQUEST(&server, request, client_chunk_handler);

	//Sends the coap message while the server doesnt reply and there is a "connection"
	while(!registered){
    LOG_DBG("Retrying with server\n");
    COAP_BLOCKING_REQUEST(&server, request, client_chunk_handler);
  	}

	printf("--Registred--\n");

	//periodic simulation of sensor measurements
	etimer_set(&simulation_timer, CLOCK_SECOND * SIMULATION_INTERVAL);
	while(1) {
		PROCESS_WAIT_EVENT();
		if((ev == PROCESS_EVENT_TIMER && data == &simulation_timer) || ev == button_hal_press_event) {
			if(ev == button_hal_press_event){
				button_hal_button_t* btn = (button_hal_button_t*)data;
				if (btn->unique_id == BOARD_BUTTON_HAL_INDEX_KEY_LEFT) {
					//let the actuator resource handle the button
					manual_handler();
				}
			}
			LOG_INFO("--> ");
			res_temperature_sensor.trigger();
			etimer_set(&simulation_timer, CLOCK_SECOND * SIMULATION_INTERVAL);
		}
	}

	PROCESS_END();
}
