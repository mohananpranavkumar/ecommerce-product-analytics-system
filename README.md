# E-commerce Product Analytics System

End-to-end e-commerce product analytics system using Postgres, SQL, Python, Excel, and Tableau to track North Star metrics (Orders, AOV, Repeat Rate, Satisfaction) with a reusable KPI layer and dashboards.

## North Star
Healthy Growth = Orders × AOV × Repeat Rate × Customer Satisfaction

## MVP Scope
- 1 system (Postgres + SQL metrics layer)
- 2 dashboards (Exec Overview, Diagnostics)
- 10 KPIs (see `metrics.md`)
- Python: data quality + analysis story
- Excel: management pack

## Dataset overview
Brazilian E-commerce Public Dataset (Olist). Multi-table relational data similar to a production e-commerce system.

## Table map (grains + joins)

### Tables and what they store
- **orders** (grain: 1 row per order): order status + lifecycle timestamps
- **order_items** (grain: 1 row per item line): product_id, seller_id, price, freight
- **payments** (grain: 1 row per payment record): payment type, installments, payment value
- **reviews** (grain: 1 row per review): review score + comment fields + timestamps
- **customers** (grain: 1 row per customer_id): maps customer_id → customer_unique_id + geo
- **products** (grain: 1 row per product): category + physical attributes
- **sellers** (grain: 1 row per seller): seller geo
- **geolocation** (grain: many rows per zip_prefix): zip → lat/lng/city/state
- **category_translation** (grain: 1 row per category): PT → EN mapping

### Key relationships
- customers (1) → (many) orders via `customer_id`
- orders (1) → (many) order_items via `order_id`
- orders (1) → (many) payments via `order_id`
- orders (0/1) → (0/1) reviews via `order_id` (treat as separate table)
- products (1) → (many) order_items via `product_id`
- sellers (1) → (many) order_items via `seller_id`

### Join diagram (logical)
customers ──< orders ──< order_items >── products  
                      └─< payments  
                      └── reviews  
order_items >── sellers  
customers/sellers ── geo via zip_prefix (optional)

## Architecture (high-level)
1) Load CSVs → Postgres (`raw` schema)  
2) Build enriched views + KPI marts (`analytics` schema)  
3) Tableau dashboards read KPI marts  
4) Excel management pack reads KPI marts (exported)  
5) Python notebooks: QA + deeper analysis (+ optional forecast tables later)