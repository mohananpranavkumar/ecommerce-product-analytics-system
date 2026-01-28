-- sql/30_export_marts_psql.sql
-- Export marts to CSV for Tableau Public
-- Run from repo root:
--   psql -U postgres -d ecommerce_analytics -f sql/30_export_marts_psql.sql

\set ON_ERROR_STOP on
SET client_encoding TO 'UTF8';

\copy (SELECT * FROM analytics.mart_kpi_monthly ORDER BY month) TO 'bi/exports/mart_kpi_monthly.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy (SELECT * FROM analytics.mart_category_monthly ORDER BY month, gmv DESC) TO 'bi/exports/mart_category_monthly.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy (SELECT * FROM analytics.mart_geo_state_monthly ORDER BY month, gmv DESC) TO 'bi/exports/mart_geo_state_monthly.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy (SELECT * FROM analytics.mart_seller_monthly ORDER BY month, gmv DESC) TO 'bi/exports/mart_seller_monthly.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy (SELECT * FROM analytics.mart_cohort_retention ORDER BY cohort_month, month_number) TO 'bi/exports/mart_cohort_retention.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');