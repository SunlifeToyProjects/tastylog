module.exports = {
  PORT: process.env.PORT || 3000,
  security: {
    SESSION_SECRET: process.env.SESSION_SECRET || "YOUR-SESSION-SECRET-STRING",
    ACCOUNT_LOCK_WINDOW: 30,
    ACCOUNT_LOCK_THRESHOLD: 5,
    ACCOUNT_LOCK_TIME: 60,
    MAX_LOGIN_HISTORY: 20
  },
  search: {
    MAX_ITEMS_PER_PAGE: 5
  },
  google: {
    API_KEY: "AIzaSyD3hHjfdmp_2nktWTLQ_h7Nkrb8Esample"
  }
};