select date,
revenue_sum as fct_revenue,
transaction_revenue,
abs(transaction_revenue - revenue_sum) / transaction_revenue

 from {{ ref("fct_web_daily_stats")}}
 join
 ( select date, sum(transaction.transactionRevenue) as transaction_revenue
   from {{ ref("week5_web_transactions_deduplicated_view")}}
   group by 1
) using(date)
where
    abs(transaction_revenue - revenue_sum) / transaction_revenue > 0.01