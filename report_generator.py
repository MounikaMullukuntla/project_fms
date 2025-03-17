import mysql.connector

# Database connection details
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'NutBars@1129$',
    'database': 'airline_db'
}

try:
    # Establish a connection to the MySQL database
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    # SQL query to retrieve data
    query = """
        SELECT f.Flight_Number, f.Departure_Airport, f.Arrival_Airport, f.Departure_Time, a.Aircraft_Type
        FROM Flights f
        JOIN Aircraft a ON f.Aircraft_ID = a.Aircraft_ID
        WHERE f.Departure_Time > NOW()  # Example: Flights departing in the future
    """

    # Execute the query
    cursor.execute(query)

    # Fetch all the results
    results = cursor.fetchall()

    # Generate the report
    report = "Flight Report\n"
    report += "-" * 80 + "\n"
    report += "{:<15} {:<20} {:<20} {:<25} {:<15}\n".format("Flight Number", "Departure Airport", "Arrival Airport", "Departure Time", "Aircraft Type")
    report += "-" * 80 + "\n"

    # Format and add data to the report
    for row in results:
        report += "{:<15} {:<20} {:<20} {:<25} {:<15}\n".format(row[0], row[1], row[2], str(row[3]), row[4])

    # Print the report to the console
    print(report)

    # Write the report to a text file
    with open("flight_report.txt", "w") as file:
        file.write(report)

    print("\nReport generated successfully and saved to flight_report.txt")

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and connection
    if connection and connection.is_connected():
        cursor.close()
        connection.close()