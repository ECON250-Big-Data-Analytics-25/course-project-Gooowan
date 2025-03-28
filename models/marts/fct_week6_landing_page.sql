{{
  config(
    materialized='incremental',
    unique_key='visitId',
    incremental_strategy='merge'
  )
}}

WITH ranked_hits AS (
  SELECT
    date,
    visitId,
    page.pagePath as landing_page,
    ROW_NUMBER() OVER (PARTITION BY visitId ORDER BY date) as row_num
  FROM {{ source('test_dataset', 'week5_hits') }}
  WHERE hitNumber = 1
)

SELECT
  date,
  visitId,
  landing_page
FROM ranked_hits
WHERE row_num = 1

{% if is_incremental() %}
AND date >= (SELECT COALESCE(MAX(date) - 7, '2000-01-01') FROM {{ this }})
{% endif %}