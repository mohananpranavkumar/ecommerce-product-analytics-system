-- sql/23_mart_seller_monthly.sql
-- Monthly mart seller for visualisation (Tableau/Excel) and analysis (Python)


CREATE OR REPLACE VIEW analytics.mart_seller_monthly AS
WITH base AS (
  SELECT
    date_trunc('month', o.order_purchase_timestamp)::date AS month,
    oi.seller_id,
    COALESCE(oi.seller_state, 'unknown') AS seller_state,
    oi.order_id,
    oi.price,
    oi.freight_value
  FROM raw.orders o
  JOIN analytics.int_order_items_enriched oi
    ON oi.order_id = o.order_id
)
SELECT
  month,
  seller_id,
  seller_state,
  COUNT(DISTINCT order_id) AS orders,
  SUM(price)::numeric(18,2) AS gmv,
  AVG(freight_value)::numeric(18,2) AS avg_freight
FROM base
GROUP BY 1, 2, 3
ORDER BY 1, 5 DESC;

-- QA data checks

SELECT * FROM analytics.mart_seller_monthly ORDER BY month, gmv DESC LIMIT 20;