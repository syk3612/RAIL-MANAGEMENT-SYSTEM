-----RAILWAY MANAGEMENT PROCEDURE BOOK TICKET


-- PROCEDURE TO BOOK A TICKET

CREATE OR REPLACE PROCEDURE BOOK_TICKET(P_PASSENGER_ID IN NUMBER,
                                        P_TRAIN_ID IN NUMBER)IS
            
V_AVAILABLE_SEATS NUMBER;
V_SEAT_NUMBER NUMBER;

BEGIN

V_AVAILABLE_SEATS := CHECK_SEAT_AVALABLITY(P_TRAIN_ID);

IF V_AVAILABLE_SEATS > 0 THEN

V_SEAT_NUMBER := 100 - V_AVAILABLE_SEATS + 1;

INSERT INTO BOOKINGS(booking_id,passenger_id,TRAIN_ID,BOOKING_DATE,SEAT_NUMBER,STATUS)
VALUES(booking_seq.nextval,P_PASSENGER_ID,P_TRAIN_ID,SYSDATE,V_SEAT_NUMBER,'BOOKED');

DBMS_OUTPUT.PUT_LINE('TICKET BOOKED SUCCESSFULLY! SEAT NUMBER: ' || V_SEAT_NUMBER);

ELSE

INSERT INTO WAITLIST(WAITLIST_ID, PASSENGER_ID,Train_Id,REQUEST_DATE,WAITLIST_POSITION)
VALUES(waitlist_seq.nextval,P_PASSENGER_ID,P_TRAIN_ID,SYSDATE,
(SELECT NVL(MAX(WAITLIST_POSITION),0) + 1 FROM WAITLIST WHERE TRAIN_ID = P_TRAIN_ID));

DBMS_OUTPUT.PUT_LINE('NO SEATS AVAILABLE ADDED TO WAITLIST.');

END IF;

END;
                                    
                                     
-----RAILWAY MANAGEMENT PROCEDURE CANCEL TICKET


--- PROCEDURE TO CANCEL A TICKET AND CONFIRM THE TICKET OF PASSANGER WHO IS IN WAITLIST

CREATE OR REPLACE PROCEDURE CANCEL_TKT(P_BOOKING_ID IN NUMBER)IS

V_TRAIN_ID NUMBER;
V_SEAT_NUMBER NUMBER;
V_WAITLIST_PASSENGER NUMBER;
V_WAITLIST_ID NUMBER;

BEGIN

SELECT TRAIN_ID, SEAT_NUMBER INTO V_TRAIN_ID,V_SEAT_NUMBER
FROM BOOKINGS
WHERE booking_id = P_BOOKING_ID
AND status = 'BOOKED';

UPDATE BOOKINGS
SET status = 'CANCELLED'
WHERE booking_id = P_BOOKING_ID;

SELECT PASSENGER_ID, WAITLIST_ID INTO V_WAITLIST_PASSENGER,V_WAITLIST_ID
FROM(SELECT PASSENGER_ID, WAITLIST_ID
FROM WAITLIST 
WHERE TRAIN_ID = V_TRAIN_ID
ORDER BY WAITLIST_POSITION)
WHERE ROWNUM = 1;

INSERT INTO BOOKINGS(BOOKING_ID,PASSENGER_ID,TRAIN_ID,BOOKING_DATE,SEAT_NUMBER,STATUS)
VALUES(booking_seq.nextval,V_WAITLIST_PASSENGER,V_TRAIN_ID,SYSDATE,V_SEAT_NUMBER,'BOOKED');

DELETE FROM waitlist WHERE WAITLIST_ID = V_WAITLIST_ID;

DBMS_OUTPUT.PUT_LINE('TICKET CANCELLED AND WAITLISTED PASSENGER BOOKED SUCCESSFULLY');

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('TICKET CANCELLED, NO WAITLISTED PASSENGER.');

END;