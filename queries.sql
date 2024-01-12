use littlelemondb;

CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, TotalCost AS Cost
FROM Orders
WHERE Quantity > 2;

SELECT
    C.CustomerID,
    C.CustomerName as FullName,
    O.OrderID,
    O.TotalCost AS Cost,
    M.ItemName AS MenuName,
    MI.CourseName,
    MI.StarterName
FROM CustomerDetails C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Menu M ON O.OrderID = M.ItemID
JOIN MenuItems MI ON M.ItemID = MI.MenuID
WHERE O.TotalCost > 150
ORDER BY O.TotalCost;

SELECT
    ItemName AS MenuName
FROM Menu
WHERE ItemID = ANY (
    SELECT MenuID
    FROM Orders
    GROUP BY MenuID
    HAVING COUNT(*) > 2
);
INSERT INTO CustomerDetails (CustomerName, ContactDetails)
VALUES
    ('John Doe', '123-456-7890'),
    ('Jane Smith', '987-654-3210'),
    ('Alice Johnson', '555-123-4567'),
    ('Bob Williams', '777-888-9999');
INSERT INTO Bookings (BookingID, Date, TableNumber, CustomerID)
VALUES
    (1, '2022-10-10', 5, 1),
    (2, '2022-11-12', 3, 3),
    (3, '2022-10-11', 2, 2),
    (4, '2022-10-13', 2, 1);
  
  DELIMITER //
CREATE PROCEDURE CheckBooking (
    IN p_BookingDate DATE,
    IN p_TableNumber INT,
    OUT v_Status VARCHAR(255)
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Bookings
        WHERE Date = p_BookingDate AND TableNumber = p_TableNumber
    ) THEN
        SET v_Status = 'Table is booked.';
    ELSE
        SET v_Status = 'Table is available for booking.';
    END IF;
END //
DELIMITER ;

CALL CheckBooking('2022-10-10', 5, @Status);

SELECT @Status;

DELIMITER //
CREATE PROCEDURE AddValidBooking (
    IN p_BookingDate DATE,
    IN p_TableNumber INT
)
BEGIN
    DECLARE v_TableCount INT;

    -- Start the transaction
    START TRANSACTION;

    -- Insert a new booking record
    INSERT INTO Bookings (Date, TableNumber, CustomerID)
    VALUES (p_BookingDate, p_TableNumber, 1); -- Assuming CustomerID 1 for this example

    -- Check if the table is already booked on the given date
    SELECT COUNT(*)
    INTO v_TableCount
    FROM Bookings
    WHERE Date = p_BookingDate AND TableNumber = p_TableNumber;

    -- If the table is already booked, rollback the transaction
    IF v_TableCount > 1 THEN
        ROLLBACK;
        SELECT 'Booking declined. The table is already booked.' AS Message;
    ELSE
        -- If the table is available, commit the transaction
        COMMIT;
        SELECT 'Booking successful.' AS Message;
    END IF;
END //
DELIMITER ;

CALL AddValidBooking('2022-10-10', 5);

DELIMITER //
CREATE PROCEDURE AddBooking (
    IN p_BookingID INT,
    IN p_CustomerID INT,
    IN p_BookingDate DATE,
    IN p_TableNumber INT
)
BEGIN
    -- Insert a new booking record
    INSERT INTO Bookings (BookingID, Date, TableNumber, CustomerID)
    VALUES (p_BookingID, p_BookingDate, p_TableNumber, p_CustomerID);
    
    -- You can add additional logic or checks here if needed

    -- Display a message indicating the successful booking
    SELECT 'Booking successful.' AS Message;
END //
DELIMITER ;

CALL AddBooking(5, 1, '2022-10-10', 5);

DELIMITER //
CREATE PROCEDURE UpdateBooking (
    IN p_BookingID INT,
    IN p_BookingDate DATE
)
BEGIN
    -- Update the booking date for the specified booking ID
    UPDATE Bookings
    SET Date = p_BookingDate
    WHERE BookingID = p_BookingID;
    
    -- You can add additional logic or checks here if needed

    -- Display a message indicating the successful update
    SELECT 'Booking updated successfully.' AS Message;
END //
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE CancelBooking (
   in p_BookingID INT)
   
BEGIN

    DECLARE v_CustomerID INT;
    SELECT CustomerID INTO v_CustomerID
    FROM Bookings
    WHERE BookingID = p_BookingID;

    
    DELETE FROM Bookings
    WHERE BookingID = p_BookingID;

    
    SELECT CONCAT('Booking for CustomerID ', v_CustomerID, ' has been canceled.') AS Message;
END //
DELIMITER ;

CALL CancelBooking(1);

