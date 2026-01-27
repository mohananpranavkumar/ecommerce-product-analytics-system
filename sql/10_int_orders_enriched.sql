-- sql/10_int_orders_enriched.sql
-- Order-level enriched view (reusable base for KPI marts)

CREATE OR REPLACE VIEW analytics.int_orders_enriched AS
SELECT
  o.order_id,
  o.customer_id,
  c.customer_unique_id,
  c.customer_zip_code_prefix,
  c.customer_city,
  c.customer_state,

  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,

  CASE
    WHEN o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
      THEN 1 ELSE 0
  END AS is_delivered,

  CASE
    WHEN o.order_status = 'delivered'
     AND o.order_delivered_customer_date IS NOT NULL
     AND o.order_estimated_delivery_date IS NOT NULL
     AND o.order_delivered_customer_date <= o.order_estimated_delivery_date
      THEN 1 ELSE 0
  END AS is_on_time,

  CASE
    WHEN o.order_status = 'delivered'
     AND o.order_delivered_customer_date IS NOT NULL
     AND o.order_estimated_delivery_date IS NOT NULL
     AND o.order_delivered_customer_date > o.order_estimated_delivery_date
      THEN 1 ELSE 0
  END AS is_late,

  CASE
    WHEN o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
      THEN EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400.0
    ELSE NULL
  END AS delivery_days
FROM raw.orders o
JOIN raw.customers c
  ON c.customer_id = o.customer_id;