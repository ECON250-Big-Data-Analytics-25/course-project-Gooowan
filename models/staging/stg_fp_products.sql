with raw as (
    select * from {{ source('vsolomatin', 'fp_products') }}
),

cleaned as (
    select
        product_id,
        coalesce(product_category_name, 'unknown') as product_category_name,
        product_name_lenght as product_name_length,
        product_description_lenght as product_description_length,
        coalesce(product_photos_qty, 0) as product_photos_qty,
        coalesce(product_weight_g, 0) as product_weight_g,
        coalesce(product_length_cm, 0) as product_length_cm,
        coalesce(product_height_cm, 0) as product_height_cm,
        coalesce(product_width_cm, 0) as product_width_cm
    from raw
)

select * from cleaned