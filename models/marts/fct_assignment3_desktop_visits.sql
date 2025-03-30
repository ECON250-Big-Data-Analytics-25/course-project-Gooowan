{{ config(materialized='table') }}

with base as (
    select *
    from {{ ref('int_assignment3_uk_wiki') }}
    where not is_meta_page
),

top_titles as (
    select
        title
    from base
    group by title
    order by sum(views) desc
    limit 200
),

aggregated as (
    select
        b.title,
        sum(b.views) as total_views,
        sum(case when b.src = 'desktop' then b.views else 0 end) as total_desktop_views
    from base b
    join top_titles t on b.title = t.title
    group by b.title
)

select
    title,
    total_views,
    total_desktop_views,
    round((total_desktop_views / total_views) * 100, 2) as desktop_percentage
from aggregated
order by desktop_percentage asc