var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mysql = require('mysql2/promise');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

let db; // connection pool for DogWalkService

let db = 

(async () => {
    try {
        console.log("connecting");

        db = await mysql.createConnection({
            host: 'localhost',
            user: 'root',
            password: '',
            database: 'testdb'
        });

        console.log("connected");
    }

    catch (err) {
        console.error('Error setting up database', err);
    }
})();

app.get('/', async (req, res) => {
    try {
        const [user] = await db.execute('SELECT * FROM Dogs');
        res.json(user);
    }

    catch (err) {
        res.status(500).json({ error: 'Failed to fetch users' });
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
