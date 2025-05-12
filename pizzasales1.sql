select * from pizza_sales

-- Check data type 

describe pizza_sales

-- Fix data type

UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');
alter table pizza_sales
modify column order_date date;

describe pizza_sales

UPDATE pizza_sales
SET order_time = STR_TO_DATE(order_time, '%H:%i:%s');
alter table pizza_sales
modify column order_time time;

-- Total Revenue

Select sum(total_price) as Total_Revenue from pizza_sales

-- Average Order Value

select * from pizza_sales
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value FROM pizza_sales;

-- Total Orders

select count(distinct order_id) AS Total_orders from pizza_sales

-- Total Pizzas Sold

select sum(quantity) AS Total_Pizza_Sold from pizza_sales

-- Average Pizzas per order

select cast(cast(sum(quantity) AS decimal(10,2))/ cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) AS Total_Pizza_Sold from pizza_sales

-- Daily Trend For Total Orders

-- Select DAYNAME(order_date) as order_day, count(distinct order_id) as total_orders from pizza_sales
-- group by DAYNAME(order_date)
-- SELECT 
--     DAYNAME(order_date) AS order_day, 
--     COUNT(DISTINCT order_id) AS total_orders
-- FROM 
--     pizza_sales
-- GROUP BY 
--     WEEKDAY(order_date), DAYNAME(order_date)
-- ORDER BY 
--     WEEKDAY(order_date);
    
    SELECT 
    DAYNAME(order_date) AS order_day, 
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    pizza_sales
GROUP BY 
    order_day, WEEKDAY(order_date)
ORDER BY 
    WEEKDAY(order_date);

    
-- Monthly Trend For Orders

SELECT 
    monthname(order_date) AS Month_name, 
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    pizza_sales
GROUP BY 
     monthname(order_date)

-- Ordered Way

SELECT monthname(order_date) AS Month_Name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY MONTH(order_date), monthname(order_date)
ORDER BY MONTH(order_date);

-- % of Sales by Pizza Category

SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category

-- First month

SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales where month(order_date)=1) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
where month(order_date)=1
GROUP BY pizza_category

-- % of Sales by Pizza Size

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
Order by PCT DESC

-- First quarter

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales where quarter(order_date)=1) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
where quarter(order_date)=1
GROUP BY pizza_size
Order by PCT DESC

--  Total Pizzas Sold by Pizza Category

SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

-- Top 5 Pizzas by Revenue (Generic favouritism)

SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
limit 5

-- Bottom 5 Pizzas by Revenue

SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue asc
limit 5

-- Top 5 Pizzas by Total Orders(intensity indivdual favouritism indicator)

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
limit 5
