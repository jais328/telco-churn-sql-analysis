-- TELCO CUSTOMER CHURN ANALYSIS — SQL PROJECT
-- Author: Ritik Gupta
-- Database: PostgreSQL
-- Dataset: IBM Telco Customer Churn (7,043 customers, 21 columns)


CREATE TABLE telco_churn(
 customerid    text primary key,
 gender         text,
 seniorcitizen  integer,
 partner        text,
 Dependents     text,
 tenure         integer,
 PhoneService   Text,
 MultipleLines  Text,
InternetService Text,
 OnlineSecurity Text,
 OnlineBackup   Text,
 DeviceProtection text,
 TechSupport	Text,
 StreamingTV	Text,
 StreamingMovies text,
 Contract	     Text,
 PaperlessBilling Text,
 PaymentMethod    Text,
 MonthlyCharges	  Float,
 TotalCharges     Text,
 Churn            Text);


 --Clean & Convert after import

 update telco_churn
 set TotalCharges = NULL
 where trim (TotalCharges) = '';

 Alter table telco_churn
 alter column TotalCharges type float 
 using TotalCharges :: float;

 -- Verify karo data

 select count(*) from telco_churn;

 
 --Question 1: 
 --How many customers churned vs retained? Show the total count and percentage of each — rounded to 2 decimal places.


With total_cx as
(select count(customerid) as total_customer from telco_churn)
select churn, 
count(customerid) as total_customer,
round(count(customerid)*100.0/total_cx.total_customer,2) as Cx_percentage
from telco_churn
cross join total_cx
group by churn, total_cx.total_customer;

--Key: 26.54% customers churned — 1 in 4 customers is leaving
--Business: This is a critical problem. Industry benchmark is 15% — this company is 11% above!

--Question 2:

--Find the average monthlycharges, average tenure, and average totalcharges for churned vs retained customers. Round all values to 2 decimal places.

select churn, 
round(avg(monthlycharges):: numeric, 2) as avg_monthlycharges,
round(avg(tenure):: numeric, 2) as avg_tenure,
round(avg(totalcharges):: numeric, 2) as avg_totalcharges
from telco_churn
group by churn;


--Key: Churned customers pay MORE monthly ($74 vs $61) but stay SHORTER (18 vs 37 months)
--Business: They leave before generating full lifetime value — expensive customers to lose!


--Question 3:

--What is the gender distribution of customers? Show total count and churn rate for each gender.

Select gender,
   COUNT(CUSTOMERID) AS TOTAL_CUSTOMER,
   SUM(CASE WHEN CHURN = 'Yes' THEN 1 ELSE 0 END) AS CHURNED,
   ROUND((SUM(CASE WHEN CHURN ='Yes' THEN 1 ELSE 0 END)*100.0 / COUNT(CHURN))::NUMERIC, 2) AS CHURN_RATE
FROM TELCO_CHURN
GROUP BY GENDER

--Key: Female 26.92% vs Male 26.16% — almost identical churn rates
--Business: Gender is NOT a churn predictor — gender-based campaigns would be wasted budget

--Question 4 

--Compare churn rate between Senior Citizens vs Non-Senior Citizens. Show total customers, churned count and churn rate.

Select count(customerid) as total_customer,
case when seniorcitizen = 1 then 'Senior citizen' else 'Non Senior Citizen' end as Citizen_Type,
Sum(case when churn = 'Yes'Then 1 Else 0 End) As Churned,
Round((Sum(case when churn ='Yes' Then 1 Else 0 End)*100.0/Count(Churn)):: Numeric ,2) AS Churn_rate From Telco_Churn
Group by Citizen_type;


--Key: Senior citizens churn at 41.68% vs 23.61% for non-seniors
--Business: Seniors are 2X more likely to leave — they need dedicated support programs


--Question 5:

--Analyze churn rate based on whether customers have a Partner and Dependents. Show all 4 combinations.

Select Partner, 
dependents,
Count(Customerid) AS Total_Customer,
Sum(Case when Churn = 'Yes' Then 1 else 0 end) As Churned,
Round((Sum(Case when Churn = 'Yes' Then 1 else 0 end)*100.0/count(Churn)):: Numeric ,2) As Churn_Rate
From Telco_Churn
Group by Partner, dependents
Order by Partner, dependents;

--Key: No partner + No dependents = 31.22% churn (highest). Partner + Dependents = 23.17% (lowest)
--Business: Single customers have no family anchor — easiest to switch providers


--Question 6:

--What is the churn rate for each contract type? Which contract type has the highest churn?

Select 
contract,
Count(Customerid) as Total_customer,
Sum(case when churn = 'Yes' then 1 else 0 end) as Churned,
Round((Sum(case when churn = 'Yes' then 1 else 0 end)*100.0/count(Churn))::Numeric,2) as Churn_rate
from Telco_churn
Group by contract
Order by Churn_rate Desc;


--Key: Month-to-month = 42.71% vs Two year = 2.83% — 15X difference!
--Business: CONTRACT TYPE is the #1 churn predictor. Push customers to annual contracts with discounts


--Question 7:

--What is the churn rate by Internet Service type? Which service has the highest churn?

Select 
internetservice,
Count(Customerid) as Total_Customer,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) As Churned,
Round((Sum(Case When Churn = 'Yes' Then 1 Else 0 End)*100.0/Count(Churn))::Numeric, 2) as Churn_rate
from Telco_churn
Group by Internetservice
order by Churn_rate desc;

--Key: Fiber optic = 41.89% vs No internet = 7.40%
--Business: Fiber customers expect premium quality — they leave when expectations aren't met


--Question 8:
--What is the churn rate by Payment Method? Which payment method has the highest churn?

Select Paymentmethod,
Count(Customerid) as Total_Customer,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) as Churned,
Round((Sum(Case When Churn = 'Yes' Then 1 Else 0 End)*100.0/Count(Churn))::Numeric,2) As Churn_Rate
From Telco_Churn
Group by Paymentmethod
Order by Churn_rate desc;

--Key: Electronic check = 45.29% vs Credit card auto = 15.24%
--Business: Auto-payment customers are 3X more loyal — incentivize switching to autopay

--Question 9:

--Divide customers into tenure groups and show churn rate for each group.

Select 
Case when tenure <= 12 Then 'New Customer' 
 when tenure between 13 And 24 then 'Growing Customer'
 when tenure between 25 And 48 then 'Mature Customer'
else 'Loyal Customer' end as tenure_group,
Count(Customerid) as Total_Customer,
Sum(case when churn = 'Yes' Then 1 Else 0 end ) as Churned,
Round((Sum(case when churn = 'Yes' Then 1 Else 0 end )*100.0/Count(Churn))::Numeric , 2)
As Churn_Rate
From telco_churn
Group by tenure_group
order by Churn_Rate desc;

--Key: New customers (0-12 months) = 47.72% vs Loyal (49+ months) = 6.84%
--Business: YEAR 1 is the critical window — onboarding experience must be flawless

--Question 10:

--Analyze churn rate based on Phone Service and Multiple Lines. Show all combinations.

Select phoneservice,
multiplelines,
count(customerid) as Total_customer,
Sum(Case when churn = 'Yes' then 1  else 0 end) as Churned,
Round((Sum(Case when churn = 'Yes' then 1 else 0 end)*100.0/Count(churn))::Numeric , 2) As churn_rate 
from Telco_Churn
Group by phoneservice , multiplelines
Order by churn_rate desc;

--Key: No phone service = 13.05% vs Multiple lines = 28.78%
--Business: Phone service alone is NOT a strong churn driver — don't rely on it for retention

-Question 11:

--Analyze churn rate based on Streaming Services (StreamingTV and StreamingMovies). Show all combinations and which combination has highest churn.

Select 
streamingtv,
streamingmovies,
Count(Customerid) as Total_customer,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) As Churned,
Round((Sum(Case When Churn = 'Yes' Then 1 Else 0 End)*100.0/Count(Churn))::Numeric, 2) As Churn_rate
from Telco_Churn
Group by streamingtv,streamingmovies
order by Churn_rate Desc;

--Key: Both streaming = 27.93% vs No streaming = 21.52% — only 6% gap
--Business: Streaming add-ons don't significantly improve retention — not worth heavy investment

--Question 12:

--Analyze churn rate based on Online Security and Tech Support. Show all combinations.

Select 
onlinesecurity,
techsupport,
Count(Customerid) As Total_Customer,
Sum(Case When Churn = 'Yes' Then 1 Else 0 End) As Churned,
Round((Sum(Case When Churn = 'Yes' Then 1 Else 0 End)*100.0/Count(Churn))::Numeric , 2) As Churn_Rate
From Telco_Churn
Group by onlinesecurity, techsupport
Order by Churn_Rate Desc;

--Key: No security + No support = 37.79% vs With security = 12.74%
--Business: Online security is a KEY retention tool — protected customers feel more committed

--Question 13:

--Calculate the total monthly revenue lost due to churned customers and total revenue retained. Also show the percentage of revenue lost.

With Total_revanue As
(Select Sum(Monthlycharges) as Total 
From Telco_Churn)
Select 
Case when Churn = 'Yes' Then 'Churned' Else 'Retained' End As Status,
Round(Sum(Monthlycharges)::Numeric, 2) As Total_Monthly_Revanue,
Round((Sum(Monthlycharges)*100.0/Total_revanue.total)::Numeric, 2) As Percentage
From Telco_churn
Cross Join Total_revanue
Group by Status ,Total_revanue.total
Order by Percentage;

--Key: $49,493 lost EVERY month — $593,916 per year!
--Business: Retaining just 10% of churned customers saves $49K/month — ROI on retention is massive

--Question 14:

--Find average monthly charges, average total charges and total revenue for each contract type. Order by average monthly charges descending.

Select  Contract ,
Round(Avg(Monthlycharges) ::Numeric, 2) As Avg_Monthly_Charges,
Round(Avg(Totalcharges)::Numeric, 2) As avg_total_charges,
Round(Sum(Totalcharges)::Numeric ,2) as total_revenue
From Telco_Churn
Group by contract
Order by avg_monthly_charges DESC;


--Key: Two-year customers generate $3,919 total vs Month-to-month $1,369
--Business: Long-term contracts generate 3X more lifetime value per customer


--Question 15:

--Find the top 10 highest paying churned customers. Show their contract type, payment method, tenure and monthly charges.

Select 
Customerid,
monthlycharges,
Tenure,
Contract,
Paymentmethod
From Telco_churn
where Churn = 'Yes'
Order by monthlycharges Desc
Limit 10;

--Key: Top churned customers mostly use electronic check + month-to-month
--Business: These are priority win-back targets — losing them hurts most financially

--Question 16:

--Find the average monthly charges for churned customers grouped by Contract Type and Internet Service. Order by avg_monthly_charges descending.

Select 
contract,
internetservice,
Round(avg(Monthlycharges)::Numeric , 2) as avg_monthly_charges
From Telco_Churn
Where Churn = 'Yes'
Group by contract , internetservice
Order by avg_monthly_charges desc;

--Key: Month-to-month + Fiber optic churned customers pay $91.44/month — highest!
--Business: This combination = most expensive customers to lose — target with premium offers

--Question 17:

--Calculate total revenue, churned revenue and revenue loss percentage for each Internet Service type.


SELECT 
internetservice,
ROUND(SUM(monthlycharges)::NUMERIC, 2) AS total_revenue,
ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthlycharges ELSE 0 END)::NUMERIC, 2) AS churned_revenue,
ROUND((SUM(CASE WHEN churn = 'Yes' THEN monthlycharges ELSE 0 END)*100.0/SUM(monthlycharges))::NUMERIC, 2) AS revenue_loss_pct
FROM telco_churn
GROUP BY internetservice
ORDER BY revenue_loss_pct DESC;

--Key: Fiber optic loses 41.90% of its revenue = $118,640 every month!
--Business: Fix fiber optic churn first — it has the single biggest revenue recovery opportunity


-- Question 18:

Select 
paymentmethod,
Round(Sum(monthlycharges)::Numeric, 2) As total_revenue,
Round(Sum(Case when churn = 'Yes' Then monthlycharges Else 0 End)::Numeric, 2) As churned_revenue,
Round((Sum(Case when churn = 'Yes' Then monthlycharges Else 0 End)*100.0/SUM(monthlycharges))::numeric, 2) As revenue_loss_pct
From Telco_churn
Group by paymentmethod
Order by revenue_loss_pct Desc;

--Key: Electronic check loses 46.08% revenue vs Credit card auto 15.22%
--Business: Migrating electronic check users to autopay could recover millions annually

--Question 19:

--Using a CTE, segment customers into 3 risk categories based on their profile. Then count customers and churn rate in each risk segment.

With risk_segments As
( Select *, 
Case when contract = 'Month-to-month' 
And Tenure < 12
And monthlycharges > 65 Then 'High Risk'
when contract = 'Month-to-month'
And Tenure <24 Then 'Medium Risk'
Else 'Low Risk'
end as risk_segment
from telco_churn)

Select 
risk_segment,
Count(Customerid) As total_customer,
Sum(Case when churn = 'Yes' Then 1 Else 0 end) Churned,
Round((Sum(Case when churn = 'Yes' Then 1 Else 0 end)*100.0/Count(Churn))::numeric, 2) As Churn_Rate
From Risk_Segments
Group by risk_segment
Order by churn_rate desc;

--Key: High Risk = 67.99% churn, Medium Risk = 43.71%, Low Risk = 11.97%
--Business: This model enables PROACTIVE retention — act before customers decide to leave

--Question 20:

--Using Window Functions, calculate running total revenue ordered by tenure for each customer. Show customerid, tenure, monthlycharges and running total.

Select 
Customerid,
Tenure,
monthlycharges,
Sum(monthlycharges) over (order by tenure) As running_total
from telco_churn
order by tenure;


--Key: Revenue accumulates significantly as customer tenure grows
--Business: Every month a customer stays = compounding revenue — retention pays exponentially

--Question 21:

--Rank customers by their monthly charges using Window Functions. Show rank, customerid, monthlycharges, contract and churn. Show only top 15.


Select 
Rank () Over (Order by monthlycharges Desc) As Rank,
Customerid,
monthlycharges,
Contract,
churn
From Telco_Churn
Limit 15;

--Key: Top paying churned customers all on month-to-month + electronic check
--Business: Highest value lost customers follow a clear pattern — predictable and preventable

-- Question 22:

--Using PARTITION BY, rank customers by monthly charges WITHIN each contract type. Show rank, customerid, contract, monthlycharges and churn.


Select
Rank() over (Partition by  contract order by monthlycharges desc)  As rank,
customerid,
contract,
monthlycharges,
churn
From telco_churn;

--Key: Each contract type has its own top paying customers
--Business: Enables tiered retention strategy — different offers for different contract segments

--Question 23:

--Using NTILE Window Function, divide customers into 4 equal groups (quartiles) based on monthly charges. Show which quartile has highest churn rate.

Select *,
ntile(4) over (order by monthlycharges) as quartiles
From Telco_churn;

--or

With Quartile_data As
(Select *, Ntile(4) over (order by monthlycharges) As quartile
From Telco_Churn)

Select 
quartile,
Count(Customerid) As Total_Customer,
Sum(Case when churn = 'Yes' Then 1 Else 0 end) Churned,
Round((Sum(Case when churn = 'Yes' Then 1 Else 0 end)*100.0/Count(Churn))::numeric, 2) As Churn_Rate
From Quartile_data
Group by Quartile
Order by Quartile;

--Key: Customers split into 4 equal groups by monthly charges
--Business: Quartile 4 (highest paying) losing to churn = maximum revenue impact

--Question 24:

--Find customers whose monthly charges are above the average monthly charges of their contract type. Show customerid, contract, monthlycharges and the contract average.

With Contract_avg_Charges As 
(Select 
Customerid,
COntract,
monthlycharges,
Round(Avg(monthlycharges) over (partition  by contract)::Numeric ,2) as Avg_Contract
From Telco_Churn)

Select * From Contract_avg_charges
Where Monthlycharges > Avg_Contract
order by Contract, monthlycharges Desc;

--Key: Customers paying above their contract group average are high-value targets
--Business: These customers generate more than typical — their churn costs more than average

--Question 25:

--Create a Final Customer Risk Dashboard using CTE. For each customer show their risk segment, quartile, rank within contract type and whether they are above or below contract average.

With Final_dashboard As
(Select 
customerid,
contract,
monthlycharges,
churn,
Case when Contract = 'Month-to-month'
And Tenure < 12
And Monthlycharges > 65
then 'High Risk'
When Contract = 'Month-to-month'
And Tenure < 24
Then 'Medium Risk'
Else 'Low Risk'
End As Risk_segment,
Ntile(4) over (order by Monthlycharges) As quartile,
Rank () Over (Partition by contract order by Monthlycharges Desc) As Contract_rank,
Case When monthlycharges > Avg(Monthlycharges) over (Partition by Contract)
Then 'Above Average'9
Else 'Below Average'
End As vs_contract_avg 
From telco_Churn)

Select * From final_dashboard
Order by Contract, Monthlycharges desc
limit 20;	


--Key: Combined risk segment + quartile + rank + avg comparison in ONE query
--Business: 360° customer view — feed directly into CRM to trigger automated retention workflows


--Top 5 Overall Business Recommendations
--1)Push month-to-month to annual contracts : (Impact =Reduce churn by up to 40%)
--2)Incentivize autopay adoption : (Impact = 3X better retention)
--3)Focus Year 1 onboarding  : (Impact = Prevent 47% new customer loss)
--4)Target senior citizen retention program : (Impact = Fix 2X higher churn rate)
--5)Bundle online security with fiber plans:  (Impact = Cut fiber churn from 42% to 13%)