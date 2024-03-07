UPDATE
  t_shop
SET
  score = (
    SELECT round(avg(score), 2) FROM t_review WHERE shop_id = ?
  )
WHERE
  id = ?
