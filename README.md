# Restaurant Order Analysis

## 📋 Overview
This project explores and analyzes the `restaurant_db` database to extract meaningful insights into the restaurant's menu, orders, and related data. It includes database creation, metadata, and exploratory SQL queries to address specific business questions.

## 🎯 Objectives
1. **Menu Exploration**  
   - Determine the total number of menu items.  
   - Identify the least and most expensive items on the menu.  
   - Analyze category-specific details, such as the number of Italian dishes.  

2. **Customer and Order Insights**  
   - Evaluate popular menu items based on order frequency.  
   - Identify the busiest times and peak order periods.  
   - Assess customer spending trends.
     
3. **Analyze customer behavior**
   - What were the least and most ordered items? What categories were they in?
   - What were the top 5 orders that spent the most money?
   - View the details of the highest spend order. Which specific items were purchased?
   - View the details of the top 5 highest spend orders.

## 📂 File Structure
### Files Included
1. **`create_restaurant_db.sql`**  
   - Defines the schema for the `restaurant_db` database.  
   - Contains scripts to create tables (`menu_items`, `order_details`, etc.) and populate them with sample data.

2. **`restaurant_db_data_dictionary.xlsx`**  
   - Metadata about the database structure and column descriptions for all tables.

3. **`Restaurant Order Analysis.sql`**  
   - SQL queries for analysis, organized by objectives and topics.
---

## Most of SQL Queries for Restaurant Database Analysis: Menu Exploration, Order Trends, and Customer Insights

### 1. Combine the menu_items and order_details tables into a single table
```sql
CREATE VIEW order_menus AS 
SELECT orders.order_id, orders.order_details_id, orders.order_date, orders.order_time, 
       orders.item_id, menu.item_name, menu.category, menu.price
FROM order_details AS orders
LEFT JOIN menu_items AS menu ON menu.menu_item_id = orders.item_id;
```

### 2. What is the most and lowest selling Item for each Category?
```sql
WITH item_category AS (
    SELECT category, item_name, COUNT(item_id) AS num_item,
           MAX(COUNT(item_id)) OVER (PARTITION BY category) AS max_num,
           MIN(COUNT(item_id)) OVER (PARTITION BY category) AS min_num,
           price
    FROM order_menus
    GROUP BY category, item_name, price
    ORDER BY category ASC, 3 DESC
)
SELECT category, item_name, num_item, price
FROM item_category
WHERE max_num = num_item OR min_num = num_item;
```

### 3. View the details of the top 5 highest spend orders
```sql
SELECT order_id, category, COUNT(order_details_id) AS num_items, 
       ROUND(AVG(price), 2) AS avg_price
FROM order_menus
WHERE order_id IN (
    SELECT order_id
    FROM (
        SELECT order_id, SUM(price) AS total_price
        FROM order_menus
        GROUP BY order_id
        ORDER BY 2 DESC LIMIT 5
    ) AS highest_orders
)
GROUP BY category, order_id
ORDER BY 1 ASC, 3 DESC, 2 ASC;
```

### 4. View the details of the highest spend order. Which specific items were purchased?
```sql
SELECT category, COUNT(category) AS num_cate
FROM order_menus
WHERE order_id IN (
    SELECT order_id
    FROM (
        SELECT order_id, SUM(price) AS num_item_in_order
        FROM order_menus
        GROUP BY order_id
        ORDER BY 2 DESC LIMIT 1
    ) AS highest_order
)
GROUP BY category
ORDER BY 2 DESC;
```

### 5. What were the least and most ordered items? What categories were they in?
```sql
(
    SELECT item_name, category, COUNT(order_details_id) AS num_items
    FROM order_menus
    GROUP BY item_name, category
    ORDER BY num_items DESC
    LIMIT 1
)
UNION
(
    SELECT item_name, category, COUNT(order_details_id) AS num_items
    FROM order_menus
    GROUP BY item_name, category
    ORDER BY num_items ASC
    LIMIT 1
);
```

### 6. Which orders had the most number of items?
```sql
SELECT order_id, COUNT(item_id) AS num_ordered_item
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) >= (
    SELECT MAX(num_ordered_item) FROM (
        SELECT order_id, COUNT(item_id) AS num_ordered_item FROM order_details GROUP BY order_id
    ) AS mni
);
```

### 7. How many orders had more than 12 items?
```sql
SELECT COUNT(num_ordered_item) AS count_orders
FROM (
    SELECT order_id, COUNT(item_id) AS num_ordered_item
    FROM order_details
    GROUP BY order_id
    HAVING COUNT(item_id) > 12
) AS mni;
```
---  

## 🚀 Getting Started
1. **Set Up the Database**  
   - Execute the `create_restaurant_db.sql` script to create and populate the `restaurant_db`.

2. **Review the Metadata**  
   - Open the `restaurant_db_data_dictionary.xlsx` to understand the structure of the tables.

3. **Run the Analysis**  
   - Use the `Restaurant Order Analysis.sql` file to explore the database and generate insights.

## 📊 Key Insights
1. **Top and Lowest-Selling Items**
   - Over the past three months, the best-selling item was the 'Hamburger', while the lowest-selling item was 'Chicken Tacos'.
   - Although 'Chicken Tacos' is among the cheaper items, it was sold only **123** times, raising a concern about its taste or customer preference.
   - Another 'Mexican' dish, the 'Steak Torta', sold **489** times, suggesting the issue might be specific to the 'Chicken Tacos' recipe.

2. **Demand for Italian Cuisine**
   - 'Italian' food consistently ranked as the most popular choice among high-spending customers, while 'Asian' food was the least popular.
   - Despite higher prices, 'Italian' dishes were preferred by wealthier customers, likely due to their perceived luxury or superior taste.
   - The 'Cheese Lasagna', one of the more affordable 'Italian' dishes, sold **207** times less than other premium 'Italian' options, highlighting a preference for specific premium dishes.

3. **Top Five Orders Breakdown**
   - Among the top five orders, 'Italian' food emerged as the most in-demand category, followed by 'Mexican' food, despite its higher price point.

4. **Popularity of Edamame**
   - The 'Edamame' was the second most-sold item, with **620** orders. Its affordability at **$5** significantly contributed to its popularity.

5. **Overall Cuisine Trends**
   - Over three months, 'Asian' food was the most-sold category with **3,470** orders, while 'American' food was the least sold with **2,734** orders.
   - This trend may be due to the lower average price of 'Asian' dishes compared to 'American' cuisine, making them more accessible.

## 🖥️ Technologies Used
- **SQL**: To define, populate, and analyze the database.
- **Excel**: To document metadata and data dictionaries.
---

## Contact

For any queries or suggestions, feel free to reach out:  
**Bahaa Medhat Wanas**  
- LinkedIn: [Bahaa Wanas](https://www.linkedin.com/in/bahaa-wanas-9797b923a)  
- Email: [bahaawanas427@gmail.com](mailto:bahaawanas427@gmail.com)
---
