var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mysql = require('mysql2/promise');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

let db;

// borrowing code from \starthere
(async () => {
    try {
    // Connect to MySQL without specifying a database
    const connection = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '' // Set your MySQL root password
    });

    // Create the database if it doesn't exist
    await connection.query('CREATE DATABASE IF NOT EXISTS DogWalkService');
    await connection.end();

    // Now connect to the created database
    db = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'DogWalkService'
    });

    // creating tables
    await db.execute(`
        CREATE TABLE IF NOT EXISTS Users (
            user_id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            password_hash VARCHAR(255) NOT NULL,
            role ENUM('owner', 'walker') NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS Dogs (
            dog_id INT AUTO_INCREMENT PRIMARY KEY,
            owner_id INT NOT NULL,
            name VARCHAR(50) NOT NULL,
            size ENUM('small', 'medium', 'large') NOT NULL,
            FOREIGN KEY (owner_id) REFERENCES Users(user_id)
        );

        CREATE TABLE IF NOT EXISTS WalkRequests (
            request_id INT AUTO_INCREMENT PRIMARY KEY,
            dog_id INT NOT NULL,
            requested_time DATETIME NOT NULL,
            duration_minutes INT NOT NULL,
            location VARCHAR(255) NOT NULL,
            status ENUM('open', 'accepted', 'completed', 'cancelled') DEFAULT 'open',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (dog_id) REFERENCES Dogs(dog_id)
        );

        CREATE TABLE IF NOT EXISTS WalkApplications (
            application_id INT AUTO_INCREMENT PRIMARY KEY,
            request_id INT NOT NULL,
            walker_id INT NOT NULL,
            applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
            FOREIGN KEY (request_id) REFERENCES WalkRequests(request_id),
            FOREIGN KEY (walker_id) REFERENCES Users(user_id),
            CONSTRAINT unique_application UNIQUE (request_id, walker_id)
        );

        CREATE TABLE IF NOT EXISTS WalkRatings (
            rating_id INT AUTO_INCREMENT PRIMARY KEY,
            request_id INT NOT NULL,
            walker_id INT NOT NULL,
            owner_id INT NOT NULL,
            rating INT CHECK (rating BETWEEN 1 AND 5),
            comments TEXT,
            rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (request_id) REFERENCES WalkRequests(request_id),
            FOREIGN KEY (walker_id) REFERENCES Users(user_id),
            FOREIGN KEY (owner_id) REFERENCES Users(user_id),
            CONSTRAINT unique_rating_per_walk UNIQUE (request_id)
        );
    `);

    // inserting data if table is empty
    const [userCount] = await db.execute('SELECT COUNT(*) AS count FROM Users');

    if (userCount[0].count === 0) {
        await db.execute(`
            INSERT INTO Users (username, email, password_hash, role)
            VALUES ("alice123", "alice@example.com", "hashed123", "owner"),
            ("bobwalker", "bob@example.com", "hashed456", "walker"),
            ("carol123", "carol@example.com", "hashed789", "owner"),
            ("eliza", "eliza@example.com", "hashed699", "owner"),
            ("gregoryHouseMD", "drHouse@example.com", "itslupus", "walker");
        `);
    }

    const [dogCount] = await db.execute('SELECT COUNT(*) AS count FROM Dogs');

    if (dogCount[0].count === 0) {
        await db.execute(`
            INSERT INTO Dogs (name, size, owner_id)
            VALUES ("Max", "medium",
            (SELECT user_id FROM Users WHERE username = "alice123")),
            ("Bella", "small",
            (SELECT user_id FROM Users WHERE username = "carol123")),
            ("Maple", "medium",
            (SELECT user_id FROM Users WHERE username = "eliza"));
        `);
    }

    const [walkCount] = await db.execute('SELECT COUNT(*) AS count FROM WalkRequests');

    if (walkCount[0].count === 0) {
        await db.execute(`
            INSERT INTO WalkRequests (dog_id, requested_time, duration_minutes, location, status)
            VALUES ((SELECT dog_id FROM Dogs WHERE name = "Max"), "2025-06-10 08:00:00", 30, "Parklands", "open"),
            ((SELECT dog_id FROM Dogs WHERE name = "Bella"), "2025-06-10 09:30:00", 45, "Beachside Ave", "accepted"),
            ((SELECT dog_id FROM Dogs WHERE name = "Maple"), "2025-06-20 12:25:00", 30, "North Terrace", "open");
        `);
    }
    }

    catch (err) {
        console.error('Error starting database', err);
    }
})();

// Route to return books as JSON
app.get('/', async (req, res) => {
    try {
        const [dogs] = await db.execute('SELECT * FROM Dogs');
        res.json(dogs);
    }

    catch (err) {
        res.status(500).json({ error: 'Failed to fetch data' });
    }
});

app.use('/', indexRouter);
app.use('/users', usersRouter);

module.exports = app;
