#include "contiki.h"
#include "coap-engine.h"
#include "dev/leds.h"

#include <string.h>

/* Log configuration */
#include "sys/log.h"
#define LOG_MODULE "ac-leds"
#define LOG_LEVEL LOG_LEVEL_APP

static void res_put_handler(coap_message_t *request, coap_message_t *response, uint8_t *buffer, uint16_t preferred_size, int32_t *offset);

/* A simple actuator example, depending on the color query parameter and post variable mode, corresponding led is activated or deactivated */
RESOURCE(res_leds,
         "title=\"LEDs: PUT temp_status=equal_to_conditioner|not_equal_to_conditioner\";rt=\"Control\"",
         NULL,
         NULL,
         res_put_handler,
         NULL);


int color = 2; // 0 = RED, 1 = GREEN, 2 = NO LED

static void res_put_handler(coap_message_t *request, coap_message_t *response, uint8_t *buffer, uint16_t preferred_size, int32_t *offset){

  size_t len = 0;
  const char *temp_status = NULL;

  if((len = coap_get_post_variable(request, "temp_status", &temp_status))) { //Checks if the put request has the temp_status variable
    if(strncmp(temp_status, "equal_to_conditioner", len) == 0) {
         if (color != 1){
            leds_off(LEDS_RED);
            leds_on(LEDS_GREEN);
            
            LOG_INFO("temp_status = equal_to_conditioner ---> Turning on the green led! \n");
            color = 1;
         }
    } 
    else if(strncmp(temp_status, "not_equal_to_conditioner", len) == 0) {
        if (color != 0){
            leds_off(LEDS_GREEN);
            leds_on(LEDS_RED);
            LOG_INFO("temp_status != equal_to_conditioner ---> Turning on the red led! \n");
            color = 0;
         } 
    }
  } 
  else{
    coap_set_status_code(response, BAD_REQUEST_4_00);
  }
}
