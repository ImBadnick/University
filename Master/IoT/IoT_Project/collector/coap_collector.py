from coapthon.server.coap import CoAP
from coapthon.resources.resource import Resource
from coapthon.client.helperclient import HelperClient
from coapthon.messages.request import Request
from coapthon.messages.response import Response
from coapthon import defines

from database import Database

import json
from json import JSONDecodeError
import os

# -------------------------------------------- COAP COLLECTOR CLASS -------------------------------------------- #
#  Class created from the main application to:                                                                   #
#  1) Add the "registry" resource that will be used for the connection with the sensor                           #
#  2) Get actuators commands from the application and forward them to the MoteResource that will apply them.     #
#----------------------------------------------------------------------------------------------------------------#

class CoAP_collector(CoAP):
    def __init__(self, host, port):
        CoAP.__init__(self, (host, port), False)
        self.adv_resource = AdvancedResource()
        self.add_resource("registry", self.adv_resource)

    def get_env_temperature(self):
        mote_resource = self.adv_resource.get_mote_resource()
        return mote_resource.get_env_temperature()

    def activate_ac(self):
        mote_resource = self.adv_resource.get_mote_resource()
        request_status = mote_resource.activate_ac()
        return request_status

    def deactivate_ac(self):
        mote_resource = self.adv_resource.get_mote_resource()
        request_status = mote_resource.deactivate_ac()
        return request_status

    def get_activated_led(self):
        mote_resource = self.adv_resource.get_mote_resource()
        return (mote_resource.get_activated_led())
       

    def change_ac_temperature(self, value):
        mote_resource = self.adv_resource.get_mote_resource()
        request_status = mote_resource.change_ac_temperature(value)
        return request_status


    # Used to check the connection with the CoAP client
    def check_connection(self):
        if (self.adv_resource.get_mote_resource() != None):
            return 1
        else:
            return 0


# ---------------------------------------- AdvancedResource Class ---------------------------------------- #
#  When the coap sensor calls a GET request on this resource using the "registry" name, it will create a   #
#  MoteResource that will be used to interact with the sensor, collecting data from it or acting on it.    #
#----------------------------------------------------------------------------------------------------------#

class AdvancedResource(Resource):
    def __init__(self, name="Advanced"):
        super(AdvancedResource, self).__init__(name)
        self.payload = "Advanced resource"
        self.moteResource = None

    def render_GET_advanced(self, request, response):
        response.payload = self.payload
        response.max_age = 20
        response.code = defines.Codes.CONTENT.number
        self.moteResource = MoteResource(request.source)

    def get_mote_resource(self):
        return self.moteResource


# ---------------------------------------- MoteResource Class ---------------------------------------- #
#  This class is used to interact with the sensor, observing from it and acting on it.                 #
#  Its also used to interact with the database to store the data observed from the sensor.             #
#------------------------------------------------------------------------------------------------------#

class MoteResource:

    # When the registry has been done and the MoteResource is created 
    def __init__(self,source_address):
        #Connect to db 
        self.db = Database()
        self.connection = self.db.connect_db()

        # Name of the resources 
        self.actuator_led_resource = "res_leds"
        self.actuator_ac_resource = "res_air_conditioner"
        self.resource = "res_temperature_sensor"

        # Address of resource
        self.address = source_address
        
        # Values observed from resource 
        self.node_id = 0
        self.temperature = 0
        self.timestamp = 0
        self.ac_temperature = 0

        # Start observing from the resource 
        self.start_observing()


    # Execute the query to save the data (got from observing the resource) on the db 
    def execute_query(self):
        # Create a new record
        with self.connection.cursor() as cursor:
            sql = "INSERT INTO `coap` (`node_id`, `temperature`, `timestamp`, `ac_temperature`) VALUES (%s, %s, %s, %s)"
            cursor.execute(sql, (self.node_id, self.temperature, self.timestamp, self.ac_temperature))
        
        #Commit the query and show the results 
        self.connection.commit()

    # Function called when the resource notifies of a new value 
    def observer(self, response):    
        if response.payload is not None:
            # Get the data from the payload in json format 
            node_data = json.loads(response.payload)
            if not node_data["temp"]:
                print("empty")
                return
            
            # Extract the data from the json file 
            self.node_id = int(node_data["node"])
            self.temperature = int(node_data["temp"])
            self.timestamp = int(node_data["time"])
            self.ac_temperature = int(node_data["ac_temp"])

            # Check if the temperature is equal to the air conditioner temperature to actuate on sensor's leds 
            if self.temperature == self.ac_temperature:
                response = self.client.put(self.actuator_led_resource, "temp_status=equal_to_conditioner")
            elif self.temperature != self.ac_temperature:
                response = self.client.put(self.actuator_led_resource, "temp_status=not_equal_to_conditioner")
            else:
                print("Led API error")

            # Execute the query to store the values in the DB
            self.execute_query()
        


    # Function used to start the observing procedure (the "client" functionality of the COAP server)
    def start_observing(self):
        # Instanciate a new coap client 
        self.client = HelperClient(self.address) 
        # Start observing 
        self.client.observe(self.resource, self.observer)

    def get_env_temperature(self):
        return self.temperature
    
    # Function used to activate the air conditioner by the application
    def activate_ac(self):
        if ((os.system("ping -c 1 " + self.address[0] + " > /dev/null")) == 0): # Check if the sensor is reachible
            response = self.client.put(self.actuator_ac_resource, "ac_status=ON")
            return True
        else:
            return False

    # Function used to deactivate the air conditioner by the application
    def deactivate_ac(self):
        if ((os.system("ping -c 1 " + self.address[0] + " > /dev/null")) == 0):  # Check if the sensor is reachible
            response = self.client.put(self.actuator_ac_resource, "ac_status=OFF")
            return True
        else:
            return False

    def get_activated_led(self):
        if self.temperature == self.ac_temperature:
            return "The led activated is the GREEN one 'cause the temperature of the env is equal to the temperature of the air conditioner\n"
        elif self.temperature != self.ac_temperature:
            return "The led activated is the RED one 'cause the temperature of the env is not equal to the temperature of the air conditioner\n"

    # Function used to change the air conditioner temperature by the application
    def change_ac_temperature(self,value):
        if ((os.system("ping -c 1 " + self.address[0] + " > /dev/null")) == 0):  # Check if the sensor is reachible
            response = self.client.put(self.actuator_ac_resource, "ac_temp=" + value)
            return True
        else:
            return False

    