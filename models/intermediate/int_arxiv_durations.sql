select
  id,
  title_cleaned,
  date_diff(updated_date, published_date, day) as update_duration_days
from {{ ref('stg_arxiv') }}