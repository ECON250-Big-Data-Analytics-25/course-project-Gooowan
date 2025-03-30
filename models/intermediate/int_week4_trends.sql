select distinct
  *
from {{ ref('stg_international_terms') }} as trends
left join {{ ref('all') }} as countries
on upper(trends.country_name) = upper(countries.name)