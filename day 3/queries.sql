-- Подсчет среднего чеĸа для ĸаждой группы.
select
    ab_groups.group
    , avg(amount) as avg_check
from transactions
join ab_groups
    on transactions.user_id = ab_groups.user_id
group by ab_groups.group


-- Подсчет общего объёма продаж для ĸаждой группы.

select
    ab_groups.group
    , sum(amount) as sum_amount
from transactions
join ab_groups
    on transactions.user_id = ab_groups.user_id
group by ab_groups.group

-- Подсчет количества униĸальных пользователей в ĸаждой группе.

select
    group
    , count(distinct user_id) as unic_count_users
from ab_groups
group by group
