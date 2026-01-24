# Metrics (MVP Standards)

## North Star
Healthy Growth = Orders × AOV × Repeat Rate × Customer Satisfaction

## Global MVP Standards
- **Time grain:** Monthly (`kpi_monthly`)
- **Customer identity (repeat):** `customer_unique_id`
- **GMV (revenue proxy):** `SUM(order_items.price)` (freight excluded)
- **Sales-eligible orders:** `order_status = 'delivered'`
- **On-time delivery:** `order_delivered_customer_date <= order_estimated_delivery_date`
- **Delivery days:** `order_delivered_customer_date - order_purchase_timestamp` (delivered orders only)

## KPI List (MVP 10)
1. Orders
2. GMV
3. AOV
4. Items per Order
5. Cancellation Rate
6. On-time Delivery Rate
7. Avg Delivery Days
8. Avg Review Score
9. Repeat Customer Rate
10. Concentration (Top Sellers share OR Top Categories share)