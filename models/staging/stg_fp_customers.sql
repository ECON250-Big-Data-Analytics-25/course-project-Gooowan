with raw as (
    select * from {{ source('vsolomatin', 'fp_customers') }}
),

renamed as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    from raw
)

select * from renamed