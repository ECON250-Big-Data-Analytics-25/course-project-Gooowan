{{ config(materialized='table') }}

with aggregated as (
    select
        title,
        sum(views) as total_views,
        sum(if(src = 'mobile', views, 0)) as total_mobile_views,
        rank() over (order by sum(views) desc) as rnk
    from {{ ref('int_assignment3_uk_wiki') }}
    where not is_meta_page
    group by title
)

select
    title,
    total_views,
    total_mobile_views,
    round((total_mobile_views / total_views) * 100, 2) as mobile_percentage
from aggregated
where rnk <= 200
order by mobile_percentage asc