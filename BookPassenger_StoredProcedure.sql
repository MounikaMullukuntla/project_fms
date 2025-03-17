USE airline_db;
DELIMITER //

CREATE PROCEDURE BookPassenger(
    IN customerID INT,
    IN flightID INT,
    IN seatNumber VARCHAR(5),
    OUT paymentStatus VARCHAR(250)
)
BEGIN
    DECLARE availableSeats INT;
    DECLARE customerExists INT;
    DECLARE flightExists INT;

    -- Check if customer and flight exists.
    SELECT COUNT(*) INTO customerExists FROM Customers WHERE Customer_ID = customerID;
    SELECT COUNT(*) INTO flightExists FROM Flights WHERE Flight_ID = flightID;

    IF customerExists = 0 THEN
        SET paymentStatus = 'Customer does not exist';
    ELSEIF flightExists = 0 THEN
        SET paymentStatus = 'Flight does not exist';
    ELSE
        -- Check if there are available seats
        SELECT CalculateAvailableSeats(flightID) INTO availableSeats;

        IF availableSeats > 0 THEN
            -- Check if seat is already booked.
            IF (SELECT COUNT(*) FROM Bookings WHERE Flight_ID = flightID AND Seat_Number = seatNumber) > 0 THEN
                SET paymentStatus = 'Seat already booked';
            ELSE
                -- Insert the new booking with 'Pending' payment status
                INSERT INTO Bookings (Customer_ID, Flight_ID, Seat_Number, Payment_Status)
                VALUES (customerID, flightID, seatNumber, 'Pending');
                SET paymentStatus = 'Booking pending payment';
            END IF;
        ELSE
            SET paymentStatus = 'No seats available';
        END IF;
    END IF;
END //

DELIMITER ;