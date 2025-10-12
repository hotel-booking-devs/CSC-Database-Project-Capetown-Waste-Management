# Just install mysql connector to ur command: pip install mysql-connector-python
# Reference : https://www.youtube.com/watch?v=3kwVOPIK3Ps&t=7s 
#  author: Code&Query, title: "How to Connect Python with MySQL | Step by Step Tutorial | 2025"

import mysql.connector
# I just initialised the function to connect to the database
def connect_to_mysql():
    # I used the try and except method to catch any errors during the connection
    try: 
        connection = mysql.connector.connect(
            host = '127.0.0.1', # localhost for the mysql workbench
            user = 'root', # the username for the database workbench    
            password = 'kiddo_4326970_2025', # the password for the database workbench
            database = 'capetown_waste_management' # the database name
        )
        # Here i just check the connection is successful or not using the is_connected() method
        if connection.is_connected():
            # print wheather the connection is successful or not
            print("successfully connected to Mysql\n")
            
            cursor = connection.cursor()
            # create a list of tables to fetch data from the database
            tables = [
                "resident",
                "recycling_centre",
                "vehicle",
                "driver",
                "waste_type",
                "collection_log",
                "route",
                "driverrouteassignment"
            ]
            # loop through the tables list and fetch data from each table
            for table in tables:
                print()
                # print the table name
                # used the try and except method for errors 
                try:
                    # execute the query to fetch the data from table
                    # 
                    
                    cursor.execute(f"SELECT * FROM {table};")
                    
                    record = cursor.fetchall()
                    if not record:
                        print("not found/does not exist on the database")
                    else:
                        for i in record:
                            
                            print(f"{table} ", i)
                
                except mysql.connector.Error as err:
                    print(f"Error: {err}")

        join_query = """
        SELECT r.name AS Resident, d.name AS Driver, wt.name AS WasteType, cl.status
        FROM Collection_Log cl
        JOIN Resident r ON cl.resident_id = r.resident_id
        JOIN Driver d ON cl.driver_id = d.driver_id
        JOIN Waste_Type wt ON cl.waste_type_id = wt.waste_type_id

       """
        cursor.execute(join_query)
        joined_data =cursor.fetchall()
        if not joined_data :
            print("There is no joined data found")
        else:
           for i in joined_data:
              print(" ", i)
        print()

        cursor.close()
        # close the connection when the task is done
        connection.close

            
            
           
             
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    

# call the function to connect to the database
if __name__== '__main__':
    connect_to_mysql()

# let's do the pseudo code for the database connection
# def connect_to_mysql():
#     try:

    
   