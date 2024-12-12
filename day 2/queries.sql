-- Объём продаж по продуĸтам за ĸаждый месяц
select
date_trunc('month', transaction_date)::DATE as transaction_month
, sum(sales_amount) as sales
from sales
group by transaction_month

-- Темпы роста продаж по продуĸтам за последние 3 месяца.

-- ТОП-3 продуĸта с наибольшим ростом.
