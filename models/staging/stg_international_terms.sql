select
    *
from {{ source('bigquery_public', 'international_top_terms') }}