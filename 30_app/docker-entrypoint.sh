#! /bin/sh

if [ -n "${MYSQL_HOST}" ]; then
  node ./lib/database/wait.js
else
  echo "WARN: MYSQL_HOST is not defines."
fi

exec "$@"