{{ config(materialized='view') }}

with desktop as (
    select
        title,
        datehour,
        views,
        'desktop' as src
    from {{ source('assignment3', 'assignment3_input_uk') }}
),

mobile as (
    select
        title,
        datehour,
        views,
        'mobile' as src
    from {{ source('assignment3', 'assignment3_input_uk_m') }}
),

combined as (
    select * from desktop
    union all
    select * from mobile
)

select
    title,
    datehour,
    views,
    src,
    date(datehour) as date,
    extract(dayofweek from datehour) as day_of_week_bq,
    case
      when extract(dayofweek from datehour) = 1 then 7
      else extract(dayofweek from datehour) - 1
    end as day_of_week,
    extract(hour from datehour) as hour_of_day
from combined