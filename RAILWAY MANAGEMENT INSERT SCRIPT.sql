-----RAILWAY MANAGEMENT INSERT SCRIPT------------------------

-- Insert sample stations
INSERT INTO Stations VALUES (1, 'New Delhi');
INSERT INTO Stations VALUES (2, 'Mumbai');
INSERT INTO Stations VALUES (3, 'Chennai');
INSERT INTO Stations VALUES (4, 'Kolkata');

-- Insert sample trains
INSERT INTO Trains VALUES (101, 'Rajdhani Express', 1, 2);
INSERT INTO Trains VALUES (102, 'Chennai Express', 3, 2);

-- Insert sample passengers
INSERT INTO Passengers VALUES (1001, 'Rahul Sharma', 30, 'Male');
INSERT INTO Passengers VALUES (1002, 'Priya Sinha', 28, 'Female');

COMMIT;	