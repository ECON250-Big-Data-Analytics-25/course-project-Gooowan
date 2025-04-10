with raw as (
    select * from {{ source('vsolomatin', 'fp_order_payments') }}
),

renamed as (
    select
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value,
        payment_type = 'credit_card' as is_credit_card,
        payment_type = 'boleto' as is_boleto
    from raw
)

select * from renamed