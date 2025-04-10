{{ config(
    materialized = 'incremental',
    unique_key = 'order_id',
    partition_by = {
      "field": "order_purchase_timestamp",
      "data_type": "timestamp"
    },
    cluster_by = ['order_status', 'product_category_name_english']
) }}

with orders as (
    select * from {{ ref('stg_fp_orders') }}
    {% if is_incremental() %}
    where order_purchase_timestamp >= (select max(order_purchase_timestamp) from {{ this }})
    {% endif %}
),

customers as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    from {{ ref('stg_fp_customers') }}
),

items as (
    select
        order_id,
        array_agg(struct(
            product_id,
            seller_id,
            price,
            freight_value
        )) as order_items,
        sum(price + freight_value) as total_order_cost
    from {{ ref('stg_fp_order_items') }}
    group by order_id
),

products as (
    select
        product_id,
        product_category_name
    from {{ ref('stg_fp_products') }}
),

translated_categories as (
    select
        product_category_name,
        product_category_name_english
    from {{ source('vsolomatin', 'fp_product_category_name_translation') }}
),

payments as (
    select
        order_id,
        array_agg(struct(
            payment_type,
            payment_installments,
            payment_value
        )) as payment_details,
        sum(payment_value) as total_payment
    from {{ ref('stg_fp_order_payments') }}
    group by order_id
),

order_product_category as (
    select
        oi.order_id,
        any_value(pt.product_category_name_english) as product_category_name_english
    from {{ ref('stg_fp_order_items') }} oi
    join {{ ref('stg_fp_products') }} p using (product_id)
    left join {{ source('vsolomatin', 'fp_product_category_name_translation') }} pt
        on p.product_category_name = pt.product_category_name
    group by order_id
)

select
    o.order_id,
    o.customer_id,
    cust.customer_unique_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.order_delivery_delay,
    o.is_delivered,
    o.is_shipped,

    i.order_items,
    i.total_order_cost,

    p.payment_details,
    p.total_payment,

    c.product_category_name_english

from orders o
left join items i on o.order_id = i.order_id
left join payments p on o.order_id = p.order_id
left join order_product_category c on o.order_id = c.order_id
left join customers cust using (customer_id)

