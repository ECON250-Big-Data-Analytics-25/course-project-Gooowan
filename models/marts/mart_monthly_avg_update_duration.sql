{{ config(materialized='table') }}

select
  extract(year from published_date) as year,
  extract(month from published_date) as month,
  avg(date_diff(updated_date, published_date, day)) as avg_update_duration_days
from {{ ref('stg_arxiv') }}
group by year, month