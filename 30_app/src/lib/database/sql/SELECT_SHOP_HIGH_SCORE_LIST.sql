SELECT
  shop_category.id,
  shop_category.name,
  shop_category.post_code,
  shop_category.address,
  shop_category.tel,
  shop_category.holiday,
  shop_category.seats,
  shop_category.score,
  GROUP_CONCAT(m_category.name separator ', ') as categories
FROM
(
  SELECT
    *
  FROM
    (
      SELECT * FROM t_shop ORDER BY score DESC LIMIT ?
    ) as shop
  LEFT JOIN t_shop_category ON shop.id = t_shop_category.shop_id
) as shop_category
LEFT JOIN m_category ON shop_category.category_id = m_category.id
GROUP BY shop_category.id
ORDER BY score DESC