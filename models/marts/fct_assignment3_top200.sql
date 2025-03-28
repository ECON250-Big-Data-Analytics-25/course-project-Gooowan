{{ config(materialized='table') }}

with base as (
    select *
    from {{ ref('int_assignment3_uk_wiki') }}
    where not is_meta_page
),

aggregated as (
    select
        title,
        sum(views) as total_views,
        sum(case when src = 'mobile' then views else 0 end) as total_mobile_views
    from base
    group by title
),

calculated as (
    select
        title,
        total_views,
        total_mobile_views,
        round((total_mobile_views / total_views) * 100, 2) as mobile_percentage
    from aggregated
)

select *
from calculated
order by mobile_percentage asc
limit 200

{#first - top 200
next - percent
next - sort#}