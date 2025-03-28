SELECT *
FROM {{ ref('web_revenue') }}
WHERE revenue != expected_revenue