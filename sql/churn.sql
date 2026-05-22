-- отток по стране
select country, count(*) as total_customers, sum(churn) as churned, round(avg(churn::numeric) * 100, 2) as churn_rate_pct
from bank_churn b
group by country
order by churn_rate_pct desc

--общий отток
select count(*) as total_customers, round(count(*) * 100.0 / sum(count(*)) over(), 2) as pct
from bank_churn
group by churn

-- отток по полу
select gender, round(avg(churn)*100, 2) as churn_rate
from bank_churn
group by gender
order by churn_rate desc

-- отток по возрастным группам
select
	case
		when age < 30 then '> 30'
		when age between 30 and 45 then '30-45'
		when age between 46 and 60 then '46-60'
		else '60+'
	end as age_group,
	round(avg(churn)*100, 2) as churn_rate, count(*) as total
from bank_churn
group by age_group
order by churn_rate desc

-- отток по активности и количесту продуктов
select active_member, products_number, round(avg(churn)*100, 2) as churn_rate, count(*) as total
from bank_churn
group by active_member, products_number
order by churn_rate desc

-- ранг стран по оттоку
select country, round(avg(churn)*100, 2) as churn_rate, rank() over (order by avg(churn) desc) as rank
from bank_churn
group by country

-- средний баланс ушедших/оставшихся по стране
select country, churn, round(avg(balance::numeric), 2) as avg_balance, round(avg(credit_score), 2) as avg_credit_score, round(avg(age), 2) as avg_age
from bank_churn bc
group by country, churn
order by country, churn