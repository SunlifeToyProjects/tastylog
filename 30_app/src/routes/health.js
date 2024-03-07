var router = require("express").Router();
var { MySqlClient } = require("../lib/database/client.js");

router.get("/", async (req, res) => {
  var ap = true;
  var db = false;

  try {
    await MySqlClient.executeQuery("SELECT 1");
    db = true;
  } catch (err) {
    db = false;
  }

  res.status(ap && db ? 200 : 503);
  res.render("./health/index.ejs", { ap, db });
});

module.exports = router;