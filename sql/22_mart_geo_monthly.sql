-- sql/22_mart_geo_monthly.sql
-- Monthly mart geo for visualisation (Tableau/Excel) and analysis (Python)


CREATE OR REPLACE VIEW analytics.mart_geo_state_monthly AS
WITH orders AS (
  SELECT
    date_trunc('month', order_purchase_timestamp)::date AS month,
    order_id,
    customer_state,
    is_delivered,
    is_on_time
  FROM analytics.int_orders_enriched
),
gmv AS (
  SELECT
    date_trunc('month', o.order_purchase_timestamp)::date AS month,
    o.order_id,
    SUM(oi.price)::numeric(18,2) AS gmv
  FROM raw.orders o
  JOIN raw.order_items oi ON oi.order_id = o.order_id
  GROUP BY 1, 2
)
SELECT
  o.month,
  o.customer_state,
  COUNT(DISTINCT o.order_id) AS orders,
  SUM(o.is_delivered) AS delivered_orders,
  AVG(o.is_on_time)::numeric(10,4) AS on_time_rate,
  COALESCE(SUM(g.gmv),0)::numeric(18,2) AS gmv
FROM orders o
LEFT JOIN gmv g ON g.order_id = o.order_id AND g.month = o.month
GROUP BY 1, 2
ORDER BY 1, 2;

-- QA data checks

SELECT * FROM analytics.mart_geo_state_monthly ORDER BY month, gmv DESC LIMIT 20;