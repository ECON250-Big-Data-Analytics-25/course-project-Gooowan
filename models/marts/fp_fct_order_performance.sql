{{ config(
    materialized = 'table'
) }}

with base as (
    select
        order_id,
        order_status,
        order_purchase_timestamp,
        product_category_name_english,
        total_order_cost
    from {{ ref('fp_sales_full') }}
)


select
    date_trunc(order_purchase_timestamp, month) as month,
    order_status,
    product_category_name_english,
    count(distinct order_id) as num_orders,
    sum(total_order_cost) as total_revenue
from base
group by 1, 2, 3