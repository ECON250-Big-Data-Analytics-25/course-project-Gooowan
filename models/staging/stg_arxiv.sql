select
  id,
  published_date,
  updated_date,
  category,
  lower(title) as title_cleaned
from {{ source('external_sources', 'week3_arxiv_extended') }}