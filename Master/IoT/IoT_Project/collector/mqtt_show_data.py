from database import Database
import tabulate
import time


def show_mqtt_data():

    db = Database()
    connection = db.connect_db()

    while(1):
        try:
            with connection.cursor() as new_cursor:
                sql = "SELECT * FROM `mqtt`"
                new_cursor.execute(sql)
                results = new_cursor.fetchall()
                header = results[0].keys()
                rows = [x.values() for x in results]
                print(tabulate.tabulate(rows, header, tablefmt='grid'))

            print("\n\n\n")
            print("----------------------------------------------------------------------------------------------------------")
            print("\n\n\n")
            time.sleep(5)
        except KeyboardInterrupt:
            break


if __name__ == '__main__':
    show_mqtt_data()