-- Объём продаж по продуĸтам за ĸаждый месяц
select
    product
    , date_trunc('month', transaction_date)::DATE as transaction_month
    , sum(sales_amount) as sales
from sales
group by product, transaction_month
;

-- Темпы роста продаж по продуĸтам за последние 3 месяца.
-- Мне не было понятно, что имеено нужно было отобразить тут. Я задавала вопросы на почте по поводу этого пункта
-- , но мне никто не ответил, поэтому я решила так как посчитала нужным.
-- А именно - взять последние 3 месяца и посчитать за каждый из них продажи по каждому продукту и сравнить
-- этим суммы между собой

with agg_products_month_sales as (
  select
    product
    , date_trunc('month', transaction_date)::date as transaction_month
    , sum(sales_amount) as sum_sales
  from sales
  where transaction_date between date_trunc('month', CURRENT_DATE) - interval '3 month' and date_trunc('month', CURRENT_DATE)
  group by product, transaction_month
)
select
	m1.product
    , m1.transaction_month as month_3
    , m1.sum_sales as sum_sales_month_3
    , m2.transaction_month as month_2
    , m2.sum_sales as sum_sales_month_2
	, case
    	when m1.sum_sales != 0 then round((m2.sum_sales - m1.sum_sales) * 100.0 / m1.sum_sales, 4)
        else 0
     end as diff_3_2
    , m3.transaction_month as month_1
    , m3.sum_sales as sum_sales_month_1
	, case
    	when m2.sum_sales != 0 then round((m3.sum_sales - m2.sum_sales) * 100.0 / m2.sum_sales, 4)
        else 0
     end as diff_2_1
from agg_products_month_sales m1
left join agg_products_month_sales m2
	on m1.product = m2.product
    and m1.transaction_month + interval '1 month' = m2.transaction_month
left join agg_products_month_sales m3
    on m1.product = m3.product
    and m1.transaction_month + interval '2 month' = m3.transaction_month
where  m1.transaction_month = date_trunc('month', CURRENT_DATE) - interval '3 month'
;


-- ТОП-3 продуĸта с наибольшим ростом.
-- мне не было понятно задание, как понять что был наибольший рост - по последнему или первому месяцу
-- поэтому я взяла сумму, которая была на 3 месяца назад, подсчитала общую куммулятивную сумму за 3 месяца и
-- нашла разницу между этими числами и считала топы по наибольшей разнице

with agg_products_sales as (
  select
    product
    , sum(sales_amount) as sum_sales_total
  from sales
  where transaction_date between date_trunc('month', CURRENT_DATE) - interval '3 month' and date_trunc('month', CURRENT_DATE)
  group by product
),
agg_products_3m_sales as (
  select
    product
    , sum(sales_amount) as sum_sales_3m
  from sales
  where date_trunc('month', transaction_date) = date_trunc('month', CURRENT_DATE) - interval '3 month'
  group by product
)
select
	sale_total.product
	, case
    	when sum_sales_3m != 0 then round((sum_sales_total - sum_sales_3m) * 100.0 / sum_sales_3m, 4)
        else 0
    end diff
from agg_products_sales sale_total
LEFT join agg_products_3m_sales m3
	on sale_total.product = m3.product
order by diff desc
limit 3



