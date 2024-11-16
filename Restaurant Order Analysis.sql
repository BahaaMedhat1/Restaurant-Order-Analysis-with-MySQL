use restaurant_db; -- select the database we will work on.


-- Objective 1: Explore the items table.

select   -- View the menu_items Table.
	*
from
	menu_items;

    
-- 1. Find the number of items on the menu.
select 
	count(item_name) as num_items
from
	menu_items; -- so we have 32 items in our menu.
    
    
    
    
-- 2. What are the least and most exspensive Item in the menu?
(
select    
	item_name,
	category,
    price
from
	menu_items
order by 
	price desc
limit 1
)
UNION
(
select    
	item_name,
    category,
    price
from
	menu_items
order by 
	price asc
limit 1
);  -- The Italian has the most expensive item 'Shrimp Scampi' On the contrary of Asian.  
    
    
    
    
-- 3. How many Italian dishes in the Menu?
select  
	count(category) as num_italian_dishes
from
	menu_items
where
	category = "Italian"; -- we have many Italian dishes in our Menu.
    
    

-- 4. What are the least and most expensive Italian dishes on the menu?
(
select  
	item_name,
    category,
    price
from
	menu_items
where
	category = "Italian"
order by 
	price desc 
limit 1
)
UNION
(
select 
	item_name,
    category,
    price
from
	menu_items
where
	category = "Italian"
order by 
	price asc 
limit 1
); -- The most expensive is 'Shrimp Scampi' and cheapest is 'Spaghetti' in Italian dishes.
    
    


-- 5. How many dishes in each category dishes in the menu?
select 
	category,
    count(item_name) as num_item
from
	menu_items
group by 
	category
order by 
	2 desc, 1 asc;
    


-- 6. What is the Average Dishes price within each Category?
select 
	category,
    round(avg(price), 2) as avg_price
from
	menu_items
group by 
	category
order by 
	2 desc, 1 asc; -- As Always the Italain Dishes has the highest avgerage price.
    
-- *************************************************************************************************




-- Objective 2: Explore the orders table.

select  -- View the Order_details table.
	*
from
	order_details
order by item_id;  -- We could see here null Values in item_id column and these row won't help us anyway.




delete from order_details -- Removing NULL Values.
where item_id is null;




-- 1. What is the DATE range of the table?
select
	min(order_date),
    max(order_date)
from
	order_details; -- This mean we are analyzing the sales of first Quarter.
    
    
    
    
-- 2. How many orders were made within this date range? 
select
	count(DISTINCT order_id) as num_of_orders
from
	order_details; -- the Restaurant had made 5343 order in three months.
    
    
    
    
-- 3. How many items were ordered within this date range?
select
	count(order_details_id) as num_orderd_item
from
	order_details; -- in this 5343 order the restaurant sell around 12100 item from their menu.
    
    
    
    
-- 4. Which orders had the most number of items?
select
	order_id,
    count(item_id) as num_ordered_item
from
	order_details
group by 
	order_id
having 
	count(item_id) >= (select max(num_ordered_item )from ( select order_id, count(item_id) as num_ordered_item from order_details group by order_id) as mni);




-- 5. How many orders had more than 12 items?
select 
	count(num_ordered_item) as count_orders
from 
( 
	select  order_id, count(item_id) as num_ordered_item 
	from order_details 
	group by order_id
	HAVING count(item_id) > 12) as mni;

-- **************************************************************************************************




-- Objective 3: Analyze customer behavior

-- 1. Combine the menu_items and order_details tables into a single table.
Create VIEW order_menus as 
Select
	orders.order_id,
    orders.order_details_id,
    orders.order_date,
    orders.order_time,
    orders.item_id,
    menu.item_name,
    menu.category,
    menu.price
from
	order_details as orders
left join
	menu_items as menu
on
	menu.menu_item_id = orders.item_id;
    
    
    
    
-- 2. What were the least and most ordered items? What categories were they in?
(
select
	item_name,
    category,
    count(order_details_id) as num_items
from
	order_menus
GROUP BY 
	item_name,
	category
order by 
	num_items desc
limit 1
)
UNION
(
select
	item_name,
    category,
    count(order_details_id) as num_items
from
	order_menus
GROUP BY 
	item_name,
    category
order by 
	num_items asc
limit 1
);  -- This means that the is the 'Hamburger' is the most favorite food for customers, unlike the 'Chicken Tacos'.




-- 3. View the details of the highest spend order. Which specific items were purchased?
select 
	category,
    count(category) as num_cate
from
	order_menus
where
	order_id in ( select order_id
				  from (
					select order_id, sum(price) as num_item_in_order
					from order_menus
					group by order_id
					order by 2 desc limit 1) as highest_order)
group by 
	category
order by 
	2 desc; -- I think the Italian food is more popular in this menu.





-- 3. What were the top 5 orders that spent the most money?
select
	order_id,
    sum(price) as total_price
from
	order_menus
group by 
	order_id
order by
	2 desc
limit 5; -- Now we will use these 'order_id' to analyze the details of orders to explore what is the most item was bought.




-- 5. View the details of the top 5 highest spend orders.
select 
	order_id,
    category,
    count(order_details_id) as num_items,
    round(avg(price), 2)as avg_price
from
	order_menus
where
	order_id in ( select order_id
				  from(
						select order_id, sum(price) as total_price
						from order_menus
						group by order_id
						order by 2 desc  limit 5
					  ) highest_orders)
group by
	category, order_id
order by 1 asc, 3 desc, 2 asc; -- As we can see in every order of the top 5 highest spend orders , 'Italian' food is the most in demand.




-- 6. How many orders for each category was ordered?
select
	category,
    count(order_details_id) as num
from
	order_menus
group by 
	category
order by 
	num desc; -- The 'Asian' Food is on the Top.
    
    
    
    
-- 8. What is the most and lowest selling Item for each Category?
with item_category as (
select
	category,
    item_name,
    count(item_id) as num_item,
    max(count(item_id)) over (partition by category) as max_num,
    min(count(item_id)) over (partition by category) as min_num,
    price
from
	order_menus
group by 
	category, item_name, price
order by 
	category asc, 3 desc)
select
	category,
    item_name,
    num_item,
    price
from
	item_category
where
	max_num = num_item
    or min_num = num_item;
    
    
    
/*
------------------------------------------------------------------------------------------------------------
-- Now, let's organize our insights and analyze why these patterns emerged:

1. Top and Lowest-Selling Items:
		- Over the past three months, the best-selling item was the 'Hamburger', while the lowest-selling item was 'Chicken Tacos'.
		- Although 'Chicken Tacos' is among the cheaper items, it was sold only '123' times, which raises a concern.
          This may indicate an issue with its taste or that customers are less inclined toward certain 'Mexican' dishes.
		- However, it’s worth noting that another 'Mexican' dish, the 'Steak Torta', sold '489' times. 
          This suggests the problem might be specific to the 'Chicken Tacos' recipe rather than 'Mexican' food overall.

2. Demand for Italian Cuisine:
		- When analyzing the highest-spending orders, 'Italian' food consistently ranked as the most popular choice, while 'Asian' food was the least popular.
		- Despite its higher prices, 'Italian' dishes seem to be favored by customers, particularly those who place larger or more expensive orders. 
          This behavior suggests that wealthier customers tend to prefer 'Italian' cuisine, likely perceiving it as more luxurious or aligning with their taste preferences.
		- Interestingly, these customers showed little interest in 'Asian' food, despite its generally lower price point.
          This indicates that affordability alone is not the main driver of their choices.
		- However, it's worth noting that the 'Cheese Lasagna', one of the more affordable 'Italian' dishes, was sold '207' times less than other 'Italian' options.
          This reinforces the idea that customers' preferences lean toward specific premium 'Italian' dishes rather than being price-sensitive.
          
3. Top Five Orders Breakdown:
		- Among the top five orders, 'Italian' food emerged as the most in-demand category,
          followed by 'Mexican' food, even though 'Mexican' dishes tend to be priced higher.
          
4. Popularity of Edamame:
		- The 'Edamame' was the second most-sold item over three months, with '620' orders.
          Its affordability, priced at just '$5', likely contributed significantly to its popularity.
          
5. Overall Cuisine Trends:
		- Over the three months, 'Asian' food was the most-sold category, with '3,470' orders, 
          while 'American' food was the least sold, with '2,734' orders.
		- This trend could be attributed to the lower average price of 'Asian' dishes compared to 'American' cuisine, 
          making them more accessible to a broader range of customers.

---------------------------------------------------------------------------------------------------------------------
*/
    
    
    
    
    
    
    
    
    
    
    
    