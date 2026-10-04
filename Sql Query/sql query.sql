create database insurance;
use insurance;
select * from df;

-- Q1. Saare customers dikhao jinki Age 60 se zyada h.
select * from df where age > 60;

-- Q2. Sirf 'Full Coverage' Policy_Type wale customers dikhao.
select * from df where policy_type = 'full coverage';

-- Q3. Un customers ko dikhao jinka Premium_Amount 2500 se zyada h, DESC order me, top 10.
select * from df order by premium_amount desc limit 10;

-- Q4. Married AND Urban region wale customers dikhao.
select * from df where marital_status = 'married' and region ='urban';

-- Q5. Un leads ko dikhao jo convert hue h (Conversion_Status = 1) aur Source_of_Lead 'Referral' h.
select * from df where conversion_status = 1 and source_of_lead = 'referral';

-- Q6. Credit_Score 750 se zyada wale customers count karo.
select * from df where credit_score  > 750;

-- Q7. Claims_Severity = 'High' wale saare customers dikhao.
select * from df where claims_severity = 'high';

-- Q8. Un customers ko dikhao jinka Total_Discounts 0 h (koi discount nahi mila).
select * from df where total_discounts = 0 ;

-- Q9. Region = 'Rural' OR Region = 'Suburban' wale customers dikhao.
select * from df where region = 'rural' or 'suburban';

-- Q10. Distinct Prior_Insurance categories dikhao.
select distinct prior_insurance from df;

-- Q11. Har Region ka average Premium_Amount nikalo.
select region ,avg(premium_amount) as avg_premium_amount from df group by region order by avg_premium_amount desc;

-- Q12. Har Marital_Status ka total customers count karo.
select marital_status,count(*) as total_customers from df group by marital_status;

-- Q13. Har Source_of_Lead ka conversion rate (average Conversion_Status × 100) nikalo, DESC order me.
select source_of_lead,avg(conversion_status) * 100 as conversion_rate
from df group by source_of_lead order by conversion_rate desc;

-- Q14. Sirf un Regions ka data dikhao jinka average Premium_Amount 2200 se zyada h (HAVING).
select region,avg(premium_amount) as avg_premium from df group by region having avg_premium > 2200;

-- Q15. Policy_Type aur Region dono ke combination ka average Premium_Amount nikalo.
select policy_type,region,avg(premium_amount) as avg_premium from df group by policy_type,region
order by region,avg_premium desc;

-- Q16. Claims_Severity ke hisaab se average Claims_Adjustment nikalo.
select claims_severity,avg(claims_adjustment) as avg_adjustment from df group by claims_severity;

-- Q17. Sirf un Source_of_Lead ka data dikhao jinke 3000 se zyada leads h.
select source_of_lead, count(*) as total_leads from df 
group by source_of_lead having total_leads > 3000;

-- Q18. Is_Senior ke hisaab se average Credit_Score compare karo.
select is_senior,avg(credit_score) as avg_credit_score from df group by is_senior;

-- Q19. Prior_Insurance ke hisaab se average Time_to_Conversion nikalo.
select prior_insurance,avg(time_to_conversion) as avg_time_to_conversion from df 
group by prior_insurance;

-- Q20. Har Region ka total premium revenue (SUM) nikalo, DESC order me.
select region, sum(premium_amount) as total_revenue from df group by region
order by total_revenue desc;

-- Q21. Premium_Amount ko 'High'(>2400), 'Medium'(2100-2400), 'Low'(<2100) me categorize karo.
select age,premium_amount, case when premium_amount > 2400 then 'high'
when premium_amount >=2100 then 'medium'
else 'low' end as premium_tier from df;

-- Q22. Har Premium_Tier me kitne customers h, count karo.
select case when premium_amount > 2400 then 'high'
when premium_amount >=2100 then 'medium'
else 'low' end as premium_tier, count(*) as total_customers from df group by premium_tier ;

-- Q23. Credit_Score ko 'Excellent'(>=750), 'Good'(650-749), 'Fair'(<650) me baato aur har category ka average Premium_Amount nikalo.
select case when credit_score >= 750 then 'excellent'
when credit_score >= 650 then 'good'
else 'fair' end as credit_score_tier,avg(premium_amount) as avg_premium from df group by credit_score_tier;

-- Q24. Total_Discounts formula validate karo SQL se — kitne rows me formula match nahi hota (Married_Premium_Discount ko chhod kar).
select count(*) from df where total_discounts !=(safe_driver_discount + multi_policy_discount + bundling_discount) * 50;

-- Q25. Time_to_Conversion = 99 (placeholder value) wale kitne rows h, aur unka Conversion_Status kya h?
select conversion_status,count(*) as total from df where time_to_conversion = 99 group by conversion_status;

-- Q26. Overall average Premium_Amount se zyada bharne wale customers dikhao (Subquery).
select * from df where premium_amount > (select avg(premium_amount) from df);

-- Q27. Sabse zyada average Premium_Amount wale Region ka naam nikalo (Subquery).
select region,avg(premium_amount) as avg_premium
from df group by region having avg_premium = (
select max(avg_p) from (select avg(premium_amount) as avg_p from df group by region));

-- Q28. Un Source_of_Lead ka naam nikalo jinka conversion rate, overall average conversion rate se kam h.
select source_of_lead,avg(conversion_status) as conv_rate
from df group by source_of_lead
having conv_rate <(select avg(conversion_status) from df);

-- Q29. Har Region ke andar, customers ko Premium_Amount ke hisaab se RANK do.
select age,region,premium_amount, rank() over(partition by region order by premium_amount desc) as 
rank_in_region from df;

-- Q30. Har Region ke top 5 highest-premium customers nikalo.
select * from (select age,region,premium_amount, rank() over(partition by region
order by premium_amount desc) as rnk from df ) where rnk <=5;

-- Q31. Har Policy_Type ka average Premium poore table ke average ke sath side-by-side dikhao (window AVG).
select distinct policy_type,avg(premium_amount) over(partition by policy_type) as type_avg,
avg(premium_amount) over () as overall_avg from df;

-- Q32. ROW_NUMBER vs RANK ka farak dikhao — Region ke andar Premium_Amount ke hisaab se.
select age,region,premium_amount, row_number() over (partition by region order by premium_amount desc)
as row_num, rank() over (partition by region order by premium_amount desc) as rank_num from df;

-- Q33. Har Marital_Status ke andar customers ka running total Premium_Amount nikalo (Age ke order me).
select marital_status,age,premium_amount,sum(premium_amount) over ( partition by marital_status order by age)
as running_total from df;

-- Q34. Har customer ke sath uska pichla (previous row ka) Premium_Amount dikhao (LAG), Age ke order me.
select age,premium_amount, lag(premium_amount) over(order by age) as previous_premium from df;

-- Q35. Region-wise Premium_Amount ka % contribution total revenue me nikalo.
select region,sum(premium_amount) as region_total, round(sum(premium_amount) * 100/ (
select sum(premium_amount) from df),2) as pct_contribution from df group by region;

-- Q36. Har Source_of_Lead ka conversion rank (highest conversion rate = rank 1) nikalo.
select source_of_lead,avg(conversion_status) as conv_rate,
rank() over (order by avg(conversion_status) desc) as conv_rank
from df group by source_of_lead;

-- Q37. Har Claims_Severity ke andar top 3 highest Premium_Amount wale customers dikhao.
select * from 
(select age,claims_severity,premium_amount,
rank() over(partition by claims_severity order by premium_amount desc) as rnk 
from df ) where rnk <= 3;

-- Q38. Two queries ko UNION se jodo: 'High Premium' (>2500) customers 
-- aur 'High Claims' (Claims_Adjustment>200) customers, ek list me flag ke sath.
select age,premium_amount, 'high_premium' as flag from df where premium_amount > 2500 
union
select age,premium_amount,'high_claims' as flag from df where claims_adjustment > 200;

-- Q39. Har Region-Policy_Type combination ka average premium, aur us combination ka rank (sabse zyada earning combo = rank 1).
select region,policy_type,avg(premium_amount) as avg_prem,
rank() over(order by avg(premium_amount)desc) as combo_rank
from df group by region,policy_type;

-- Q40. Final complex query: Har Region ka Total Customers, Total Revenue, 
-- Average Conversion Rate, aur Revenue Rank — sab ek query me.
select region,count(*) as total_customers,
sum(premium_amount) as total_revenue,
round(avg(conversion_status)*100,2) as conv_rate_pct,
rank() over (order by sum(premium_amount)desc) as revenue_rank from df group by region;
