with raw as (
    select * from {{ source('vsolomatin', 'fp_orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        order_status,
        cast(order_purchase_timestamp as timestamp) as order_purchase_timestamp,
        cast(order_approved_at as timestamp) as order_approved_at,
        cast(order_delivered_carrier_date as timestamp) as order_delivered_carrier_date,
        cast(order_delivered_customer_date as timestamp) as order_delivered_customer_date,
        cast(order_estimated_delivery_date as timestamp) as order_estimated_delivery_date,
        date_diff(order_delivered_customer_date, order_purchase_timestamp, day) as order_delivery_delay,
        order_status = 'delivered' as is_delivered,
        order_status = 'shipped' as is_shipped
    from raw
)

select * from renamed