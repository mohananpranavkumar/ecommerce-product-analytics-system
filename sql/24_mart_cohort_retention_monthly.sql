-- sql/24_mart_cohort_retention_monthly.sql
-- Monthly mart cohort retention for visualisation (Tableau/Excel) and analysis (Python)


CREATE OR REPLACE VIEW analytics.mart_cohort_retention AS
WITH orders AS (
  SELECT
    customer_unique_id,
    date_trunc('month', order_purchase_timestamp)::date AS order_month
  FROM analytics.int_orders_enriched
),
cohort AS (
  SELECT
    customer_unique_id,
    MIN(order_month) AS cohort_month
  FROM orders
  GROUP BY 1
),
activity AS (
  SELECT
    c.cohort_month,
    o.order_month,
    (EXTRACT(YEAR FROM o.order_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12
      + (EXTRACT(MONTH FROM o.order_month) - EXTRACT(MONTH FROM c.cohort_month)) AS month_number,
    COUNT(DISTINCT o.customer_unique_id) AS active_customers
  FROM orders o
  JOIN cohort c USING (customer_unique_id)
  GROUP BY 1, 2, 3
),
cohort_size AS (
  SELECT cohort_month, COUNT(DISTINCT customer_unique_id) AS cohort_customers
  FROM cohort
  GROUP BY 1
)
SELECT
  a.cohort_month,
  a.order_month,
  a.month_number,
  cs.cohort_customers,
  a.active_customers,
  CASE WHEN cs.cohort_customers > 0
    THEN (a.active_customers::numeric / cs.cohort_customers)::numeric(10,4)
    ELSE NULL
  END AS retention_rate
FROM activity a
JOIN cohort_size cs USING (cohort_month)
ORDER BY cohort_month, month_number;

-- QA data checks

SELECT * FROM analytics.mart_cohort_retention ORDER BY cohort_month, month_number LIMIT 30;