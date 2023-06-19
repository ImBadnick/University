#ifndef PROJECT_CONF_H_
#define PROJECT_CONF_H_

// Set the max response payload before enable fragmentation:
#undef REST_MAX_CHUNK_SIZE
#define REST_MAX_CHUNK_SIZE 64
// Set the maximum number of CoAP concurrent transactions:
#undef COAP_MAX_OPEN_TRANSACTIONS
#define COAP_MAX_OPEN_TRANSACTIONS 4

/* Save some memory for the sky platform. */
#undef NBR_TABLE_CONF_MAX_NEIGHBORS
#define NBR_TABLE_CONF_MAX_NEIGHBORS 10

#undef UIP_CONF_MAX_ROUTES
#define UIP_CONF_MAX_ROUTES 10

#undef UIP_CONF_BUFFER_SIZE
#define UIP_CONF_BUFFER_SIZE 240

#define LOG_LEVEL_APP LOG_LEVEL_DBG

#endif /* PROJECT_CONF_H_ */
