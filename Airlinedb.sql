CREATE DATABASE airline_db;
USE airline_db;

CREATE TABLE Aircraft (
    Aircraft_ID INT AUTO_INCREMENT PRIMARY KEY,
    Aircraft_Type VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    Manufacturer VARCHAR(50),
    Maintenance_Status ENUM('Operational', 'Under Maintenance') NOT NULL,
    Last_Maintenance_Date DATE
);

CREATE TABLE Routes (
    Route_ID INT AUTO_INCREMENT PRIMARY KEY,
    Origin_Airport VARCHAR(50) NOT NULL,
    Destination_Airport VARCHAR(50) NOT NULL,
    Distance DECIMAL(6,2),
    Flight_Duration TIME
);

CREATE TABLE Flights (
    Flight_ID INT AUTO_INCREMENT PRIMARY KEY,
    Flight_Number VARCHAR(10) UNIQUE NOT NULL,
    Departure_Airport VARCHAR(50) NOT NULL,
    Arrival_Airport VARCHAR(50) NOT NULL,
    Departure_Time DATETIME NOT NULL,
    Arrival_Time DATETIME NOT NULL,
    Aircraft_ID INT NOT NULL,
    Status ENUM('On-time', 'Delayed', 'Cancelled'),
    Route_ID INT NOT NULL,
    FOREIGN KEY (Aircraft_ID) REFERENCES Aircraft(Aircraft_ID),
    FOREIGN KEY (Route_ID) REFERENCES Routes(Route_ID)
);

CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Contact_Number VARCHAR(15),
    Address TEXT,
    Passport_Number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Bookings (
    Booking_ID INT AUTO_INCREMENT PRIMARY KEY,
    Flight_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Seat_Class ENUM('Economy', 'Business', 'First Class'),
    Seat_Number VARCHAR(5),
    Booking_Date DATETIME,
    Payment_Status ENUM('Pending', 'Paid', 'Cancelled'),
    Total_Price DECIMAL(10,2),
    FOREIGN KEY (Flight_ID) REFERENCES Flights(Flight_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

CREATE TABLE Employees (
    Employee_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Role VARCHAR(50),
    Department VARCHAR(50),
    Contact_Details VARCHAR(100),
    Shift_Start TIME,
    Shift_End TIME
);

CREATE TABLE Flight_Attendants (
    Flight_Attendant_ID INT AUTO_INCREMENT PRIMARY KEY,
    Employee_ID INT NOT NULL,
    Assigned_Flight_ID INT NOT NULL,
    Role VARCHAR(50),
    Shift_Start TIME,
    Shift_End TIME,
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID),
    FOREIGN KEY (Assigned_Flight_ID) REFERENCES Flights(Flight_ID)
);

CREATE TABLE Suppliers (
    Supplier_ID INT AUTO_INCREMENT PRIMARY KEY,
    Supplier_Name VARCHAR(100) NOT NULL,
    Contact_Details VARCHAR(100),
    Product_Type VARCHAR(50)
);

CREATE TABLE Supply_Chain_Inventory (
    Supply_ID INT AUTO_INCREMENT PRIMARY KEY,
    Item_Name VARCHAR(100) NOT NULL,
    Item_Description VARCHAR(100),
    Quantity_In_Stock INT,
    Reorder_Level INT,
    Supplier_ID INT NOT NULL,
    FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(Supplier_ID)
);

CREATE TABLE Maintenance (
    Maintenance_ID INT AUTO_INCREMENT PRIMARY KEY,
    Aircraft_ID INT NOT NULL,
    Maintenance_Type ENUM('Routine', 'Repair'),
    Maintenance_Date DATE,
    Next_Maintenance_Due DATE,
    Technician_ID INT NOT NULL,
    FOREIGN KEY (Aircraft_ID) REFERENCES Aircraft(Aircraft_ID),
    FOREIGN KEY (Technician_ID) REFERENCES Employees(Employee_ID) -- Or a separate Technicians table
);

ALTER TABLE flights
MODIFY COLUMN Route_ID INT  NULL;

UPDATE flights f
INNER JOIN routes r ON f.Departure_Airport = r.Origin_Airport AND f.Arrival_Airport = r.Destination_Airport
SET f.Route_ID = r.Route_ID;

ALTER TABLE flights
MODIFY COLUMN Route_ID INT NOT NULL;

SELECT * FROM airline_db.aircraft;
SELECT * FROM airline_db.bookings;
SELECT * FROM airline_db.customers;
SELECT * FROM airline_db.employees;
SELECT * FROM airline_db.flight_attendants;
SELECT * FROM airline_db.flights;
SELECT * FROM airline_db.maintenance;
SELECT * FROM airline_db.routes;
SELECT * FROM airline_db.suppliers;
SELECT * FROM airline_db.supply_chain_inventory;
