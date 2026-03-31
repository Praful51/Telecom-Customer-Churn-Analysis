create database customer_churn_project;
use customer_churn_project;

select * from customer_churn_project;

#1. Over all churn rate

select Churn,count(*) as total_customers,
round(count(*)*100.0/(select count(*) from customer_churn_project),2)as percentage
from customer_churn_project
group by churn;

#2. Churn rate by contract type

select Contract,count(*) as total_customers,
sum(case when churn='Yes' then 1 else 0 end) as churned_customers,
round(avg(case when churn='Yes' then 100.0 else 0 end),2) as churn_Rate
from customer_churn_project
group by contract;

#3. Churn rate by Tenure

select case 
when tenure <=6 then '0-6 months'
when tenure <=12 then '7-12 months'
when tenure <=24 then '13-24 months'
else '25+ months'
end as tenure_group,
count(*) as total_customers,
ROUND(AVG(CASE WHEN Churn='Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
from customer_churn_project
group by tenure_group
order by total_Customers desc;

#4. Revenue lost due to churn

select sum(monthlycharges) as total
from customer_churn_project
where Churn='Yes';

#5. High risk customer segments

SELECT 
    Contract,
    PaymentMethod,
    InternetService,
    COUNT(*) AS total_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2) AS historical_churn_rate
FROM customer_churn_project
GROUP BY Contract, PaymentMethod, InternetService
HAVING COUNT(*) >= 50          
ORDER BY historical_churn_rate DESC
LIMIT 15;

#6. Churn by payment method

select paymentmethod,count(*) as total_customers,
sum(Case when churn='yes' then 1 else 0 end) as churned_customers,
ROUND(AVG(CASE WHEN Churn='Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
from customer_churn_project
group by paymentmethod;

select * from customer_churn_project;

#7. Safe & valuable Customer segments

select contract,paymentmethod,
 case 
when tenure <=6 then '0-6 months'
when tenure <=12 then '7-12 months'
when tenure <=24 then '13-24 months'
else '25+ months'
end as tenure_group,
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS historical_churn_rate,
count(customerid)as total_customers
from customer_churn_project
group by  tenure_group,contract,paymentmethod
HAVING COUNT(*) >= 30
order by historical_churn_Rate asc, total_customers desc;


#8. Premium & loyal customers

select customerID,tenure,contract,paymentmethod,totalcharges
from customer_churn_project
where churn='No'
order by totalcharges desc;


#9. Analysis by service

SELECT 
    'InternetService' AS service_type,
    InternetService AS service_value,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
FROM customer_churn_project
GROUP BY InternetService

UNION ALL

SELECT 
    'TechSupport' AS service_type,
    TechSupport AS service_value,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
FROM customer_churn_project
GROUP BY TechSupport

UNION ALL

SELECT 
    'OnlineSecurity' AS service_type,
    OnlineSecurity AS service_value,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
FROM customer_churn_project
GROUP BY OnlineSecurity

UNION ALL

SELECT 
    'OnlineBackup' AS service_type,
    OnlineBackup AS service_value,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
FROM customer_churn_project
GROUP BY OnlineBackup

UNION ALL

SELECT 
    'DeviceProtection' AS service_type,
    DeviceProtection AS service_value,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
FROM customer_churn_project
GROUP BY DeviceProtection

UNION ALL

SELECT 
    'StreamingTV' AS service_type,
    StreamingTV AS service_value,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
FROM customer_churn_project
GROUP BY StreamingTV

UNION ALL

SELECT 
    'StreamingMovies' AS service_type,
    StreamingMovies AS service_value,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 100.0 ELSE 0 END), 2) AS churn_rate
FROM customer_churn_project
GROUP BY StreamingMovies
order by churn_Rate desc;


