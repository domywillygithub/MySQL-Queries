use northwind;

show tables; 

select * from orders; 
select * from orders o
where o.shipcountry= 'Brazil';  

select * from products 
where UnitPrice > (select avg(UnitPrice)
from products);

CREATE OR replace VIEW YoungestHired AS (
SELECT distinct e.employeeid,TIMESTAMPDIFF(YEAR,e.birthdate,e.hiredate) FROM  employees e, 
(select min(TIMESTAMPDIFF(YEAR,birthdate,hiredate)) AS m FROM employees) s
WHERE TIMESTAMPDIFF(YEAR,e.birthdate,e.hiredate)=s.m
);


SELECT MAX(unitPrice) FROM orders o JOIN `order details` od ON o.orderid=od.orderid
JOIN youngesthired y ON y.employeeid=o.EmployeeID
WHERE shipcountry='Germany'; 

create or replace view A as (
select * from `order details` od 
where od.UnitPrice > (select avg(UnitPrice) from `order details`)); 

 select min(UnitPrice) from orders o
 join 
 A on A.orderID=O.orderID
 where shipcountry='Brazil';
 
create or replace view notA AS(
 select * from products 
 where productname not like lower('%a%')); 
 
create or replace view maxnotA as (
select max(UnitPrice) m from notA); 

create or replace view pSet as (
select * from notA, maxnotA where UnitPrice<maxnotA.m); 
 
 select productname,unitprice from pSet, 
 (select max(unitprice) mm from pSet) s
 where unitprice=mm;

create or replace view avgunits as (
select productid, avg(quantity) a from orders o join `order details` od on o.orderid=od.orderid
where o.shippeddate is not null
group by productid);  
select * from avgunits;

select productname, a from avgunits v join
(select max(a) mm from avgunits) s 
on a=mm join products p on p.productid=v.productid; 

select productname, max(a) from avgunits v 
join  products p on p.productid=v.productid; 
 
select shipcountry, unitprice from `order details` od join
(select max(unitprice) m from `order details`) s
on unitprice=m join orders o on o.orderid=od.orderid; 

select * from categories c 
join
products p on c.categoryid=p.categoryid; 


select * from totalprice;

select productname,TotalPrice, shipcountry from totalprice tp join
products p on tp.productid=p.productid ;

select * from totalprice tp join products p on tp.productid=p.productid; 

/*create or replace view totalprice as (
select shipcountry,productid, sum(unitprice*quantity*((100-discount)/100)) TotalPrice from `order details` od join orders o on od.orderid=o.orderid
where shippeddate is not null
group by productid); 


create or replace view MaxBrazil as (
select categoryid,productname,TotalPrice from totalprice tp join 
(select max(TotalPrice) mtp from totalprice where shipcountry='Brazil' ) s on mtp=TotalPrice join 
products p on tp.productid=p.productid
);  

select categoryname,productname from MaxBrazil mb
 join categories c on mb.categoryid=c.categoryid; */ 
 
create or replace view A96 AS (
select o.orderid, sum(unitprice*quantity*((100-discount)/100)) as price,orderdate from orders o join `order details` od on o.OrderID=od.OrderID
where orderdate like '%1996-08-%'
group by orderdate); 

select orderid, price from A96,
(select max(price) m from A96) s 
WHERE price=m;  

CREATE OR REPLACE VIEW aug96 AS (
SELECT * FROM orders
WHERE orderdate>='1996-08-01 00:00:00' AND orderdate<='1996-08-31 23:59:59');

CREATE OR REPLACE VIEW oprice AS(
SELECT a.orderid, sum(od.unitprice*od.quantity*((100-od.discount)/100)) AS Price FROM aug96 a JOIN `order details` od ON a.orderid=od.orderid 
GROUP BY orderid); 

SELECT orderid, price FROM oprice,
(SELECT MAX(price) AS m FROM oprice) s
WHERE price=m;

create or replace view maxage as (
select employeeid, timestampdiff(year, birthdate,hiredate) from employees,
(select max(timestampdiff(year, birthdate,hiredate)) m from employees) s
where timestampdiff(year, birthdate,hiredate) = m); 

select max(unitprice) from orders o join `order details` od on o.orderid=od.orderid 
join maxage on maxage.employeeid = o.employeeid;  



/* -- For each of the regions select the category that resulted in the highest total value of the orders from that region. 
The result should contain only region and category name.*/  

select * from categories; 
select * from `order details`;
select * from products; 

create or replace view AA as (
SELECT regiondescription,categoryname,SUM((od.unitprice*od.quantity)*((100-discount)/100)) AS val FROM
orders o
JOIN `order details` od ON o.OrderID=od.orderid
JOIN products p ON p.ProductID=od.productid
JOIN categories cc ON cc.categoryid=p.categoryid 
Join employeeterritories e on o.employeeid = e.employeeid
join territories t on t.territoryid= e.territoryid
join region r on t.regionid=r.regionid
group by regiondescription,CATEGORYname); 

select aa.* from aa join
(select regiondescription, max(val) as m from AA
group by regiondescription) s 
on val=s.m and aa.regiondescription=s.regiondescription;  

use warehouse; 
use northwind;

show tables;  
drop table stuff;
drop table people;

create table people (
id int auto_increment,
firstname varchar(40) not null,
lastname varchar(40) not null, 
title varchar(30),
address varchar(70), city varchar(30), country varchar(30),
role enum('customer','employee','other'), notes varchar(90),
primary key (id));  

create table orders (
id int auto_increment, 
orderdate date, 
duedate date, 
shipped tinyint(1), 
overdue tinyint(1),
ship varchar(40), 
address varchar(70), 
city varchar(30), 
country varchar(30),
product varchar(70), 
quantity int unsigned, 
`value` decimal(10,2), 
primary key(id,product),
foreign key(product) references stuff(productname)
) ;

create table stuff(
productname varchar(70),
category varchar(40) not null, 
unitprice decimal(10,2) unsigned,
instock int unsigned, 
primary key(productname)
);
 
 INSERT INTO warehouse.stuff(productname, category, unitprice, instock)
SELECT
		ProductName,
		CategoryName,
		UnitPrice,
		UnitsInStock
	FROM northwind.products
	INNER JOIN northwind.categories
	ON northwind.products.CategoryID = northwind.categories.CategoryID
	WHERE CategoryName NOT IN ('Confections'); 
    
    SELECT * FROM warehouse.stuff; 

INSERT INTO warehouse.people(firstname, lastname, title, address, city, country, role, notes)
	SELECT
		FirstName,
		LastName,
		Title,
		Address,
		City,
		Country,
		'employee',
		SUBSTRING(Notes, 1, 90)
	FROM northwind.employees 
	
	UNION
	
	SELECT
		SUBSTRING_INDEX(ContactName, ' ', 1),
		SUBSTRING_INDEX(ContactName, ' ', -1),
		ContactTitle, 
		Address, 
		City, 
		Country, 
		'customer', 
		CompanyName
	FROM northwind.customers; 
    
select * from warehouse.people;  

INSERT INTO warehouse.orders(orderdate, duedate, shipped, overdue, ship, address, city, country, product, quantity, value)
	SELECT
		o.OrderDate,
		o.RequiredDate,
		o.ShippedDate IS NOT NULL,
		TIMESTAMPDIFF(DAY, o.ShippedDate, o.RequiredDate) < 0,
		o.ShipName,
		o.ShipAddress,
		o.ShipCity,
		o.ShipCountry,
		p.ProductName,
		od.Quantity,
		ROUND(od.UnitPrice * od.Quantity - (od.UnitPrice * od.Quantity * (od.Discount / 100)), 2)
	FROM northwind.orders AS o
	
	INNER JOIN northwind.`order details` AS od
	ON o.OrderID = od.OrderID
	
	INNER JOIN northwind.products AS p
	ON northwind.od.ProductId = northwind.p.ProductID
	
	INNER JOIN northwind.categories AS c
	ON northwind.p.CategoryID = northwind.c.CategoryID
	
	INNER JOIN northwind.customers AS cus
	ON northwind.o.CustomerID = northwind.cus.CustomerID
	
	WHERE o.OrderID NOT IN(
		SELECT
			DISTINCT
			o.OrderID
		FROM northwind.orders AS o
		
		INNER JOIN northwind.`order details` AS od
		ON o.OrderID = od.OrderID
		
		INNER JOIN northwind.products AS p
		ON northwind.od.ProductId = northwind.p.ProductID
		
		INNER JOIN northwind.categories AS c
		ON northwind.p.CategoryID = northwind.c.CategoryID
		
		WHERE c.CategoryName IN ('Confections')
	)
	AND o.CustomerID NOT IN(
		SELECT
			DISTINCT
			cus.CustomerID
		FROM northwind.customers AS cus
		
		WHERE cus.Country IN ('Germany') OR cus.Country IS NULL
	)
	AND o.ShippedDate IS NOT NULL
	
	
	ORDER BY o.OrderID; 
    
    select * from warehouse.orders; 
    
ALTER TABLE warehouse.orders
DROP COLUMN employee;

    
    ALTER TABLE warehouse.orders
	ADD COLUMN  employee INTEGER;
UPDATE warehouse.orders
	SET employee = 1
	WHERE id IN(
		SELECT
			orders.OrderID
		FROM northwind.orders
		WHERE orders.EmployeeID = 1
	);

UPDATE warehouse.orders
	SET employee = 2
	WHERE id IN(
		SELECT
			orders.OrderID
		FROM northwind.orders
		WHERE orders.EmployeeID = 2
	);

UPDATE warehouse.orders
	SET employee = 3
	WHERE id IN(
		SELECT
			orders.OrderID
		FROM northwind.orders
		WHERE orders.EmployeeID = 3
	);

UPDATE warehouse.orders
	SET employee = 4
	WHERE id IN(
		SELECT
			orders.OrderID
		FROM northwind.orders
		WHERE orders.EmployeeID = 4
	);

UPDATE warehouse.orders
	SET employee = 5
	WHERE id IN(
		SELECT
			orders.OrderID
		FROM northwind.orders
		WHERE orders.EmployeeID = 5
	);

UPDATE warehouse.orders
	SET employee = 6
	WHERE id IN(
		SELECT
			orders.OrderID
		FROM northwind.orders
		WHERE orders.EmployeeID = 6
	);

UPDATE warehouse.orders
	SET employee = 7
	WHERE id IN(
		SELECT
			orders.OrderID
		FROM northwind.orders
		WHERE orders.EmployeeID = 7
	);

UPDATE warehouse.orders
	SET employee = 8
	WHERE id IN(
		SELECT
			orders.OrderID
		FROM northwind.orders
		WHERE orders.EmployeeID = 8
	);

ALTER TABLE warehouse.orders
	ADD CONSTRAINT FOREIGN KEY 
		(employee) REFERENCES warehouse.people(id);  
        
select * from warehouse.orders;   


INSERT INTO warehouse.orders(id, orderdate, duedate, shipped, overdue, ship, address, city, country, product, quantity, VALUE, employee)
	VALUES
		(1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Joggers', 'Tyoko', 'Tyoko', 'Japan', 'kickers', 1, 39, 1),
		(1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Timberland boots', 'Dodoma', 'Dodoma', 'Tanzania', 'pie', 1, 18, 1),
		(1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Hoodies', 'Ngaramtoni', 'Arusha', 'Tanzania', 'Cucumbers', 1, 19, 1),
		(1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Nike Air force1', 'Mwanza', 'Mwanza', 'Tanzania', 'Flowes', 2, 14, 1),
		(1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Adidas hoodies', 'Kigoma', 'Kigoma', 'Tanzania', 'salt', 10, 25, 1),
		(2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Wedding dresses', 'Manila', 'Manila', 'Phillipines', 'dog-meat', 2, 78, 1),
		(2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Watermelons', 'Kampala', 'Kampala', 'Uganda', 'Coffee', 3, 54, 1),
		(2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Mangoes', 'Durban', 'Durban', 'South Africa', 'Camel', 2, 38, 1),
		(2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'kitchen utensils', 'Chamwino', 'Dodoma', 'Tanzania', 'Flowers', 1, 7, 1),
		(2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Pesticides', 'sinza', 'Dar', 'Tanzania', 'toaster', 20, 50, 1);		

SELECT
	*
FROM warehouse.orders;


INSERT INTO warehouse.stuff(productname, category, unitprice, instock)
	VALUES
		('Alloy', 'Beverages', 5, 25),
		('beef', 'Meat/Poultry', 15, 10),
		('mutton', 'Condiments', 20, 6);

SELECT
	*
FROM warehouse.stuff;


INSERT INTO warehouse.people(firstname, lastname, title, address, city, country, role, notes, age)
	VALUES
		('Lucy', 'Roma', 'Manager', 'Ntyuka', 'Dodoma', 'Tanzania', 'customer', 'The doctor of medicine', 29),
		('Che', 'Jan', 'Driver', 'chi-cho', 'Shaghai', 'China', 'control engineer', 'Activate key amoeba', 27);
	
SELECT
	*
FROM warehouse.people;     

CREATE OR REPLACE VIEW locations(city, country, object) AS
	SELECT
		p.city,
		p.country,
		p.role
	FROM warehouse.people AS p
	
	UNION
	
	SELECT
		o.city,
		o.country,
		'order'
	FROM warehouse.orders AS o;


SELECT
	*
FROM warehouse.locations; 

DELIMITER //
CREATE TRIGGER bi_orders
BEFORE INSERT
ON warehouse.orders
FOR EACH ROW
BEGIN
	
	SELECT
		s.instock
	INTO @current_quantity
	FROM warehouse.stuff AS s
	WHERE s.productname LIKE NEW.product;
	
	IF @current_quantity < NEW.quantity
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Requeried amount of product is not available';
	END IF;
	
END //

DELIMITER ; 

 
delimiter $$
CREATE TRIGGER ad_orders
AFTER DELETE 
ON warehouse.orders
FOR EACH ROW
BEGIN
	
	IF OLD.shipped = 0 
	THEN
	UPDATE warehouse.stuff AS s
		SET s.instock = s.instock + OLD.quantity
		WHERE s.productname = OLD.product;
        
	END IF;

END $$
DELIMITER ;

ALTER TABLE warehouse.people
	ADD COLUMN IF NOT EXISTS age INTEGER;

DELIMITER //

CREATE OR REPLACE TRIGGER bu_people
BEFORE UPDATE
ON warehouse.people
FOR EACH ROW
BEGIN

	IF NEW.age < 18
	THEN
		
		SET NEW.age = NULL;
		
	END IF;

END //

DELIMITER ; 

UPDATE warehouse.people AS p
	SET p.age = (
	SELECT
		pinf.age
	FROM northwind.people_info AS pinf
	WHERE CONCAT(p.firstname, p.lastname) = CONCAT(pinf.FirstName, pinf.LastName));

UPDATE warehouse.people AS p
	SET p.age = FLOOR(0 + RAND() * (100 - 0 +1))
	WHERE p.role NOT IN ('employee');

SELECT
	*
FROM warehouse.people; 




 
