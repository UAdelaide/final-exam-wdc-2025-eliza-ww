var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/api/dogs', function(req, res, next) {
  //
});

router.get('/api/walkrequests/open', function(req, res, next) {
  //
});

router.get('/api/walkers/summary', function(req, res, next) {
  //
});

// app.get('/', async (req, res) => {
//   try {
//     const [books] = await db.execute('SELECT * FROM books');
//     res.json(books);
//   } catch (err) {
//     res.status(500).json({ error: 'Failed to fetch books' });
//   }
// });


module.exports = router;
