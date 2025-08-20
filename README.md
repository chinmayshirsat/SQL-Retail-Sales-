# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p2`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p2`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
 
---changing the column name 
EXEC sp_rename 'dbo.retail_sales.quantiy', 'quantity', 'COLUMN';
```

### 2. Data Cleaning and Exploration 

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql

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

--- Data Exploration

--how many sale we have
select count(*) as total_sale from retail_sales;

--- how many unique customers we have?
select count(distinct customer_id) as total_sale from retail_sales;

select distinct category  from retail_sales;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
  and quantity >=4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category,
sum(total_sale) as net_sale, count(*) as total_orders
from retail_sales
group by category
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select AVG(age) as avg_age,category from retail_sales
where category = 'Beauty'
group by category
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_sales
where total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select category,gender,count(*) as total_trans
from retail_sales
group by category,gender
order by category
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select top 5 customer_id, sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by sum(total_sale);
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select  category, count(distinct customer_id) as cnt_uniq_cust  
from retail_sales
group by category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

