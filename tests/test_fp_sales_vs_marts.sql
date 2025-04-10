with sales_full as (
    select round(sum(total_order_cost), 2) as total_sales
    from {{ ref('fp_sales_full') }}
),

mart_sales as (
    select round(sum(total_revenue), 2) as total_sales
    from {{ ref('mart_order_performance') }}
)

select *
from sales_full
full outer join mart_sales using (total_sales)
where sales_full.total_sales != mart_sales.total_sales