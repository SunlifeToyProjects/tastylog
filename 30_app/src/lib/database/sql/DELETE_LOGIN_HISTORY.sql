DELETE FROM
  t_login_history
WHERE
  user_id = ?
  AND
  login <=
  (
    SELECT
      login
    FROM
      (
        SELECT
          login
        FROM
          t_login_history
        WHERE
          user_id = ?
        ORDER BY login DESC
        LIMIT 1 OFFSET ?
      ) AS tmp
  )
