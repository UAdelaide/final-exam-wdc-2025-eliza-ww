var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mysql = require('mysql2/promise');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

let db = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'DogWalkService'
});

// Return a list of all dogs with their size and owner's username.

app.get('/api/dogs', async (req, res) => {
    try {
        const [dogs] = await db.execute('SELECT name, size, username FROM Dogs JOIN Users ON Dogs.owner_id = Users.user_id');
        res.json(dogs);
    }

    catch (err) {
        res.status(500).json({ error: 'Failed to fetch users' });
    }
});

// Return all open walk requests
// including the dog name, requested time, location, and owner's username.

app.get('/api/walkrequests/open', async (req, res) => {
    try {
        const [requests] = await db.execute('SELECT request_id, Dogs.name AS dog_name, WalkRequests.requested_time, WalkRequests.duration_minutes, location, username AS owner_username FROM WalkRequests JOIN Dogs ON Dogs.dog_id = WalkRequests.dog_id JOIN Users ON Users.user_id = Dogs.owner_id WHERE status = "open";');
        res.json(requests);
    }

    catch (err) {
        res.status(500).json({ error: 'Failed to fetch walk requests' });
    }
});

// Return a summary of each walker with their average rating
// and number of completed walks.

app.get('/api/walkers/summary', async (req, res) => {
    try {
        const [walkers] = await db.execute('SELECT username AS walker_username, COUNT(username) AS total_ratings, AVG(rating) AS average_rating, COUNT(username) AS completed_walks FROM WalkRatings JOIN Users ON WalkRatings.walker_id = Users.user_id GROUP BY username;');
        res.json(walkers);
    }

    catch (err) {
        res.status(500).json({ error: 'Failed to fetch walkers' });
    }
});

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

module.exports = app;
