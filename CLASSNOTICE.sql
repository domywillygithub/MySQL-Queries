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

show tables;  

create table people (
id int auto_increment,
firstname varchar(40) not null,
lastname varchar(40) not null, 
title varchar(10),
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
quantity int, 
`value` decimal(10,2), 
primary key(id,product)
) ;

create table stuff(
productname varchar(70),
category varchar(40) not null, 
unitprice decimal(10,2),
instock int, 
primary key(productname)
);
 
 
