-- sql/20_mart_kpi_monthly.sql
-- KPI marts for visualisation (Tableau/Excel) and analysis (Python)


CREATE OR REPLACE VIEW analytics.mart_kpi_monthly AS
WITH orders_base AS (
  SELECT
    date_trunc('month', o.order_purchase_timestamp)::date AS month,
    o.order_id,
    c.customer_unique_id,
    o.order_status,
    CASE WHEN o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL THEN 1 ELSE 0 END AS is_delivered,
    CASE
      WHEN o.order_status = 'delivered'
       AND o.order_delivered_customer_date IS NOT NULL
       AND o.order_estimated_delivery_date IS NOT NULL
       AND o.order_delivered_customer_date <= o.order_estimated_delivery_date
      THEN 1 ELSE 0
    END AS is_on_time,
    o.order_purchase_timestamp
  FROM raw.orders o
  JOIN raw.customers c ON c.customer_id = o.customer_id
),
first_purchase AS (
  SELECT
    customer_unique_id,
    MIN(order_purchase_timestamp) AS first_purchase_ts
  FROM orders_base
  GROUP BY 1
),
repeat_flags AS (
  SELECT
    ob.month,
    ob.order_id,
    CASE WHEN ob.order_purchase_timestamp > fp.first_purchase_ts THEN 1 ELSE 0 END AS is_repeat_order
  FROM orders_base ob
  JOIN first_purchase fp USING (customer_unique_id)
),
gmv_by_order AS (
  SELECT
    date_trunc('month', o.order_purchase_timestamp)::date AS month,
    oi.order_id,
    SUM(oi.price)::numeric(18,2) AS gmv
  FROM raw.orders o
  JOIN raw.order_items oi ON oi.order_id = o.order_id
  GROUP BY 1, 2
),
review_by_order AS (
  SELECT
    date_trunc('month', o.order_purchase_timestamp)::date AS month,
    r.order_id,
    AVG(r.review_score)::numeric(10,2) AS avg_review_score
  FROM raw.orders o
  JOIN raw.order_reviews r ON r.order_id = o.order_id
  GROUP BY 1, 2
)
SELECT
  ob.month,

  COUNT(DISTINCT ob.order_id) AS orders,
  SUM(ob.is_delivered) AS delivered_orders,

  COALESCE(SUM(g.gmv), 0)::numeric(18,2) AS gmv,
  CASE WHEN COUNT(DISTINCT ob.order_id) > 0
    THEN (COALESCE(SUM(g.gmv),0) / COUNT(DISTINCT ob.order_id))::numeric(18,2)
    ELSE NULL
  END AS aov,

  AVG(ob.is_on_time)::numeric(10,4) AS on_time_rate,
  AVG(rv.avg_review_score)::numeric(10,2) AS avg_review_score,
  AVG(rf.is_repeat_order)::numeric(10,4) AS repeat_rate

FROM orders_base ob
LEFT JOIN gmv_by_order g ON g.order_id = ob.order_id AND g.month = ob.month
LEFT JOIN review_by_order rv ON rv.order_id = ob.order_id AND rv.month = ob.month
LEFT JOIN repeat_flags rf ON rf.order_id = ob.order_id AND rf.month = ob.month
GROUP BY ob.month
ORDER BY ob.month;

-- QA data checks

SELECT * FROM analytics.mart_kpi_monthly ORDER BY month LIMIT 12;
