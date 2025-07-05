Create Database Adventure_works;
use adventure_works;
#_Query1. Appended Two tables into one table using Union all Function
# Ans-

CREATE TABLE Sales AS SELECT * FROM
    factinternetsales 
UNION ALL SELECT 
    *
FROM
    fact_internet_sales_new;
select * from sales;

#_Query2. This Query shows us Total Revenue, Total Cost, Total Profit
# Ans-

SELECT 
    concat(round(SUM(UnitPrice * OrderQuantity)/1000000,2),"M") AS Total_Revenue,
    concat(round(SUM(ProductStandardCost * OrderQuantity)/1000000,2),"M") AS Total_Cost,
    concat(round(SUM(UnitPrice * OrderQuantity - ProductStandardCost * OrderQuantity)/1000000,2),"M") AS Total_profit
FROM
    sales;
    
#_Query3. Query for total_sales
# Ans-   

SELECT 
    SalesOrderNumber,
    OrderQuantity,
    UnitPrice,
    (OrderQuantity * UnitPrice) AS total_sales
FROM
    sales
LIMIT 10;

#_Query4. Top 10 selling Products
# Ans-

SELECT 
    ProductKey,
    SUM(OrderQuantity) AS total_units_sold,
    round(sum(OrderQuantity * UnitPrice),2) AS total_sales
FROM
    sales
GROUP BY ProductKey
ORDER BY total_units_sold DESC
LIMIT 10;

#_Query5. Orders with high Tax
# Ans-

SELECT 
    *
FROM
    sales
WHERE
    TaxAmt > 100
ORDER BY TaxAmt DESC
LIMIT 20;

#_Query6. Created Index on customerkey
# Ans- 

create index idx_customerkey on sales(CustomerKey);

-- Calling Index
select * from sales where CustomerKey = 20982; 

#_Query7. Join Sales with dimproduct
# Ans-

SELECT 
    s.SalesOrderNumber,
    p.EnglishProductName,
    s.OrderQuantity,
    s.UnitPrice,
    (s.UnitPrice * s.OrderQuantity) AS total_sales
FROM
    sales s
        JOIN
    dimproduct p ON s.ProductKey = p.ProductKey;
    
#_Query8. Created View to show sales Profit
# Ans-  
    
CREATE VIEW sales_profit AS
    SELECT 
        CustomerKey,
        ProductKey,
        OrderQuantity,
        UnitPrice,
        ProductStandardCost,
        (UnitPrice - ProductStandardCost) * OrderQuantity AS profit
    FROM
        sales;
 
# Calling View
Select * from sales_profit;

#_Query9. Created stored procedure to view Top and Bottom 10 products to see How many units being sold
# Ans- 

# Calling Stored Procedure
Call View_Top_and_Bottom_10_product();

#_Query10. Creating Profit column using Alter Function
# Ans- 

alter table Sales add column Sales_Amount Int;
Update Sales set Sales_Amount = UnitPrice-DiscountAmount*OrderQuantity;

alter table Sales add column Production_Cost Int;
Update Sales set Production_Cost = ProductStandardCost*OrderQuantity;

alter table Sales add column Profit Int;
Update Sales set Profit = Sales_Amount-Production_Cost;
select * from sales;

# Below Query is used to show Profit value in Million number format
# Ans-

select concat(round(sum(profit)/1000000,2),"M") as Total_Profit_in_Million From sales;


#_Query11. Using Concat function got customers full name
# Ans- 

Alter table Dimcustomer  add column customer_Full_name varchar(50);
Update Dimcustomer Set customer_Full_name = concat(FirstName," ",MiddleName," ",LastName);
select * from dimcustomer;

#_Query12. Top 10 Customers Full name with highest profit
# Ans-

SELECT 
    customer_Full_name, ROUND(SUM(Profit)) AS Profit
FROM
    dimcustomer
        INNER JOIN
    sales ON dimcustomer.CustomerKey = sales.CustomerKey
GROUP BY customer_Full_name
ORDER BY Profit DESC
LIMIT 10; 






