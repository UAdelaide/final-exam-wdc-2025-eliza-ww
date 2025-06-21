-- Five users:
-- A user with the username alice123, email alice@example.com, password hash hashed123, and role owner.
-- A user with the username bobwalker, email bob@example.com, password hash hashed456, and role walker.
-- A user with the username carol123, email carol@example.com, password hash hashed789, and role owner.
-- Two more users with details of your choosing.

INSERT INTO Users (username, email, password_hash, role)
VALUES ("alice123", "alice@example.com", "hashed123", "owner"),
("bobwalker", "bob@example.com", "hashed456", "walker"),
("carol123", "carol@example.com", "hashed789", "owner"),
("orange", "youglad@example.com", "hashed000", "owner"),
("clementines", "clemmy@example.com", "hashed003", "walker");

-- Five dogs:
-- A dog named Max, who is medium-sized and owned by alice123.
-- A dog named Bella, who is small and owned by carol123.
-- Three more dogs with details of your choosing.

INSERT INTO Dogs (name, size, owner_id)
VALUES ("Max", "medium",
(SELECT user_id FROM Users WHERE username = "alice123")),
("Bella", "small",
(SELECT user_id FROM Users WHERE username = "carol123")),
("Spots", "large",
(SELECT user_id FROM Users WHERE username = "alice123")),
("Cerberus", "large",
(SELECT user_id FROM Users WHERE username = "orange")),
("Blue", "small",
(SELECT user_id FROM Users WHERE username = "alice123"));

-- Five walk requests:
-- A request for Max at 2025-06-10 08:00:00 for 30 minutes at Parklands, with status open.
-- A request for Bella at 2025-06-10 09:30:00 for 45 minutes at Beachside Ave, with status accepted.
-- Three more walk requests with details of your choosing.

INSERT INTO WalkRequests (dog_id, requested_time, duration_minutes, location, status)
VALUES ((SELECT dog_id FROM Dogs WHERE name = "Max"), "2025-06-10 08:00:00", 30, "Parklands", "open"),
((SELECT dog_id FROM Dogs WHERE name = "Bella"), "2025-06-10 09:30:00", 45, "Beachside Ave", "accepted"),
((SELECT dog_id FROM Dogs WHERE name = "Maple"), "2025-06-20 12:25:00", 30, "North Terrace", "open"),
((SELECT dog_id FROM Dogs WHERE name = "Maple"), "2025-06-20 12:25:00", 30, "North Terrace", "open"),
((SELECT dog_id FROM Dogs WHERE name = "Maple"), "2025-06-20 12:25:00", 30, "North Terrace", "open");