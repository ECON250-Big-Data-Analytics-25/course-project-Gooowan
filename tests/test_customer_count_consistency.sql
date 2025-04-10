with totals as (
  select
    (select count(distinct customer_unique_id) from {{ ref('fp_sales_full') }}) as total_customers,
    (select count(distinct customer_unique_id) from {{ ref('fp_fct_customer_behavior') }}) as behavior_customers
)

select *
from totals
where total_customers != behavior_customers