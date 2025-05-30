-----RAILWAY MANAGEMENT FUNCTION


--FUNCTION TO CHECK SEAT AVALABLITY

CREATE OR REPLACE FUNCTION CHECK_SEAT_AVALABLITY(P_TRAIN_ID NUMBER)
RETURN NUMBER
IS
V_SEATS_BOOKED NUMBER;
V_TOTAL_SEATS CONSTANT NUMBER := 100;

BEGIN

SELECT COUNT (*) INTO V_SEATS_BOOKED
FROM BOOKINGS 
WHERE train_id = P_TRAIN_ID
AND status = 'BOOKED';

RETURN V_TOTAL_SEATS - V_SEATS_BOOKED;
END;
/