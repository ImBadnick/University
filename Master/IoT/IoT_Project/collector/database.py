import pymysql.cursors


class Database:
    connection = None

    def connect_db(self):
        if self.connection is not None:
            return self.connection
        else:
            self.connection = pymysql.connect(host="localhost",
                                              user='iotproject',
                                              password="iotproject",
                                              database="collector",
                                              cursorclass=pymysql.cursors.DictCursor)
            return self.connection
