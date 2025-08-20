--Sql Retail Sales Analysis - p1
create database sql_project_p2;
USE sql_project_p2; 

---CREATE TABLES

DROP TABLE IF EXISTS retail_sales;
create table retail_sales(
               transactions_id int PRIMARY KEY,
			   sale_date DATE,
			   sale_time TIME,	
			   customer_id INT,	
			   gender VARCHAR(15),	
			   age INT,
			   category VARCHAR(15),	
			   quantiy INT,
			   price_per_unit FLOAT,
			   cogs FLOAT,
			   total_sale FLOAT
			   );
 
 USE sql_project_p2;
GO

EXEC sp_rename 'dbo.retail_sales.quantiy', 'quantity', 'COLUMN';


---data cleaning
SELECT * FROM retail_sales
where transactions_id is null
			  or sale_date is null
			  or sale_time is null
			  or customer_id is null	
			  or gender is null
			  or age is null
			  or category is null	
			  or quantity is null
			  or price_per_unit is null
			  or cogs is null
			  or total_sale is null;


select count(*) from retail_sales;

delete from retail_sales
where transactions_id is null
			  or sale_date is null
			  or sale_time is null
			  or customer_id is null	
			  or gender is null
			  or age is null
			  or category is null	
			  or quantity is null
			  or price_per_unit is null
			  or cogs is null
			  or total_sale is null;

---data exploration

--how many sale we have
select count(*) as total_sale from retail_sales

--- how many unique customers we have?

select count(distinct customer_id) as total_sale from retail_sales

select distinct category  from retail_sales

---Data Analysis and business key problems

---1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'?

select * from retail_sales
where sale_date = '2022-11-05'

---Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
  and quantity >=4

---Q3.Write a SQL query to calculate the total sales (total_sale) for each category.:

select category,
sum(total_sale) as net_sale, count(*) as total_orders
from retail_sales
group by category

--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select AVG(age) as avg_age,category from retail_sales
where category = 'Beauty'
group by category

--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale > 1000

--Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select category,gender,count(*) as total_trans
from retail_sales
group by category,gender
order by category

--Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select * from
(
	SELECT 
		YEAR(sale_date) AS year,
		MONTH(sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER ( PARTITION BY YEAR(sale_date)
					ORDER BY AVG(total_sale) DESC
					) AS sales_rank
	FROM retail_sales
	GROUP BY YEAR(sale_date), MONTH(sale_date)
   ---- ORDER BY year, AVG(total_sale) desc
) as t1
where sales_rank = 1

--Q8.**Write a SQL query to find the top 5 customers based on the highest total sales **:

select top 5 customer_id, sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by sum(total_sale);

---Q9.Write a SQL query to find the number of unique customers who purchased items from each category.:

select  category, count(distinct customer_id) as cnt_uniq_cust  
from retail_sales
group by category

---Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

With Hourly_sale
as
(
SELECT *,
       CASE 
           WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
           WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS Shift
FROM retail_sales
)
select shift, 
count(*) as total_orders
from Hourly_sale
group by shift


select Hour(sale_time) from retail_sales