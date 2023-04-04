create database warehouse;


select * from mysql.user; 

create user 'WAdmin'@'localhost'; 
set password for 'WAdmin'@'localhost'="adminpass";  

GRANT ALL PRIVILEGES ON warehouse.* TO 'WAdmin'@'localhost' ;
FLUSH PRIVILEGES;  
 
 create user 'Mahamba'@'localhost'; 
 
 set password for 'Mahamba'@'localhost' = "william"; 
 
grant all privileges on warehouse.* to 'Mahamba'@'localhost';
grant all privileges on northwind.* to 'Mahamba'@'localhost';


use northwind; 
select * from employees;

DROP procedure if exists eAge;
delimiter //
CREATE PROCEDURE eAge (IN fname varchar(90), in lname varchar(30), out a int)
begin 
select timestampdiff(year, birthdate,now()) age 
from employees
where firstname=fname and lastname=lname;
end //
delimiter 

create table pets (
id int primary key auto_increment, pet_name varchar(50),
pet_owner varchar(50), species varchar(50), sex char(1),
birth DATE, death DATE);

INSERT INTO pets (id, pet_name,pet_owner,species,sex,birth,death)
values (1,'snowflake','Damian','Robocap', 'F','2015-03-28',null),
	   (2,'Nimeria','Joshua','Myomir', 'M','2013-05-21','2022-07-25'),
       (3,'Brown','Chris','kickass', 'F',now(),null); 
       
select * from pets;  

use warehouse; 
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
	    (1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Timberland boots', 'Dodoma', 'Dodoma', 'Tanzania', 'Tofu', 1, 18, 1),
        (1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Hoodies', 'Ngaramtoni', 'Arusha', 'Tanzania', 'beef', 1, 19, 1),
        (1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Nike Air force1', 'Mwanza', 'Mwanza', 'Tanzania', 'Chai', 2, 14, 1),
        (1, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Adidas hoodies', 'Kigoma', 'Kigoma', 'Tanzania', 'Chang', 10, 25, 1),
        (2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Wedding dresses', 'Manila', 'Manila', 'Phillipines', 'Chai', 2, 78, 1),
        (2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Watermelons', 'Kampala', 'Kampala', 'Uganda', 'Ikura', 3, 54, 1),
        (2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Mangoes', 'Durban', 'Durban', 'South Africa', 'Geitost', 2, 38, 1),
        (2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'kitchen utensils', 'Chamwino', 'Dodoma', 'Tanzania', 'Gravad lax', 1, 7, 1),
		(2, CURRENT_DATE(), CURRENT_DATE(), 1, 1, 'Pesticides', 'sinza', 'Dar', 'Tanzania', 'Aniseed Syrup', 11, 50, 1);		

SELECT * FROM warehouse.stuff; 

select * from warehouse.orders;

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
-- inserting order with available amount of products
INSERT INTO warehouse.orders(id, orderdate, duedate, shipped, overdue, ship, address, city, country, product, quantity, VALUE, employee)
	VALUES
		(2500, CURDATE(), CURDATE(), FALSE, FALSE, 'Applejuices', 'wittiga 6', 'Wroclaw', 'Poland', 'Aniseed Syrup', 5, 300, 1);

-- ckech for current orders		
SELECT *FROM warehouse.orders
ORDER BY orders.id DESC; 

-- delete test order
DELETE FROM warehouse.orders
WHERE orders.id = 2500;

-- inserting order with not available amount of products
INSERT INTO warehouse.orders(id, orderdate, duedate, shipped, overdue, ship, address, city, country, product, quantity, VALUE, employee)
	VALUES
		(2500, CURDATE(), CURDATE(), FALSE, FALSE, 'Applejuices', 'wittiga 6', 'Wroclaw', 'Poland', 'Aniseed Syrup', 50, 300, 1);
		
-- check for current orders
SELECT *FROM warehouse.orders
ORDER BY orders.id DESC; 

-- Question 8
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

-- inserting order not shipped order
INSERT INTO warehouse.orders(id, orderdate, duedate, shipped, overdue, ship, address, city, country, product, quantity, VALUE, employee)
	VALUES
		(2500, CURDATE(), CURDATE(), FALSE, FALSE, 'Applejuices', 'wittiga 6', 'Wrocalw', 'Poland', 'Aniseed Syrup', 5, 300, 1);

-- chech for current stuff		
SELECT * FROM warehouse.stuff;

-- delete test order
DELETE FROM warehouse.orders
WHERE orders.id = 2500;

-- chech for current stuff		
SELECT *FROM warehouse.stuff;

-- Question 9 
ALTER TABLE warehouse.people
	ADD COLUMN age INTEGER;

DELIMITER //
CREATE TRIGGER bu_people
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
use northwind; 

create view people_info as 
(select firstname,lastname,age from employees); 
select * from people_info; 

set SQL_SAFE_UPDATES = 0;

UPDATE warehouse.people AS p
	SET p.age = (
	SELECT
		pinf.age
	FROM northwind.people_info AS pinf
	WHERE CONCAT(p.firstname, p.lastname) = CONCAT(pinf.FirstName, pinf.LastName));

UPDATE warehouse.people AS p
	SET p.age = FLOOR(0 + RAND() * (100 - 0 +1))
	WHERE p.role NOT IN ('employee');

SELECT * FROM warehouse.people; 


-- Question 10 
SHOW CREATE TRIGGER bi_orders;

DELIMITER //
CREATE TRIGGER ai_orders 
After INSERT
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
	ELSEIF @current_quantity >= NEW.quantity
	THEN
		UPDATE warehouse.stuff AS s
			SET s.instock = s.instock - NEW.quantity
			WHERE s.productname = NEW.product;
	END IF;
	
END//

DELIMITER ;  

INSERT INTO warehouse.orders(id, orderdate, duedate, shipped, overdue, ship, address, city, country, product, quantity, VALUE, employee)
	VALUES
		(2500, CURDATE(), CURDATE(), FALSE, FALSE, 'Applejuices', 'wittiga 6', 'Wrocalw', 'Poland', 'Aniseed Syrup', 5, 300, 1);

-- chech for current stuff		
SELECT * FROM warehouse.stuff;

-- delete test order
DELETE FROM warehouse.orders
WHERE orders.id = 2500;

-- chech for current stuff		
SELECT *FROM warehouse.stuff;

-- Question 11 
DELIMITER // 
use warehouse //
CREATE PROCEDURE personAdress(IN fname VARCHAR(50), IN lname VARCHAR(50), OUT adrs VARCHAR(50))
BEGIN
	
	DECLARE counter INTEGER DEFAULT 0;
	SELECT
		COUNT(*)
	INTO counter
	FROM warehouse.people AS p
	WHERE CONCAT(p.firstname, p.lastname) = CONCAT(fname, lname);
	
	IF counter > 0
	THEN
		
		SELECT
			p.address
		INTO adrs
		FROM warehouse.people AS p
		WHERE CONCAT(p.firstname, p.lastname) = CONCAT(fname, lname);
		
	END IF;

END //
DELIMITER ;
SELECT * FROM warehouse.people; 
CALL warehouse.personAdress('Nancy', 'Davolio', @address);
SELECT @address; 

DELIMITER //
use warehouse //
CREATE PROCEDURE refillProduct(IN product VARCHAR(50), IN amount INTEGER)
BEGIN
	
	DECLARE counter INTEGER DEFAULT 0;
	SELECT
		COUNT(*)
	INTO counter
	FROM warehouse.stuff AS s
	WHERE s.productname LIKE product;
	
	IF counter > 0 AND amount > 0
	THEN
		
		UPDATE warehouse.stuff AS s
			SET s.instock = s.instock + amount
			WHERE s.productname LIKE product;
		
	END IF;
END//
DELIMITER ; 


DELIMITER //
DROP FUNCTION IF EXISTS peopleNumber //
CREATE FUNCTION peopleNumber(country VARCHAR(50), role VARCHAR(50))
RETURNS INTEGER
READS SQL DATA
DETERMINISTIC
BEGIN
	
	DECLARE counter INT DEFAULT 0;
	
	SELECT
		COUNT(*)
	INTO counter
	FROM warehouse.people AS p
	WHERE p.country = country AND p.role = role;
	
	RETURN counter;

END//
DELIMITER ; 

SELECT *FROM warehouse.people;
SELECT warehouse.peopleNumber('UK', 'CUSTOMER'); 

DELIMITER //
DROP FUNCTION IF EXISTS saleDate //
CREATE FUNCTION saleDate(product VARCHAR(50))
RETURNS DATE
READS SQL DATA
DETERMINISTIC
BEGIN
	
	DECLARE sdate DATE DEFAULT '0000-00-00';
	
	SELECT
		o.orderdate
	INTO sdate
	FROM warehouse.orders AS o
	WHERE o.product = product AND o.value IN(
		SELECT
			MAX(o.value)
		FROM warehouse.orders AS o
		WHERE o.product = product
	);
	
	RETURN sdate;
	
END//
DELIMITER ; 

SELECT
	*
FROM warehouse.orders AS o
WHERE o.product LIKE 'Alice Mutton';

SELECT warehouse.saleDate('Alice Mutton'); 

SELECT
	*
FROM warehouse.stuff AS s;

SELECT
	COUNT(DISTINCT(s.productname)) AS items_number,
	AVG(s.unitprice) AS average_price
FROM warehouse.stuff AS s
WHERE s.category LIKE 'Seafood';  

SET @SQL_query = '
	SELECT
		COUNT(DISTINCT(s.productname)) AS items_number,
		AVG(s.unitprice) AS average_price
	FROM warehouse.stuff AS s
	WHERE s.category LIKE ?;
';

SET @category = 'Seafood';

PREPARE statement FROM @SQL_query;
EXECUTE statement USING @category;
DEALLOCATE PREPARE statement; 

DELIMITER //
CREATE PROCEDURE aggrFunct(IN aggr VARCHAR(50), IN c VARCHAR(50))
BEGIN
	
	IF (aggr LIKE 'avg') AND (c IN ('unitprice', 'instock'))
	THEN
	
		SET @SQL_query = CONCAT('SELECT ', aggr, '(s.', c, ') FROM warehouse.stuff AS s;');
	
	ELSEIF (aggr LIKE 'min' OR aggr LIKE 'max') AND (c IN ('productname', 'category', 'unitprice', 'instock'))
	THEN
	
		SET @SQL_query = CONCAT('SELECT ', aggr, '(s.', c, ') FROM warehouse.stuff AS s;');
	
	ELSE
	
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Action not available';
		
	END IF;
	
	PREPARE statement FROM @SQL_query;
	EXECUTE statement;
	DEALLOCATE PREPARE statement;

END//
DELIMITER ; 

CALL aggrFunct('avg', 'unitprice');
CALL aggrFunct('min', 'productname');
CALL aggrFunct('avg', 'INSTOCK');  


SELECT
	t1.lastname,
	t1.firstname
FROM warehouse.people AS t1
INNER JOIN warehouse.people AS t2
ON t1.lastname = t2.lastname AND t1.firstname <> t2.firstname;

ALTER TABLE warehouse.people
	ADD CONSTRAINT UNIQUE INDEX `lname`(`lastname`, `firstname`);

SHOW INDEX
FROM warehouse.people;  



DELIMITER //
CREATE PROCEDURE randomOrder(IN categ VARCHAR(50), IN budget INTEGER)
BEGIN
	
	SET @item_counter = 0;
	
	SELECT
		s.unitprice
	INTO @minimal_cost
	FROM warehouse.stuff AS s
	WHERE s.category LIKE categ AND s.unitprice IN(
		SELECT
			MIN(s.unitprice)
		FROM warehouse.stuff AS s
		WHERE s.category LIKE categ	
	);
	
	WHILE (budget > @minimal_cost) AND (@item_counter < 5) DO
		
		SELECT
			s.productname
		INTO @random_product
		FROM warehouse.stuff AS s
		WHERE s.category LIKE categ
		ORDER BY RAND()
		LIMIT 1;
		
		SET @random_quantity = FLOOR(1 + RAND() * (10 - 1 +1));
		
		SET @product_cost = (
			SELECT
				s.unitprice
			FROM warehouse.stuff AS s
			WHERE s.productname LIKE @random_product
		) * @random_quantity;
		
		-- SELECT @random_product, @random_quantity, @product_cost;
		
		START TRANSACTION;
		
		SET @item_counter = @item_counter + 1;
		SET budget = budget - @product_cost;
		
		IF @random_product IN (SELECT o.product FROM warehouse.orders AS o WHERE o.id = 228)
		THEN 
			UPDATE warehouse.orders AS o
				SET o.value = o.value + @product_cost, o.quantity = o.quantity + @random_quantity
				WHERE o.id = 228 AND o.product = @random_product;
		ELSEIF @random_product NOT IN (SELECT o.product FROM warehouse.orders AS o WHERE o.id = 228)
		THEN
			INSERT INTO warehouse.orders(id, orderdate, duedate, shipped, overdue, ship, address, city, country, product, quantity, VALUE, employee)
				VALUES
					(512, CURRENT_DATE(), CURRENT_DATE(), TRUE, FALSE, 'Winter coats', 'Njiro', 'Arusha', 'Tanzania', @random_product, @random_quantity, @product_cost, 1);
		END IF;
		
		IF budget < 0
		THEN
			ROLLBACK;
			SET @item_counter = @item_counter - 1;
			SET budget = budget + @product_cost;
		ELSEIF budget >= 0
		THEN
			COMMIT;
		END IF;
		
		-- SELECT budget, @item_counter;
	
	END WHILE;

END//

DELIMITER ; 

CALL randomOrder('Seafood', 100); 
SELECT
	*
FROM warehouse.orders AS o
ORDER BY o.id ASC;

DELETE FROM warehouse.orders
	WHERE id = 512;

SELECT
	*
FROM warehouse.stuff AS s
WHERE s.category LIKE 'seafood';