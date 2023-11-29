use classicmodels; 
select * from customers;
select * from payments;
select * from products;
select * from employees;
select * from customers
where salesRepEmployeeNumber = '1002';

-- Where 
select * from customers
where city ='White Plains';

-- And Or Not 
select * from customers
where country = 'Australia' and postalCode = '3004';
select * from customers
where country = 'France' and (postalCode = '44000' or salesRepEmployeeNumber = '1370');

-- Order By
select * from customers
order by country Desc;
select * from customers
order by country Asc;
select * from customers
order by country Desc, customerName;

-- Insert into
INSERT INTO customers (customerNumber, customerName, contactLastName,contactFirstName,phone,addressLine1,addressLine2,city,state,postalCode,country,salesRepEmployeeNumber,creditLimit) 
VALUES (2, 'Long', 'Chanh', 'Nguyen', 'dd', 'ee', 'ff', 'gg', 'hh', 'ii', 'jj', 1002, 21000.00);

-- NULL values
select * from customers
where state IS NULL;
select * from customers
where state IS not NULL;

-- Update
update customers
set customerName = 'long1', city ='TpHCM'
where customerNumber = 2;



-- Delete all elements on database (Just use for Primary Key)
DELETE FROM customers WHERE customerName = 'Long';  
-- This help delete from any element you choose on this database If we want to delete an element use UPDATE
SET SQL_SAFE_UPDATES = 0;

-- Limit (Offset is where u want to begin) 
select * from customers
limit 3 offset 0; 

-- Min Max
select min(buyPrice) as minprice from products;
select max(buyPrice) as maxprice from products;

-- % Wildcard
select * from customers
where city like 'Na%';
select * from customers
where city like '_a_t_s';

-- Like 
select * from customers
where city like '_a%';

-- In (cái ordernumber của orderdetails lấy giống orderNumber như orders)
-- để biết xem có bao nhiêu orders 
select * from orderdetails
where orderNumber in (select orderNumber from orders);

-- Between And 
select * from  orderdetails
where quantityOrdered between 20 and 40
and priceEach not in (136.00) and orderLineNumber not in (4);

-- Aliases
select customerName as Name from customers;
-- Aliases (Sử dụng được cho những databases có chung primary và foreign key)
select c.customerNumber, p.paymentDate, p.amount
from customers as c, payments as p
where c.customerNumber = 103 and c.customerNumber = p.customerNumber;

-- Joins
select customers.customerName, p.checkNumber, p.amount
from payments as p
inner join customers on customers.customerNumber = p.customerNumber;

-- Inner Join (create the new table with the same primary key or foreign key)
select customers.customerName, p.checkNumber, p.amount, orders.shippedDate
from ((payments as p
inner join customers on customers.customerNumber = p.customerNumber)
inner join orders on orders.customerNumber = p.customerNumber); 

 -- Right Join (create the new table with the same primary key or foreign key) (lấy tất cả các giá trị của bảng payments sau đó sẽ lấy các giá trị của bảng customers) 
select customers.customerName, p.checkNumber, p.amount
from payments as p
right join customers on customers.customerNumber = p.customerNumber; 
 
 -- Left Join (create the new table with the same primary key or foreign key) (lấy tất cả các giá trị của bảng customers sau đó sẽ lấy các giá trị của bảng payments) 
select customers.customerName, p.checkNumber, p.amount
from payments as p
left join customers on customers.customerNumber = p.customerNumber;

-- Cross Join (Merge those database)
select customers.customerName, p.checkNumber, p.amount
from payments as p
cross join customers;
select customers.customerName, p.checkNumber, p.amount
from customers 
cross join payments as p;

-- self join
select orderdetails.priceEach as Price, products.productName as Name, orderdetails.productCode
from orderdetails, products
where orderdetails.productCode <> products.productCode
order by products.productName;

-- Union (use for distinct value) Uninon All (use for duplicate values)
select customerNumber from customers
union
select customerNumber from payments; 
select customerNumber from customers
union all
select customerNumber from payments; 

-- Group by USE to count, max, min, avg sum.
select count(customerName) as num_of_cou, country from customers
group by country;
select customers.customerName, count(orders.orderNumber) as NumberOfOrders
from customers
left join orders on customers.customerNumber = orders.customerNumber
group by customerName;

-- Having (Dùng giống như where nhưng dùng được cho một group không phải individual như where)
-- Having dùng trước FROM, WHERE, SELECT và sau DISTINCT, SELECT, ORDER BY, and LIMIT
select count(customerName) as num_of_cou, country from customers
group by country
having num_of_cou > 3;
select customers.customerName, count(orders.orderNumber) as NumberOfOrders
from customers
left join orders on customers.customerNumber = orders.customerNumber
group by customerName
having NumberOfOrders > 2;
select customers.customerName, count(orders.orderNumber) as NoO from orders
inner join customers on customers.customerNumber = orders.customerNumber
where customers.customerName = 'Signal Gift Stores' or customers.customerName = 'Baane Mini Imports'
group by customerName
having count(orders.orderNumber) > 3;
-- Error 
select count(customerName) as num_of_cou, country from customers
group by country
where num_of_cou > 3;

-- Exists
select * from orderdetails;
select * from products;
select productLine
from products
where exists (select quantityOrdered from orderdetails where products.productCode = orderdetails.productCode and buyPrice = 33.30);

-- Any All
-- Any -- it work because of the table has more data of quantityOrdered = 10 => give TRUE
select productName
from products
where productCode = any (select productCode from orderdetails where quantityOrdered = 10);
select productName
from products
where productCode = any (select productCode from orderdetails where quantityOrdered > 10);
--  All -- doesn't work because of the table needs to have exactly data of quantityOrdered = 10 (just 1 element or all of them is 10) => given Nothing => FALSE
select productName
from products
where productCode = all (select productCode from orderdetails where quantityOrdered = 10);
select productName
from products
where productCode = all (select productCode from orderdetails where quantityOrdered > 10);
-- All
select all productName from products; -- it same with Select operator

-- INSERT INTO SELECT
-- copies data from one table and inserts it into another table (Types of those tables need to same)
-- INSERT INTO table2 (column1, column2, column3, ...)
-- SELECT column1, column2, column3, ...
-- FROM table1
-- WHERE condition;  

-- case like (If-Else)
select quantityInStock,buyPrice,
case
	when quantityInStock = 14 then '14 quantity'
    when quantityInStock < 20 then 'smaller than 20'
    when quantityInStock > 15 then 'higher than 15'
end as Quantity
from products;

-- NULL Functions
-- Values on table can be NULL if we don't want it show in the result table we can use IFNULL() to change value u want
-- SELECT ProductName, UnitPrice * (UnitsInStock + IFNULL(UnitsOnOrder, 0))
-- FROM Products; 
-- => At UnitOnOrder has value NULL and change it to 0






