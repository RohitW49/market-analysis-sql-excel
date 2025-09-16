-- step we performe in Market Analytics SQL project --
-- step 1   Connect to the Database: Use the provided credentials to establish a connection.
-- step 2   Analyze Tables: Review all tables individually. In the orders table, identify blank spaces in the days_since_prior_order column.
-- step 3   Export Tables: Export all tables as CSV files.
-- stpe 4	Clean Data in Excel: Import the orders table into Excel and fill blank spaces with a random value (e.g., 1212) using the "Transform Data" feature.
-- step 5	Import Tables into SQL Workbench: Re-import all cleaned tables into SQL Workbench.
-- step 6	continue project

SELECT user_id, COUNT(user_id) AS count FROM orders GROUP BY user_id HAVING COUNT(user_id) > 1;

show databases;
use project_orders;
select * from aisles;
select * from departments;
select * from order_products_train;
select * from orders;
select * from products;
select avg(days_since_prior_order) from orders;
SET SQL_SAFE_UPDATES = 1;
update orders set days_since_prior_order = 10 where days_since_prior_order = 1212;
update orders set order_hour_of_day = 1 where order_hour_of_day = 0 ;
SET SQL_SAFE_UPDATES = 0;


-- task 1
-- What are the top 10 aisles with the highest number of products?

select 
	aisle ,count(product_id) as product_count 
from 
	products 
inner join 
	aisles on products.aisle_id = aisles.aisle_id 
group by 
	aisle 
order by 
	product_count desc limit 10;


-- task 2
--  How many unique departments are there in the dataset?

select 
	count(distinct department_id) as unique_departments 
from 
	departments;


-- task 3
--  What is the distribution of products across departments?

select 
	department, count(product_id) as product_count 
from 
	products 
inner join 
	departments on products.department_id = departments.department_id 
group by 
	department order by product_count desc;


-- task 4
-- What are the top 10 products with the highest reorder rates?

select 
	product_name , avg(reordered) as reorder_rate 
from 
	order_products_train
inner join
	products on products.product_id = order_products_train.product_id 
group by 
	product_name 
order by 
	reorder_rate desc limit 10 ;


-- task 5
--  How many unique users have placed orders in the dataset?

select 
	count(distinct user_id) 
as 
	unique_user
from 
	orders;


-- task 6
 -- What is the average number of days between orders for each user?

select 
	 user_id, avg(days_since_prior_order) as avg_days_between_orders
from 
	orders 
group by 
	user_id 
order by
	avg_days_between_orders desc;


-- task 7
-- What are the peak hours of order placement during the day?
select 
	order_hour_of_day, count(order_id) as order_count
from 
	orders 
group by 
	order_hour_of_day 
order by 
	order_count desc;


-- task 8 --
--  How does order volume vary by day of the week?

select 
	order_dow , count(order_id) order_count 
from 
	orders 
group by 
	order_dow 
order by 
	order_count desc;


-- task 9
-- What are the top 10 most ordered products?

select 
	product_name , count(order_id) as order_count 
from
	order_products_train 
inner join	
	products on order_products_train.product_id = products.product_id
group by 
	product_name 
order by 
	order_count desc limit 10;
    
    
-- task 10
-- How many users have placed orders in each department?

select 
	department, count(distinct orders.user_id) as user_count
from
	orders
inner join
	order_products_train on orders.order_id = order_products_train.order_id
inner join 
	products on  order_products_train.product_id = products.product_id
inner join 
	departments on products.department_id = departments.department_id 
group by 
	department order by user_count desc;


-- task 11 
--  What is the average number of products per order?

select avg(product_count) as avg_products_per_order
from(
	select order_id, count( product_id) as product_count
    from order_products_train
    group by order_id
) as subquery;


-- task 12
-- What are the most reordered products in each department?

select 
	department,product_name, sum(reordered) as reorder_count 
from 
	order_products_train 
inner join 
	products on order_products_train.product_id = products.product_id
inner join 
	departments on products.department_id = departments.department_id
group by 
	department, product_name 
order by 
	department, reorder_count desc;


-- How many products have been reordered more than once?
-- task 13
select 
	count(distinct product_id) as product_reordered_more_than_one 
from 
	order_products_train 
where 
	reordered > 1;
    
    
-- task 14
-- What is the average number of products added to the cart per order?
select 
	avg(add_to_cart_order) as avg_cart_per_order
from 
	order_products_train;


-- task 15 --
-- How does the number of orders vary by hour of the day?

select 
	order_hour_of_day, count(order_id) as order_count 
from 
	orders 
group by 
	order_hour_of_day 
order by
	order_hour_of_day;


-- task 16
--  What is the distribution of order sizes (number of products per order)?

select product_count, count(order_id) as order_size
from (
		select order_id, count(product_id) as product_count
        from order_products_train
        group by order_id
	 ) as subquery group by product_count;


-- task 17
-- What is the average reorder rate for products in each aisle?

select 
	aisle, avg(reordered) as avg_reorder_rate 
from 
	order_products_train 
inner join 
	products on order_products_train.product_id = products.product_id
inner join 
	aisles on products.aisle_id = aisles.aisle_id
group by 
	aisle 
order by 
	avg_reorder_rate desc;
    
    
-- task 18
--  How does the average order size vary by day of the week?

select order_dow, avg(product_count) as avg_order_size
from (
		select orders.order_id, count(product_id) as product_count, order_dow
        from order_products_train
        inner join orders on order_products_train.order_id = orders.order_id
        group by order_id, order_dow
	  ) as subquery
	group by order_dow
    order by order_dow;


-- task 19
-- What are the top 10 users with the highest number of orders?

select 
	user_id, count(order_id) as order_count 
from 
	orders 
group by 
	user_id 
order by 
	order_count desc limit 10;



-- task 20
-- How many products belong to each aisle and department?

select aisle, department, COUNT(product_id) as product_count
from products
inner join aisles on products.aisle_id = aisles.aisle_id
inner join departments on products.department_id = departments.department_id
group by  aisle, department
order by product_count desc;