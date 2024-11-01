--1. How many records are in SM-Stores Orders table

select count (*)
from orders;


--2. How many Cities do SM-stores have properties in.
select * from propertyinfo;

select count ("PropertyCity")
from propertyinfo;


--What are the product categories offered by SM’s.
select * from products;

select distinct ("ProductCategory")
from products;


--5. How many products belong to each category.
select * from products;

select "ProductCategory", count(*)
from products
group by "ProductCategory";

--or

select "ProductCategory", count(*) "No of Products"
from products
group by "ProductCategory";


--6. How many orders were placed in each date stated in the orders table.
select * from orders;

select "OrderDate", count(*)
from orders
group by "OrderDate"

select "OrderDate", count(*)
from orders
group by "OrderDate"
order by "OrderDate";


--7A. Can you process the number of orders we had in each year of SM-stores data. In each month for the year 2016
select * from orders;

select extract (year from "OrderDate") as year, count (*)
from orders
group by year;

select extract (year from "OrderDate") as year, count (*) as "No of orders"
from orders
group by year;

--7B ANSWER. Can you process the number of orders we had in each year of SM-stores data. In each month for the year 2016
select extract (month from "OrderDate") as month, count (*)
from orders
where extract (year from "OrderDate") = 2016
group by month
order by month;

--or

select extract (month from "OrderDate") as month, count (*) as "No of Orders"
from orders
where extract (year from "OrderDate") = 2016
group by month
order by month;


--8. Which category is the most frequented in the year 2015.
select * from products;

select "ProductCategory", count(*) as "No of Orders"
from orders
join products
on products."ProductID" = orders."ProductID"
where extract (year from "OrderDate") = 2015
group by "ProductCategory"
limit 1;
 

--Which category has the highest sales in the year 2016.

select "ProductCategory", sum("Quantity" * "Price") as sales
from orders
join products
on products."ProductID" = orders."ProductID"
where extract (year from "OrderDate") = 2016
group by "ProductCategory"
order by sales desc
limit 1;


--10a Which State has the most properties ordered. Return the sales for each state. (sales >25000)

select "PropertyState", count(*)
from orders
join propertyinfo
on propertyinfo."PropID" = orders."PropertyID"
group by "PropertyState"
order by count desc
limit 1;

--OR

select "PropertyState", count("PropID") as Frequency
from orders as o
join propertyinfo as p
on p."PropID" = o."PropertyID"
group by "PropertyState"
order by Frequency desc
limit 1;

-- 10b Return the sales for each state. (sales >25000)

select "PropertyState", sum("Quantity" * "Price") as "Total Sales"
from orders as o
join propertyinfo as p
on p."PropID" = o."PropertyID"
join products
using ("ProductID")
group by "PropertyState"
having sum("Quantity" * "Price") > 25000
order by "Total Sales" desc;


--11. What is the cost of a ‘Coffee Maker’ located in Texas.

select "ProductName", sum("Quantity" * "Price")
from orders o
join products p
on o."ProductID" = p."ProductID"
join propertyinfo pi
on pi."PropID" = o."PropertyID"
where "ProductName" = 'Coffee Maker' and "PropertyState" = 'Texas'
group by "ProductName"


--12. Which month in the year 2015 had the highest sales.

select extract(Month from "OrderDate") as Month, sum("Quantity" * "Price") as "Highest Sales"
from orders
join products
using ("ProductID")
where extract(Year from "OrderDate") = 2015
group by Month
order by "Highest Sales" desc
limit 1;


--13 What are the product categories with a product id spanning 10 to 30.

select "ProductCategory", "ProductID"
from products
where "ProductID" between 10 and 30


--14. How many products start with the letter ‘D’.

select "ProductName"
from products
where "ProductName" like 'D%'


--15. What are the product categories having the letter ‘e’


select distinct "ProductCategory"
from products
where "ProductCategory" like '%e%'


--16. Return all orders where the quantity ordered is above 5.

select *
from orders
where "Quantity" > 5



--17. Find all instances where the product ‘Bed (King)’ was ordered.

select * 
from orders
where "ProductID" in
(select "ProductID"
from products
where "ProductName" = 'Bed (king)')

--or
	
select *
from orders
join products
on orders."ProductID" = products."ProductID"
where "ProductName" = 'Bed (King)'


--18. Find the name and category, property city and state of the product with a productid of 105

select o."ProductID", "ProductName", "ProductCategory", "PropertyCity", "PropertyState"
from orders o
join products p
on o."ProductID" = p."ProductID"
join propertyinfo pi
on pi."PropID" = o."PropertyID"
where o."ProductID" = 105


select distinct "ProductID"
from orders
where "ProductID" = 105


--19. A customer has requested for a refund claiming they procured goods from our store. Provide all the details of this order if the OrderID is = ‘3896’

-- I created a view for all the tables
create view all_tables as
(select *
from orders o
join products p
using ("ProductID")
join propertyinfo pi
on pi."PropID" = o."PropertyID")


select *
from all_tables
where "OrderID" = 3896


--20. Find the name and category of products whose prices ranges from $1 to $50

select "ProductName", "ProductCategory", "Price"
from products
where "Price" between 1 and 50
order by "Price"


--21. Find the number of Permanent Markers, ‘Sticky Notes’ and ‘Note Pads’ ordered for the year 2015. Find all products in the year 2016, where the quantity ordered was greater than 50

select "ProductName", count ("OrderID") as No_of_Orders
from all_tables
where "ProductName" in ('Permanent Markers', 'Sticky Notes', 'Note Pads') and extract (Year from "OrderDate") = 2015
group by "ProductName"


--22. SM-stores wants to re-evaluate the prices of their goods, provide a list of their products, categories and the corresponding prices. Group their products into cheap(<50), affordable(<100), expensive.

select *,
case
	when "Price" <=50 then 'Cheap'
	when "Price" <=100 then 'Affordable'
	else 'Expensive'
end as "Price Category"
from products


