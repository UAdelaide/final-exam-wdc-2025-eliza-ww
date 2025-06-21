var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/api/dogs', function(req, res, next) {
  try {
      const [dogs] = await db.execute('SELECT name, size, username FROM Dogs JOIN Users ON Dogs.owner_id = Users.user_id');
      res.json(dogs);
  }

  catch (err) {
      res.status(500).json({ error: 'Failed to fetch users' });
  }
});

router.get('/api/walkrequests/open', function(req, res, next) {
  //
});

router.get('/api/walkers/summary', function(req, res, next) {
  //
});

module.exports = router;
