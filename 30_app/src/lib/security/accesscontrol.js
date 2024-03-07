const {
  ACCOUNT_LOCK_WINDOW,
  ACCOUNT_LOCK_THRESHOLD,
  ACCOUNT_LOCK_TIME,
  MAX_LOGIN_HISTORY
} = require("../../config/application.config.js").security;
const moment = require("moment");
const bcrypt = require("bcrypt");
const passport = require("passport");
const LocalStrategy = require("passport-local").Strategy;
const { MySQLClient, sql } = require("../database/client.js");
const PRIVILEGE = {
  NORMAL: "normal"
};
const LOGIN_STATUS = {
  SUCCESS: 0,
  FAILURE: 1
};
var initialize, authenticate, authorize;

passport.serializeUser((user, done) => {
  done(null, user);
});

passport.deserializeUser((user, done) => {
  done(null, user);
});

passport.use(
  "local-strategy",
  new LocalStrategy({
    usernameField: "username",
    passwordField: "password",
    passReqToCallback: true
  }, async (req, username, password, done) => {
    var transaction, results, user, count;
    var now = new Date();

    try {
      transaction = await MySQLClient.beginTransaction();

      // Get user info
      results = await transaction.executeQuery(
        await sql("SELECT_USER_BY_EMAIL_FOR_UPDATE"),
        [username]
      );
      if (results.length !== 1) {
        transaction.commit();
        return done(null, false, req.flash("message", "ユーザー名 または パスワードが間違っています"));
      }
      user = {
        id: results[0].id,
        name: results[0].name,
        email: results[0].email,
        permissions: [PRIVILEGE.NORMAL]
      };

      // Check account lock status
      if (results[0].locked &&
        moment(now).isSameOrBefore(
          moment(results[0].locked).add(ACCOUNT_LOCK_TIME, "minutes")
        )) {
        transaction.commit();
        return done(null, false, req.flash("message", "アカウントがロックされています"));
      }

      // Delete old login log
      await transaction.executeQuery(
        await sql("DELETE_LOGIN_HISTORY"),
        [user.id, user.id, MAX_LOGIN_HISTORY - 1]
      );

      // Compare password
      if (!await bcrypt.compare(password, results[0].password)) {
        // Insert login history
        await transaction.executeQuery(
          await sql("INSERT_LOGIN_HISTORY"),
          [user.id, now, LOGIN_STATUS.FAILURE]
        );

        // Lock account, if need
        let tmp = await transaction.executeQuery(
          await sql("COUNT_LOGIN_HISTORY"),
          [
            user.id,
            moment(now).subtract(ACCOUNT_LOCK_WINDOW, "minutes").toDate(),
            LOGIN_STATUS.FAILURE
          ]
        );
        count = (tmp || [])[0].count;
        if (count >= ACCOUNT_LOCK_THRESHOLD) {
          await transaction.executeQuery(
            await sql("UPDATE_USER_LOCKED"),
            [now, user.id]
          );
        }

        transaction.commit();
        return done(null, false, req.flash("message", "ユーザー名 または パスワードが間違っています"));
      }

      // Insert login history
      await transaction.executeQuery(
        await sql("INSERT_LOGIN_HISTORY"),
        [user.id, now, LOGIN_STATUS.SUCCESS]
      );

      // Unlock account
      await transaction.executeQuery(
        await sql("UPDATE_USER_LOCKED"),
        [null, user.id]
      );

      transaction.commit();
    } catch (err) {
      transaction.rollback();
      return done(err);
    }

    // Session regenerate
    req.session.regenerate((err) => {
      if (err) {
        done(err);
      } else {
        done(null, user);   // -> authenticate() -> serializeUser()
      }
    });
  })
);

initialize = function () {
  return [
    passport.initialize(),
    passport.session(),
    function (req, res, next) {
      if (req.user) {
        res.locals.user = req.user;
      }
      next();
    }
  ];
};

authenticate = function () {
  return passport.authenticate(
    "local-strategy",
    {
      successRedirect: "/account",
      failureRedirect: "/account/login"
    }
  );
};

authorize = function (privilege) {
  return function (req, res, next) {
    if (req.isAuthenticated() &&
      (req.user.permissions || []).indexOf(privilege) >= 0) {
      next();
    } else {
      res.redirect("/account/login");
    }
  };
};

module.exports = {
  initialize,
  authenticate,
  authorize,
  PRIVILEGE
};