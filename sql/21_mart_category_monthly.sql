-- sql/21_mart_category_monthly.sql
-- Monthly mart category for visualisation (Tableau/Excel) and analysis (Python)


CREATE OR REPLACE VIEW analytics.mart_category_monthly AS
WITH base AS (
  SELECT
    date_trunc('month', o.order_purchase_timestamp)::date AS month,
    COALESCE(oi.product_category_english, oi.product_category_name, 'unknown') AS category,
    oi.order_id,
    oi.order_item_id,
    oi.price
  FROM raw.orders o
  JOIN analytics.int_order_items_enriched oi ON oi.order_id = o.order_id
)
SELECT
  month,
  category,
  COUNT(DISTINCT order_id) AS orders,
  COUNT(*) AS items_sold,
  SUM(price)::numeric(18,2) AS gmv,
  CASE WHEN COUNT(DISTINCT order_id) > 0
    THEN (SUM(price) / COUNT(DISTINCT order_id))::numeric(18,2)
    ELSE NULL
  END AS aov
FROM base
GROUP BY 1, 2
ORDER BY 1, 2;

-- QA data checks

SELECT * FROM analytics.mart_category_monthly ORDER BY month, gmv DESC LIMIT 20;