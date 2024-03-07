const router = require("express").Router();
const { MySQLClient, sql } = require("../lib/database/client.js");
const moment = require("moment");
const tokens = new (require("csrf"))();
const DATE_FORMAT = "YYYY/MM/DD";

var validateReviewData = function (req) {
  var body = req.body;
  var isValid = true, error = {};

  if (body.visit && !moment(body.visit, DATE_FORMAT).isValid()) {
    isValid = false;
    error.visit = "訪問日の日付文字列が不正です。";
  }

  if (isValid) {
    return undefined;
  }
  return error;
};

var createReviewData = function (req) {
  var body = req.body, date;

  return {
    shopId: req.params.shopId,
    score: parseFloat(body.score),
    visit: (date = moment(body.visit, DATE_FORMAT)) && date.isValid() ? date.toDate() : null,
    post: new Date(),
    description: body.description
  };
};

router.get("/regist/:shopId(\\d+)", async (req, res, next) => {
  var shopId = req.params.shopId;
  var secret, token, shop, shopName, review, results;

  secret = await tokens.secret();
  token = tokens.create(secret);
  req.session._csrf = secret;

  try {
    results = await MySQLClient.executeQuery(
      await sql("SELECT_SHOP_BASIC_BY_ID"),
      [shopId]
    );
    shop = results[0] || {};
    shopName = shop.name;
    review = {};
    res.render("./account/reviews/regist-form.ejs", { shopId, shopName, review, token });
  } catch (err) {
    next(err);
  }
});

router.post("/regist/:shopId(\\d+)", (req, res, next) => {
  var review = createReviewData(req);
  var { shopId, shopName, token } = req.body;
  res.render("./account/reviews/regist-form.ejs", { shopId, shopName, review, token });
});

router.post("/regist/confirm", (req, res, next) => {
  var error = validateReviewData(req);
  var review = createReviewData(req);
  var { shopId, shopName, token } = req.body;

  if (error) {
    res.render("./account/reviews/regist-form.ejs", { error, shopId, shopName, review, token });
    return;
  }

  res.render("./account/reviews/regist-confirm.ejs", { shopId, shopName, review, token });
});

router.post("/regist/execute", async (req, res, next) => {
  var secret = req.session._csrf;
  var { token } = req.body;

  if (tokens.verify(secret, token) === false) {
    next(new Error("Invalid Token."));
    return;
  }

  var error = validateReviewData(req);
  var review = createReviewData(req);
  var { shopId, shopName } = req.body;
  var userId = req.user.id;
  var transaction;

  if (error) {
    res.render("./account/reviews/regist-form.ejs", { error, shopId, shopName, review });
    return;
  }

  try {
    transaction = await MySQLClient.beginTransaction();
    transaction.executeQuery(
      await sql("SELECT_SHOP_BY_ID_FOR_UPDATE"),
      [shopId]
    );
    transaction.executeQuery(
      await sql("INSERT_SHOP_REVIEW"),
      [shopId, userId, review.score, review.visit, review.description]
    );
    transaction.executeQuery(
      await sql("UPDATE_SHOP_SCORE_BY_ID"),
      [shopId, shopId]
    );
    await transaction.commit();
  } catch (err) {
    await transaction.rollback();
    next(err);
    return;
  }

  delete req.session._csrf;

  res.redirect(`/account/reviews/regist/complete?shopId=${shopId}`);
});

router.get("/regist/complete", (req, res) => {
  res.render("./account/reviews/regist-complete.ejs", { shopId: req.query.shopId });
});

module.exports = router;