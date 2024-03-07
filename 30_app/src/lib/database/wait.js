const { HOST, USERNAME, PASSWORD, DATABASE, PORT } = require("../../config/mysql.config.js");
const mysql = require("mysql2");
const WAIT = 1000;

const con = mysql.createConnection({
  host: HOST,
  port: PORT,
  user: USERNAME,
  password: PASSWORD,
  database: DATABASE
});

var tryConnect = function () {
  console.log(`Try to connect ... ${USERNAME}@${HOST}:${PORT} ...`);
  global.setTimeout(() => {
    con.query("SELECT 1 FROM dual", (err, results, fields) => {
      if (err) {
        console.log(err.message);
        tryConnect();
      } else {
        con.end();
      }
    });
  }, WAIT);
};

tryConnect();

