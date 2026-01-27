-- sql/05_data_quality_checks.sql
-- Basic QA suite (run anytime)

-- RAW row counts
SELECT 'raw.customers' AS table_name, COUNT(*) AS row_count FROM raw.customers;
SELECT 'raw.geolocation' AS table_name, COUNT(*) AS row_count FROM raw.geolocation;
SELECT 'raw.orders' AS table_name, COUNT(*) AS row_count FROM raw.orders;
SELECT 'raw.order_items' AS table_name, COUNT(*) AS row_count FROM raw.order_items;
SELECT 'raw.order_payments' AS table_name, COUNT(*) AS row_count FROM raw.order_payments;
SELECT 'raw.order_reviews' AS table_name, COUNT(*) AS row_count FROM raw.order_reviews;
SELECT 'raw.products' AS table_name, COUNT(*) AS row_count FROM raw.products;
SELECT 'raw.sellers' AS table_name, COUNT(*) AS row_count FROM raw.sellers;
SELECT 'raw.category_translation' AS table_name, COUNT(*) AS row_count FROM raw.category_translation;

-- Key integrity checks (should be 0)
SELECT COUNT(*) AS orders_missing_customer
FROM raw.orders o
LEFT JOIN raw.customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS items_missing_order
FROM raw.order_items i
LEFT JOIN raw.orders o ON o.order_id = i.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS items_missing_product
FROM raw.order_items i
LEFT JOIN raw.products p ON p.product_id = i.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS items_missing_seller
FROM raw.order_items i
LEFT JOIN raw.sellers s ON s.seller_id = i.seller_id
WHERE s.seller_id IS NULL;

-- Enriched view sanity
SELECT 'analytics.int_orders_enriched' AS view_name, COUNT(*) AS row_count
FROM analytics.int_orders_enriched;

SELECT
  SUM(is_delivered) AS delivered_orders,
  AVG(delivery_days) AS avg_delivery_days,
  AVG(is_on_time) AS on_time_rate
FROM analytics.int_orders_enriched;

SELECT 'raw.customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL SELECT 'raw.orders', COUNT(*) FROM raw.orders
UNION ALL SELECT 'raw.order_items', COUNT(*) FROM raw.order_items;