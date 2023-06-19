from coap_collector import *
from mqtt_collector import *

import threading
import os

# Unspecified IPv6 address
ip = "::"
port = 5683


def application_logic():

    mqtt_instance = MQTT_collector()
    mqtt_thread = threading.Thread(target=mqtt_instance.mqtt_client, args=(), kwargs={})
    mqtt_thread.deamon = True
    mqtt_thread.start()

    coap_instance = CoAP_collector(ip, port)
    coap_thread = threading.Thread(target=coap_instance.listen, args=([100]), kwargs={})
    coap_thread.deamon = True
    coap_thread.start()

    check_mqtt_connection = False
    check_coap_connection = False

    print("Waiting for MQTT and COAP connection!\n")


    try:
        while(not(check_mqtt_connection) or not(check_coap_connection)):
            if (mqtt_instance.check_connection() == 1 and not(check_mqtt_connection)):
                check_mqtt_connection = True
                print("MQTT connection estabilished")
            
            if (coap_instance.check_connection() == 1 and not(check_coap_connection)):
                check_coap_connection = True
                print("COAP connection estabilished")
    except KeyboardInterrupt:
        mqtt_instance.stop_loop()
        coap_instance.close()
        print("\n\nSHUTDOWN")
        os._exit(0)



    

    while(1):
        print("------------------ COMMANDS AVAILABLE ------------------\n")
        print("Energy Management:")
        print("1. Get the energy consumed right now")
        print("2. Get which led is activate right now and the reason why")
        print("")
        print("Air Conditioning Management")
        print("5. Get the enviroment temperature right now")
        print("6. Activate the air conditioner")
        print("7. Deactivate the air conditioner")
        print("8. Get which led is activate right now and the reason why")
        print("9. Change the air conditioner temperature")
        print("")
        print("0. EXIT")
        print("")
        print("--------------------------------------------------------\n")


        
        try:
            # CHECK THE OPTION 
            text = int(input("Insert your choice: "))
            print("")
            if(text == 1): 
                print("The energy_consumption in this moment is: " + str(mqtt_instance.get_energy_consumption()) + " Watt\n")
            elif(text == 2):
                print(mqtt_instance.get_activated_led())
            elif(text == 5):
                print("The temperature in this moment is: " + str(coap_instance.get_env_temperature()) + "°C\n")
            elif(text == 6):
                if (coap_instance.activate_ac()):
                    print("Operation done! \n")
                else:
                    print("\nCoAP connection has been lost, restarting the application\n")
                    print("-------------------------------------------------------------\n")
                    return 100
            elif(text == 7):
                if(coap_instance.deactivate_ac()):
                    print("Operation done! \n")
                else:
                    print("\nCoAP connection has been lost, restarting the application\n")
                    print("-------------------------------------------------------------\n")
                    return 100
            elif(text == 8):
                print(coap_instance.get_activated_led())
            elif(text == 9):
                value = input("Insert ac value [>= 16 and <= 32]: ")
                if(value.isdigit()):
                    if (int(value)>=16 and int(value)<=32):
                        if(coap_instance.change_ac_temperature(value)):
                            print("Operation done! \n")
                        else:
                            print("\nCoAP connection has been lost, restarting the application\n")
                            print("-------------------------------------------------------------\n")
                            return 100
                    else:
                        print("Operation cannot be done, the inserted value is not in the correct interval!")
                else:
                    print("Operation cannot be done, the inserted value is not a number!")
            elif(text == 0):
                break

            else:
                continue

            # ASK IF THE USER WANTS TO CONTINUE OR STOP 
            text_2 = ""
            
            while((text_2.lower() != "yes") and (text_2.lower() != "no")):
                text_2 = input("Do you want to continue? [YES/NO]: ")

            if (text_2.lower() == "yes"):
                continue
            elif (text_2.lower() == "no"):
                break
            
            print("")

        except KeyboardInterrupt:
            break
        except ValueError:
            print("")
            continue

    print("\n")

    quit_text = ""

    while(quit_text.lower() != "quit"):
        try:
            print("The collector is still working in background, if you want to close it, write 'quit' and press enter")
            quit_text = input()
        except KeyboardInterrupt:
            break
        
    mqtt_instance.stop_loop()
    coap_instance.close()
    
    print("\n\nSHUTDOWN")

    os._exit(0)


if __name__ == '__main__':
    app_status = 100
    while(app_status == 100):
        app_status = application_logic()
