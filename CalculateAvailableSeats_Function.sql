USE airline_db;
DELIMITER //

CREATE FUNCTION CalculateAvailableSeats(
    flightID INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE aircraftCapacity INT;
    DECLARE bookedPassengers INT;
    DECLARE availableSeats INT;

    -- Get the aircraft capacity for the flight
    SELECT a.Capacity INTO aircraftCapacity
    FROM airline_db.aircraft a
    JOIN airline_db.Flights f ON a.Aircraft_ID = f.Aircraft_ID
    WHERE f.Flight_ID = flightID;

    -- Get the number of booked passengers for the flight
    SELECT COUNT(*) INTO bookedPassengers
    FROM airline_db.Bookings b
    WHERE b.Flight_ID = flightID;

    -- Calculate the available seats
    SET availableSeats = aircraftCapacity - bookedPassengers;

    RETURN availableSeats;
END //

DELIMITER ;