-- Project - E-Commerce Company

use e_commerce_company;

-- ?? Problem statement ??
-- You can analyze all the tables by describing their contents.


DESC Customers;
DESC Products;
DESC Orders;
DESC OrderDetails;

-- ?? Problem statement ??
-- Identify the top 3 cities with the highest number of customers to determine key markets
-- for targeted marketing and logistic optimization.

select location, count(*) as number_of_customers
from customers 
group by location
order by number_of_customers desc
limit 3;

-- ?? Problem statement ??
-- Determine the distribution of customers by the number of orders placed. This insight will help in segmenting customers into 
-- one-time buyers, occasional shoppers, and regular customers for tailored marketing strategies.

with cte_1 as (select   count(*) as numberoforders
from orders
group by customer_id)

select numberoforders, count(*) as customercount
from cte_1
group by numberoforders
order by numberoforders asc;

-- ?? Problem statement ??
-- Identify products where the average purchase quantity per order is 2 but with a high total revenue, suggesting premium product trends.

select product_id, avg(quantity) as avgquantity, sum(quantity*price_per_unit) as totalrevenue
from orderdetails
group by product_id
having avg(quantity) = 2
order by totalrevenue desc;

-- ?? Problem statement ??
-- For each product category, calculate the unique number of customers purchasing from it. This will help 
-- understand which categories have wider appeal across the customer base.

select a.category, count( distinct c.customer_id) as unique_customers
from products a
join orderdetails b on a.product_id = b.product_id
join orders c on b.order_id = c.order_id;

-- ?? Problem statement ??
-- Analyze the month-on-month percentage change in total sales to identify growth trends.

with cte_1 as (select date_format(order_date, "%Y-%m") as "month" , sum(total_amount) as totalsales
from orders
group by month
),

 cte_2 as (select *, lag(totalsales,1) over(order by month asc) as previous
from cte_1)

select month, totalsales, round((totalsales-previous)/previous*100.0,2) as percentagechange
from cte_2
order by month asc;

-- ?? Problem statement ??
-- Examine how the average order value changes month-on-month. Insights can guide pricing and promotional 
-- strategies to enhance order value.

with cte_1 as(select date_format(order_date, "%Y-%m") as "month",  round(avg(total_amount),2) as avgordervalue
from orders
group by month),

cte_2 as(select *, lag(avgordervalue,1) over(order by month asc) as prev
from cte_1)

select month, avgordervalue, (avgordervalue-prev) as changeinvalue
from cte_2
order by changeinvalue desc;

-- ?? Problem statement ??
-- Based on sales data, identify products with the fastest turnover rates, suggesting high demand and the need for frequent restocking

SELECT
    product_id,
    -- Count the occurrences in OrderDetails and use the exact alias
    COUNT(order_id) AS SalesFrequency
FROM
    OrderDetails
GROUP BY
    product_id
ORDER BY
    SalesFrequency DESC -- Sort by highest frequency
LIMIT 5; -- Show only the top 5

-- ?? Problem statement ??
-- List products purchased by less than 40% of the customer base, indicating potential mismatches between inventory and customer interest.

select p.product_id, p.name, count(distinct o.customer_id) as uniquecustomercount
from products p 
join orderdetails od on p.product_id = od.product_id
join orders o on od.order_id = o.order_id
group by p.product_id, p.name 
having uniquecustomercount < (select count(*) from customers)*0.40;

-- ?? Problem statement ??
-- Evaluate the month-on-month growth rate in the customer base to understand the effectiveness of marketing campaigns 
-- and market expansion efforts.

with cte_1 as
( select date_format(min(order_date),"%Y-%m") as firstpurchasemonth, count(distinct customer_id) as newcustomers
from orders
group by customer_id)

select firstpurchasemonth, sum(newcustomers) as totalnewcustomers
from cte_1
group by firstpurchasemonth
order by firstpurchasemonth;

-- ?? Problem statement ??
-- Identify the months with the highest sales volume, aiding in planning for stock levels, marketing efforts, 
-- and staffing in anticipation of peak demand periods.

select date_format(order_date, "%Y-%m") as month, sum(total_amount) as totalsales
from orders
group by month
order by totalsales desc
limit 3;
