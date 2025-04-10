with base as (
    select count(distinct order_id) as total_orders
    from {{ ref('fp_sales_full') }}
),

behavior as (
    select count(*) as tagged_orders
    from {{ ref('mart_customer_behavior') }}
)

select *
from base, behavior
where base.total_orders != behavior.tagged_orders