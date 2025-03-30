select
    *,
    lower(influencer_name) as influencer_name_lower
from {{ source('external_sources', 'sheet_external') }}