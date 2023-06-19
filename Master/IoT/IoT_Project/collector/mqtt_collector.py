import paho.mqtt.client as mqtt
import json
from database import Database
from datetime import date


class MQTT_collector:

    def __init__(self):
        
        self.flag_connected = 0 # Used to check if the mqtt client is connected 

        # Values extracted from the mqtt msgs 
        self.node_id = 0
        self.energy_consumption = 0
        self.timestamp = 0
        self.sound_alarm_status = 0

    def mqtt_client(self):
        # Connection to the database
        self.db = Database()
        self.connection = self.db.connect_db()

        # Delete all the records before the new session 
        with self.connection.cursor() as cursor:
            cursor.execute("DELETE FROM mqtt")
            cursor.execute("DELETE FROM coap")
            cursor.execute("ALTER TABLE mqtt AUTO_INCREMENT = 1")
            cursor.execute("ALTER TABLE coap AUTO_INCREMENT = 1")
        self.connection.commit()

        # Create the mqtt client 
        self.client = mqtt.Client()

        # When connected call the "on_connect" function which subscribes to the "energy-consumption" topic
        self.client.on_connect = self.on_connect
        # When disconnected the client sets the relative flag to 0
        self.client.on_disconnect = self.on_disconnect
        # When recives a message calls the "on_message" function
        self.client.on_message = self.on_message

        # Tries to connect to the broker
        try:
            self.client.connect("127.0.0.1", 1883, 60)
        except Exception as e:
            print(str(e))
            self.flag_connected = 0


        # Starts the loop 
        self.client.loop_start()


    # Function called by the mqtt client when the connection is established 
    def on_connect(self, client, userdata, flags, rc):
        #print("connected with code: " + str(rc))
        self.client.subscribe("energy-consumption")
        self.flag_connected = 1

    def on_disconnect(client, userdata, rc):
        self.flag_connected = 0


    # Function called by the mqtt client when it recevies a new message
    def on_message(self,client,userdata,msg):
        
        # Get json file from the payload of the msg 
        data = json.loads(msg.payload)

        # Extract the data from the json 
        self.node_id = int(data["node"])
        self.energy_consumption = int(data["energy_consumption"])
        self.timestamp = int(data["timestamp"])
        if (int(data["sound_alarm_on"])):
            self.sound_alarm_status = "ON"
        else:
            self.sound_alarm_status = "OFF"
            
        # Publish the msg in the "led" topic to manage the leds of the sensor 
        if self.energy_consumption < 3000:
            self.client.publish("led","low")
        else:
            self.client.publish("led","high")
        
        # Save data on the DB
        with self.connection.cursor() as cursor:
            sql = "INSERT INTO `mqtt` (`node_id`, `energy_consumption` , `timestamp`, `sound_alarm_status` ) VALUES (%s, %s, %s, %s)"
            cursor.execute(sql, (self.node_id, self.energy_consumption, self.timestamp, self.sound_alarm_status))

        self.connection.commit()


    # Used to stop the MQTT loop
    def stop_loop(self):
        self.client.loop_stop()



    def get_energy_consumption(self):
        return self.energy_consumption

    def get_activated_led(self):
        if self.energy_consumption < 3000:
            return "The led activated is the green one 'cause the energy_consumption is below 3000 Watt\n"
        else:
            return "The led activated is the red one 'cause the energy_consumption is greater then 3000 Watt\n"

    def check_connection(self):
        return self.flag_connected