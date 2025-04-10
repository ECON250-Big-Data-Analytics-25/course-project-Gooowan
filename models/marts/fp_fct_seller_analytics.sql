{{ config(
    materialized = 'table'
) }}

with exploded_items as (
    select
        order_id,
        order_purchase_timestamp,
        order_delivered_carrier_date,
        item.seller_id,
        item.product_id,
        item.price,
        item.freight_value
    from {{ ref('fp_sales_full') }},
    unnest(order_items) as item
)


select
    seller_id,
    date_trunc(order_purchase_timestamp, month) as month,
    count(distinct order_id) as num_orders,
    sum(price) as total_sales,
    count(distinct product_id) as unique_products,
    avg(date_diff(order_delivered_carrier_date, order_purchase_timestamp, day)) as avg_fulfillment_days
from exploded_items
group by seller_id, month
