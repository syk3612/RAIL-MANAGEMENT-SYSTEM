-- ************
-- Test Cases for Railway Management System
-- ************

-- Enable DBMS Output
SET SERVEROUTPUT ON;

-- ========================================
-- 1. Insert Sample Data
-- ========================================

-- Insert Stations
INSERT INTO Stations VALUES (5, 'Pune');
INSERT INTO Stations VALUES (6, 'Bangalore');

-- Insert Trains
INSERT INTO Trains VALUES (103, 'Deccan Queen', 5, 1); -- Pune to New Delhi
INSERT INTO Trains VALUES (104, 'Bangalore Express', 6, 2); -- Bangalore to Mumbai

-- Insert Passengers
INSERT INTO Passengers VALUES (1003, 'Amit Verma', 45, 'Male');
INSERT INTO Passengers VALUES (1004, 'Sonia Mehra', 35, 'Female');
INSERT INTO Passengers VALUES (1005, 'Vikram Rao', 50, 'Male');

COMMIT;

-- ========================================
-- 2. Book Ticket Successfully (Available Seats)
-- ========================================

BEGIN
    book_ticket(1003, 103); -- Amit Verma booking Deccan Queen
END;
/

-- ========================================
-- 3. Book Multiple Tickets Until Full
-- ========================================

DECLARE
    v_passenger_id NUMBER := 2000;
BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO Passengers VALUES (v_passenger_id, 'Test Passenger ' || i, 30, 'Male');
        COMMIT;
        
        -- Try booking ticket
        book_ticket(v_passenger_id, 103);
        
        v_passenger_id := v_passenger_id + 1;
    END LOOP;
END;
/

-- Now book an extra passenger to go into Waitlist
INSERT INTO Passengers VALUES (3001, 'New Passenger', 29, 'Female');
COMMIT;

BEGIN
    book_ticket(3001, 103); -- Should go to waitlist
END;
/

-- ========================================
-- 4. Check Bookings and Waitlist
-- ========================================

-- Check total bookings (should be 100)
SELECT COUNT(*) AS booked_count
FROM Bookings
WHERE train_id = 103
  AND status = 'Booked';

-- Check waitlist entries (should be at least 1)
SELECT p.name, w.waitlist_position
FROM Waitlist w
JOIN Passengers p ON w.passenger_id = p.passenger_id
WHERE w.train_id = 103;

-- ========================================
-- 5. Cancel a Booking and Move Waitlisted Passenger
-- ========================================

-- Find a booking_id to cancel
SELECT booking_id
FROM Bookings
WHERE train_id = 103
  AND status = 'Booked'
FETCH FIRST 1 ROWS ONLY;

-- Suppose booking_id is 1 (Replace with your actual booking_id)

BEGIN
    cancel_ticket(1);
END;
/

-- ========================================
-- 6. Cancel a Ticket When No Waitlist
-- ========================================

BEGIN
    book_ticket(1004, 104); -- Sonia Mehra books Bangalore Express
END;
/

-- Find her booking_id
SELECT booking_id
FROM Bookings
WHERE passenger_id = 1004;

-- Suppose booking_id is 2 (replace with correct one)

BEGIN
    cancel_ticket(2);
END;
/

-- ========================================
-- 7. Test Booking Expiry After Departure
-- ========================================

-- Simulate departure of Deccan Queen
INSERT INTO Train_Schedule VALUES (1, 103, 5, SYSTIMESTAMP - INTERVAL '1' DAY, SYSTIMESTAMP - INTERVAL '1' DAY);
COMMIT;

-- Check expired bookings
SELECT * 
FROM Bookings
WHERE status = 'Expired';

-- ************
-- END OF TEST CASES
-- ************