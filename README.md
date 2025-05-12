
# SQL Sales Analysis

🎯 **Purpose:** Analyze a mock retail dataset to derive key sales metrics, identify top products, customer segments, and regional trends.

---

## Checking Data

```sql
SELECT * FROM pizza_sales;
```

![image](https://github.com/user-attachments/assets/a7327314-dd33-4deb-bfcc-b5158c85e984)

---

## Fix Data Types

```sql
-- Convert order_date
UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

ALTER TABLE pizza_sales
MODIFY COLUMN order_date DATE;

-- Convert order_time
UPDATE pizza_sales
SET order_time = STR_TO_DATE(order_time, '%H:%i:%s');

ALTER TABLE pizza_sales
MODIFY COLUMN order_time TIME;
```

---

## Total Revenue

```sql
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales;
```

![image](https://github.com/user-attachments/assets/04ad4d0b-ca7b-4e5a-8a27-c57b59bf5330)

---

## Average Order Value

```sql
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value FROM pizza_sales;
```

![image](https://github.com/user-attachments/assets/dd432cf1-edf6-4611-ab07-32802fe01020)

---

## Total Orders

```sql
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;
```

![image](https://github.com/user-attachments/assets/58bf2305-c8b0-4a7b-bbff-a919b2594191)

---

## Total Pizzas Sold

```sql
SELECT SUM(quantity) AS Total_Pizza_Sold FROM pizza_sales;
```

![image](https://github.com/user-attachments/assets/a25216a3-8c74-40f4-b5df-dd8914b93880)

---

## Average Pizzas per Order

```sql
SELECT CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS Avg_Pizzas_Per_Order
FROM pizza_sales;
```

![image](https://github.com/user-attachments/assets/67196312-8821-4f24-ab74-061dc1bc2eb9)

---

## Daily Trend for Total Orders

```sql
SELECT
    DAYNAME(order_date) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    pizza_sales
GROUP BY
    order_day, WEEKDAY(order_date)
ORDER BY
    WEEKDAY(order_date);
```

![image](https://github.com/user-attachments/assets/aabd8fb1-2149-4150-b685-54416e78d1a1)

---

## Monthly Trend for Orders

```sql
SELECT
    MONTHNAME(order_date) AS Month_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    pizza_sales
GROUP BY
    MONTHNAME(order_date);
```

![image](https://github.com/user-attachments/assets/6d62f612-30e6-448a-b990-089f574fe9df)

---

## Monthly Trend (Ordered Way)

```sql
SELECT
    MONTHNAME(order_date) AS Month_Name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM
    pizza_sales
GROUP BY
    MONTH(order_date), MONTHNAME(order_date)
ORDER BY
    MONTH(order_date);
```

![image](https://github.com/user-attachments/assets/357cabae-55ba-4d16-9353-5cbff736e4cb)

---

## % of Sales by Pizza Category

```sql
SELECT
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM
    pizza_sales
GROUP BY
    pizza_category;
```

![image](https://github.com/user-attachments/assets/01b08d73-eac8-47f3-a1d8-db1123c372a7)

---

## First Month Sales % by Category

```sql
SELECT
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date) = 1) AS DECIMAL(10,2)) AS PCT
FROM
    pizza_sales
WHERE
    MONTH(order_date) = 1
GROUP BY
    pizza_category;
```

![image](https://github.com/user-attachments/assets/b32e301a-1c59-4f47-8881-036beec2a19c)

---

## % of Sales by Pizza Size

```sql
SELECT
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM
    pizza_sales
GROUP BY
    pizza_size
ORDER BY
    PCT DESC;
```

![image](https://github.com/user-attachments/assets/43584d53-c476-42f3-8f12-184fc5d30f85)

---

## First Quarter Sales % by Size

```sql
SELECT
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE QUARTER(order_date) = 1) AS DECIMAL(10,2)) AS PCT
FROM
    pizza_sales
WHERE
    QUARTER(order_date) = 1
GROUP BY
    pizza_size
ORDER BY
    PCT DESC;
```

![image](https://github.com/user-attachments/assets/9aee2b55-628f-4048-b28a-8f81fdf2af34)

---

## Total Pizzas Sold by Category (Feb)

```sql
SELECT
    pizza_category,
    SUM(quantity) AS Total_Quantity_Sold
FROM
    pizza_sales
WHERE
    MONTH(order_date) = 2
GROUP BY
    pizza_category
ORDER BY
    Total_Quantity_Sold DESC;
```

![image](https://github.com/user-attachments/assets/01bbb46c-ba87-4fa7-810b-2405b8e1686b)

---

## Top 5 Pizzas by Revenue

```sql
SELECT
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM
    pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Revenue DESC
LIMIT 5;
```

![image](https://github.com/user-attachments/assets/3e2759a3-f4ff-441d-89ab-45d85332f9ef)

---

## Bottom 5 Pizzas by Revenue

```sql
SELECT
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM
    pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Revenue ASC
LIMIT 5;
```

![image](https://github.com/user-attachments/assets/1b977cad-497c-43ca-8861-6c6bf8e94817)

---

## Top 5 Pizzas by Total Orders

```sql
SELECT
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM
    pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Orders DESC
LIMIT 5;
```

![image](https://github.com/user-attachments/assets/00e22db5-5cde-4cbe-972d-11236addf506)

---

## END

This SQL project analyzes sales trends, product popularity, and customer behavior for a fictional pizza chain using MySQL and visual breakdowns.

