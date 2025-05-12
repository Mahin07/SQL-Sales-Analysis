# SQL-Sales-Analysis
🎯 Purpose: Analyze a mock retail dataset to derive key sales metrics, identify top products, customer segments, and regional trends.


select * from pizza_sales

-- Check data type 

describe pizza_sales

![image](https://github.com/user-attachments/assets/a7327314-dd33-4deb-bfcc-b5158c85e984)


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

![image](https://github.com/user-attachments/assets/04ad4d0b-ca7b-4e5a-8a27-c57b59bf5330)


-- Average Order Value

select * from pizza_sales
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value FROM pizza_sales;

![image](https://github.com/user-attachments/assets/dd432cf1-edf6-4611-ab07-32802fe01020)


-- Total Orders

select count(distinct order_id) AS Total_orders from pizza_sales

![image](https://github.com/user-attachments/assets/58bf2305-c8b0-4a7b-bbff-a919b2594191)

-- Total Pizzas Sold

select sum(quantity) AS Total_Pizza_Sold from pizza_sales

![image](https://github.com/user-attachments/assets/a25216a3-8c74-40f4-b5df-dd8914b93880)


-- Average Pizzas per order

select cast(cast(sum(quantity) AS decimal(10,2))/ cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) AS Total_Pizza_Sold from pizza_sales

![image](https://github.com/user-attachments/assets/67196312-8821-4f24-ab74-061dc1bc2eb9)


-- Daily Trend For Total Orders

/*
Select DAYNAME(order_date) as order_day, count(distinct order_id) as total_orders from pizza_sales
group by DAYNAME(order_date)
SELECT 
    DAYNAME(order_date) AS order_day, 
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    pizza_sales
GROUP BY 
    WEEKDAY(order_date), DAYNAME(order_date)
ORDER BY 
    WEEKDAY(order_date); 
    */

        SELECT 
    DAYNAME(order_date) AS order_day, 
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    pizza_sales
GROUP BY 
    order_day, WEEKDAY(order_date)
ORDER BY 
    WEEKDAY(order_date);

    ![image](https://github.com/user-attachments/assets/aabd8fb1-2149-4150-b685-54416e78d1a1)

    
-- Monthly Trend For Orders

SELECT 
    monthname(order_date) AS Month_name, 
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    pizza_sales
GROUP BY 
     monthname(order_date)

     ![image](https://github.com/user-attachments/assets/6d62f612-30e6-448a-b990-089f574fe9df)


-- Ordered Way

SELECT monthname(order_date) AS Month_Name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY MONTH(order_date), monthname(order_date)
ORDER BY MONTH(order_date);

![image](https://github.com/user-attachments/assets/357cabae-55ba-4d16-9353-5cbff736e4cb)

-- % of Sales by Pizza Category

SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category

![image](https://github.com/user-attachments/assets/01b08d73-eac8-47f3-a1d8-db1123c372a7)


-- First month

SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales where month(order_date)=1) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
where month(order_date)=1
GROUP BY pizza_category

![image](https://github.com/user-attachments/assets/b32e301a-1c59-4f47-8881-036beec2a19c)


-- % of Sales by Pizza Size

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
Order by PCT DESC

![image](https://github.com/user-attachments/assets/43584d53-c476-42f3-8f12-184fc5d30f85)


-- First quarter

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales where quarter(order_date)=1) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
where quarter(order_date)=1
GROUP BY pizza_size
Order by PCT DESC

![image](https://github.com/user-attachments/assets/9aee2b55-628f-4048-b28a-8f81fdf2af34)


--  Total Pizzas Sold by Pizza Category

SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

![image](https://github.com/user-attachments/assets/01bbb46c-ba87-4fa7-810b-2405b8e1686b)


-- Top 5 Pizzas by Revenue (Generic favouritism)

SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
limit 5

![image](https://github.com/user-attachments/assets/3e2759a3-f4ff-441d-89ab-45d85332f9ef)


-- Bottom 5 Pizzas by Revenue

SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue asc
limit 5

![image](https://github.com/user-attachments/assets/1b977cad-497c-43ca-8861-6c6bf8e94817)


-- Top 5 Pizzas by Total Orders(intensity indivdual favouritism indicator)

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
limit 5

![image](https://github.com/user-attachments/assets/00e22db5-5cde-4cbe-972d-11236addf506)



