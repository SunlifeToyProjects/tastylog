SELECT
  shop_category.id,
  shop_category.name,
  shop_category.post_code,
  shop_category.address,
  shop_category.tel,
  shop_category.holiday,
  shop_category.seats,
  shop_category.price_range,
  shop_category.score,
  shop_category.geolocation_latitude,
  shop_category.geolocation_longitude,
  GROUP_CONCAT(m_category.name separator ', ') as categories
FROM
(
  SELECT
    *
  FROM
    (
      SELECT * FROM t_shop WHERE id = ?
    ) as shop
  LEFT JOIN t_shop_category ON shop.id = t_shop_category.shop_id
) as shop_category
LEFT JOIN m_category ON shop_category.category_id = m_category.id
GROUP BY shop_category.id
