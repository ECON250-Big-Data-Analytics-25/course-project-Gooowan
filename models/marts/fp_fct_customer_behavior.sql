{{ config(
    materialized = 'table'
) }}

with orders as (
    select
        order_id,
        customer_id,
        customer_unique_id,
        order_purchase_timestamp,
        total_order_cost
    from {{ ref('fp_sales_full') }}
),

first_orders as (
    select
        customer_id,
        min(order_purchase_timestamp) as first_order_date
    from orders
    group by customer_id
),

tagged_orders as (
    select
        o.*,
        case
            when o.order_purchase_timestamp = f.first_order_date then 'new'
            else 'returning'
        end as customer_type
    from orders o
    join first_orders f using (customer_id)
)


select
    customer_unique_id,
    min(order_purchase_timestamp) as first_order_date,
    max(order_purchase_timestamp) as last_order_date,
    count(distinct order_id) as total_orders,
    round(sum(total_order_cost), 2) as lifetime_value,
    countif(customer_type = 'new') as num_new_orders,
    countif(customer_type = 'returning') as num_returning_orders
from tagged_orders
group by customer_unique_id