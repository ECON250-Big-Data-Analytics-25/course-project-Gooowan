{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='title'
  )
}}

WITH base AS (
  SELECT
    title,
    DATE(TIMESTAMP_TRUNC(datehour, DAY)) AS date,
    SUM(views) AS views
  FROM {{ source('test_dataset', 'assignment5_input') }}

  {% if is_incremental() %}
    WHERE DATE(TIMESTAMP_TRUNC(datehour, DAY)) >= (
      SELECT DATE_SUB(MAX(max_date), INTERVAL 1 DAY)
      FROM {{ this }}
    )
  {% endif %}

  GROUP BY title, date
)


SELECT
    title,
    MIN(date) AS min_date,
    MAX(date) AS max_date,
    SUM(views) AS total_views
FROM base
GROUP BY title