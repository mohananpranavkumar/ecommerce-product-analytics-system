-- sql/11_int_order_items_enriched.sql
-- Order-level enriched view (reusable base for KPI marts)

CREATE OR REPLACE VIEW analytics.int_order_items_enriched AS
SELECT
  i.order_id,
  i.order_item_id,
  i.product_id,
  i.seller_id,
  i.shipping_limit_date,
  i.price,
  i.freight_value,

  p.product_category_name,
  ct.product_category_name_english AS product_category_english,

  s.seller_zip_code_prefix,
  s.seller_city,
  s.seller_state
FROM raw.order_items i
LEFT JOIN raw.products p
  ON p.product_id = i.product_id
LEFT JOIN raw.category_translation ct
  ON ct.product_category_name = p.product_category_name
LEFT JOIN raw.sellers s
  ON s.seller_id = i.seller_id;

-- QA data checks

SELECT COUNT(*) FROM analytics.int_order_items_enriched;
