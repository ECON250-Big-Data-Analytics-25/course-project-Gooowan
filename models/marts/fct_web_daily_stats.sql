SELECT
date,
count(distinct fullVisitorID) as unique_visitors,
count(distinct visitId) as unique_visits,
count(distinct transaction.transactionId) as transaction_count,
sum( transaction.transactionRevenue) as revenue_sum,
 FROM {{ source('test_dataset', 'week5_web_visits') }}
 left join {{ ref('week5_web_transactions_deduplicated_view') }}
  using(date, visitId)
 group by 1