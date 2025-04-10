with raw as (
    select * from {{ source('vsolomatin', 'fp_sellers') }}
),

renamed as (
    select
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
    from raw
)

select * from renamed