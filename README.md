# SM-STORES SQL CUSTOMER CASE STUDY

## Table of Contents
-	[Project Overview](#project-overview)
-	[Data Source](#data-source)
-	[Tools](#tools)
-	[Objectives](#objectives)
-	[Data Cleaning Preparation](#data-cleaning-preparation)
-	[Exploratory Data Analysis](#exploratory-data-analysis)
-	[Data Analysis](#data-analysis)
-	[Results](#results)
-	[Recommendations](#recommendations)

### Project Overview
**Project Title**: Customer Engagement Analysis.

**Database**: 'SM_Stores_DB'

This data analysis project aims to provide insights into the customer engagement performance of a property company. By analyzing various aspects of the sales data, we seek to identify trends, make data-driven recommendations, and gain a deeper understanding of the company's performance. The project also involves setting up a database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

### Data Source
The primary dataset used for this analysis is the "sales_data.csv" file, containing detailed information about each sale made by the company.

### Tools
- Excel – Data Cleaning.
- PostgreSQL – Data Analysis.

### Objectives
1. **Set up a database**: Create and populate a database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

### Data Cleaning/Preparation 
In the initial data preparation phase, we performed the following tasks:
1. Data loading and inspection.
2. Handling missing values.
3. Data cleaning and formatting.

### Exploratory Data Analysis
EDA involved exploring the sales data to answer key questions, such as:
- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

### Data Analysis
The following SQL queries were developed to answer specific business questions: 

1. How many records are in SM-Stores Orders table?
``` sql
select count (*)
from orders;
```

2. How many Cities do SM-stores have properties in?
```sql
select count ("PropertyCity")
from propertyinfo;
```

3. What are the product categories offered by SM-Stores?
```sql
select distinct ("ProductCategory")
from products;
```

4. How many products belong to each category?
```sql
select "ProductCategory", count(*)
from products
group by "ProductCategory";

--or

select "ProductCategory", count(*) "No of Products"
from products
group by "ProductCategory";
```

5. How many orders were placed on each date stated in the orders table?
```sql
select "OrderDate", count(*)
from orders
group by "OrderDate"

select "OrderDate", count(*)
from orders
group by "OrderDate"
order by "OrderDate";
```

6. Can you process the number of orders we had in each year of SM-stores data. In each month for the year 2016?
```sql
select extract (year from "OrderDate") as year, count (*)
from orders
group by year;

--or

select extract (year from "OrderDate") as year, count (*) as "No of orders"
from orders
group by year;
```

6b. Can you process the number of orders we had in each year of SM-stores data. In each month for the year 2016?
```sql
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
```

7. Which category is the most frequented in the year 2015?
```sql
select "ProductCategory", count(*) as "No of Orders"
from orders
join products
on products."ProductID" = orders."ProductID"
where extract (year from "OrderDate") = 2015
group by "ProductCategory"
limit 1;
```

8. Which category has the highest sales in the year 2016?
```sql
select "ProductCategory", sum("Quantity" * "Price") as sales
from orders
join products
on products."ProductID" = orders."ProductID"
where extract (year from "OrderDate") = 2016
group by "ProductCategory"
order by sales desc
limit 1;
```

9. Which State has the most properties ordered. Return the sales for each state. (sales >25000)?
```sql
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
```

9b. Return the sales for each state. (sales >25000)?
```sql
select "PropertyState", sum("Quantity" * "Price") as "Total Sales"
from orders as o
join propertyinfo as p
on p."PropID" = o."PropertyID"
join products
using ("ProductID")
group by "PropertyState"
having sum("Quantity" * "Price") > 25000
order by "Total Sales" desc;
```

10. What is the cost of a ‘Coffee Maker’ located in Texas?
```sql
select "ProductName", sum("Quantity" * "Price")
from orders o
join products p
on o."ProductID" = p."ProductID"
join propertyinfo pi
on pi."PropID" = o."PropertyID"
where "ProductName" = 'Coffee Maker' and "PropertyState" = 'Texas'
group by "ProductName"
```

11. Which month in the year 2015 had the highest sales?
```sql
select extract(Month from "OrderDate") as Month, sum("Quantity" * "Price") as "Highest Sales"
from orders
join products
using ("ProductID")
where extract(Year from "OrderDate") = 2015
group by Month
order by "Highest Sales" desc
limit 1;
```

12. What are the product categories with a product id spanning 10 to 30?
```sql
select "ProductCategory", "ProductID"
from products
where "ProductID" between 10 and 30;
```

13. How many products start with the letter ‘D’?
```sql
select "ProductName"
from products
where "ProductName" like 'D%';
```

14. What are the product categories having the letter ‘e’?
```sql
select distinct "ProductCategory"
from products
where "ProductCategory" like '%e%';
```

15. Return all orders where the quantity ordered is above 5.
```sql
select *
from orders
where "Quantity" > 5;
```

16. Find all instances where the product ‘Bed (King)’ was ordered.
```sql
select * 
from orders
where "ProductID" in
(select "ProductID"
from products
where "ProductName" = 'Bed (king)');

--or
	
select *
from orders
join products
on orders."ProductID" = products."ProductID"
where "ProductName" = 'Bed (King)';
```

17. Find the name and category, property city and state of the product with a productid of 105.
```sql
select o."ProductID", "ProductName", "ProductCategory", "PropertyCity", "PropertyState"
from orders o
join products p
on o."ProductID" = p."ProductID"
join propertyinfo pi
on pi."PropID" = o."PropertyID"
where o."ProductID" = 105;
```

18. A customer has requested for a refund claiming they procured goods from our store. Provide all the details of this order if the OrderID is = ‘3896’.
```sql
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
where "OrderID" = 3896;
```

19. Find the name and category of products whose prices ranges from $1 to $50.
```sql
select "ProductName", "ProductCategory", "Price"
from products
where "Price" between 1 and 50
order by "Price";
```

20. Find the number of Permanent Markers, ‘Sticky Notes’ and ‘Note Pads’ ordered for the year 2015. Find all products in the year 2016, where the quantity ordered was greater than 50.
```sql
select "ProductName", count ("OrderID") as No_of_Orders
from all_tables
where "ProductName" in ('Permanent Markers', 'Sticky Notes', 'Note Pads') and extract (Year from "OrderDate") = 2015
group by "ProductName";
```

21. SM-stores want to re-evaluate the prices of their goods, provide a list of their products, categories and the corresponding prices. Group their products into cheap(<50), affordable(<100), expensive.
```sql
select *,
case
	when "Price" <=50 then 'Cheap'
	when "Price" <=100 then 'Affordable'
	else 'Expensive'
end as "Price Category"
from products;
```

### Results
The analysis results are summarized as follows:
1. SM Stores are currently operating in about 20 cities across the country.
2. Furnishing seems to be the most active category purchased by customers in SM Stores.
3. California is the state where SM Stores has the most property ordered from customers, which has the highest sales.

### Recommendations
Based on the analysis, we recommend the following actions:
- Focus on expanding and promoting more categories of products in the store.
- Invest in marketing and promotions to expand into other cities across the country.
- SM Stores should invest in marketing to improve and boost customer relationships.

---
### Let’s Connect:
If you’re interested in collaborating, discussing my work, or just connecting on data science, feel free to reach out!

- **Email:** poisedconsult@gmail.com  
- **LinkedIn:** https://www.linkedin.com/in/babatunde-joel-etu/
