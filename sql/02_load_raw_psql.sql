
---

### 2) Add the runnable script
✅ `sql/02_load_raw_psql.sql` (this is what you “run”; it won’t contain pgAdmin text)

Create/overwrite with:

```sql
-- sql/02_load_raw_psql.sql
-- Load CSVs using psql \copy (reads files from your machine)
-- Run: psql -U postgres -d ecommerce_analytics -f sql/02_load_raw_psql.sql

\set ON_ERROR_STOP on
SET client_encoding TO 'UTF8';

-- CHANGE THIS to your local repo path:
\set data_path 'C:/Users/Pranav Kumar Mohanan/Downloads/ecommerce-product-analytics-system/ecommerce-product-analytics-system/data'

\copy raw.customers FROM :'data_path'/olist_customers_dataset.csv CSV HEADER;
\copy raw.geolocation FROM :'data_path'/olist_geolocation_dataset.csv CSV HEADER;
\copy raw.orders FROM :'data_path'/olist_orders_dataset.csv CSV HEADER;
\copy raw.order_items FROM :'data_path'/olist_order_items_dataset.csv CSV HEADER;
\copy raw.order_payments FROM :'data_path'/olist_order_payments_dataset.csv CSV HEADER;
\copy raw.order_reviews FROM :'data_path'/olist_order_reviews_dataset.csv CSV HEADER;
\copy raw.products FROM :'data_path'/olist_products_dataset.csv CSV HEADER;
\copy raw.sellers FROM :'data_path'/olist_sellers_dataset.csv CSV HEADER;
\copy raw.category_translation FROM :'data_path'/product_category_name_translation.csv CSV HEADER;

-- QA

SELECT COUNT(*) FROM raw.customers;
SELECT COUNT(*) FROM raw.orders;
SELECT COUNT(*) FROM raw.order_items;