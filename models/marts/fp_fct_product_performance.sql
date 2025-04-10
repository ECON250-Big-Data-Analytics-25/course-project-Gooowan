{{ config(
    materialized = 'table'
) }}

with exploded_items as (
    select
        order_id,
        order_purchase_timestamp,
        item.product_id,
        item.price,
        item.freight_value,
        product_category_name_english
    from {{ ref('fp_sales_full') }},
    unnest(order_items) as item
)

select
    date_trunc(order_purchase_timestamp, month) as month,
    product_category_name_english,
    product_id,
    count(*) as num_orders,
    sum(price) as total_sales,
    sum(price) / count(*) as avg_price
from exploded_items
group by 1, 2, 3