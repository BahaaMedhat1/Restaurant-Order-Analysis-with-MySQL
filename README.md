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

## 📂 File Structure
### Files Included
1. **`create_restaurant_db.sql`**  
   - Defines the schema for the `restaurant_db` database.  
   - Contains scripts to create tables (`menu_items`, `order_details`, etc.) and populate them with sample data.

2. **`restaurant_db_data_dictionary.xlsx`**  
   - Metadata about the database structure and column descriptions for all tables.

3. **`Restaurant Order Analysis.sql`**  
   - SQL queries for analysis, organized by objectives and topics.

## 🛠️ Prerequisites
To run this analysis, you'll need:
- A SQL database environment (e.g., MySQL or PostgreSQL).
- Basic knowledge of SQL for executing and modifying queries.
- Import the database using `create_restaurant_db.sql`.

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

## 📖 Learnings
- Query optimization techniques for analyzing relational databases.
- Structured methods to derive business insights using SQL.
- Comprehensive exploration of restaurant operations via data.

## 📢 Contribution
Feel free to fork this repository, improve the analysis, or expand it to include additional business questions. Pull requests are welcome!
