use northwind;
select orderdate, count(orderdate) as initial from orders
group by OrderDate
order by initial desc 
limit 1; 

create or replace view initial as (
select orderdate,count(OrderDate) urzad from orders
group by orderdate);
select * from initial;

select o.orderdate, max(i.urzad) from orders o
join initial i on i.orderdate=o.orderdate
where urzad < (select max(urzad) from initial)
group by o.OrderDate
order by i.urzad desc
limit 17; 

select o.orderdate, i.urzad from orders o
join initial i on i.orderdate=o.orderdate
where urzad = (select max(urzad) from initial
               where i.urzad < (select max(i.urzad) from initial)); 
               
/* Different types of Joins in MySQL
In MySQL, there are four types of joins: INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN. 
Each type of join is used to combine data from two or more tables based on a condition.

1.INNER JOIN:
The INNER JOIN returns only the rows that have matching values in both tables. It is the most common type of join used in MySQL.
 For example, if we have two tables named "employees" and "employeeterritories", 
we can use INNER JOIN to find the employees who work in the "03049" territory as follows:*/               

SELECT *
FROM employees
INNER JOIN employeeterritories ON employees.employeeid = employeeterritories.employeeid
WHERE employeeterritories.territoryid = '03049';

/* 2.The LEFT JOIN returns all the rows from the left table and the matched rows from the right table. 
If there are no matching rows in the right table, it returns NULL values. For example, if we have two tables named "orders" and "order details", 
we can use LEFT JOIN to find all the orders and their unitprice as follows:*/

SELECT orders.*, `order details`.unitprice
FROM orders
LEFT JOIN `order details` ON orders.orderid = 	`order details`.orderid;

/*3.RIGHT JOIN:
The RIGHT JOIN returns all the rows from the right table and the matched rows from the left table. 
If there are no matching rows in the left table, it returns NULL values. For example, if we have two tables named "orders" and "customers",
 we can use RIGHT JOIN to find all the orders and their companyname as follows: */
 
SELECT orders.orderid, customers.companyname
FROM orders
RIGHT JOIN customers ON orders.customerid = customers.customerid;

/*4. FULL OUTER JOIN:
The FULL OUTER JOIN returns all the rows from both tables and NULL values where there are no matches. 
It is used when we want to combine all the data from two tables.
MySQL does not have a FULL OUTER JOIN. Instead, you can emulate a FULL OUTER JOIN using a combination of LEFT JOIN and RIGHT JOIN
 with a UNION operator. Here is an example:
Suppose we have two tables "students" and "grades", and we want to find all the students and their grades, including those without any grades.*/
SELECT orders.orderid, `order details`.unitprice
FROM orders
LEFT JOIN `order details` ON orders.orderid = `order details`.orderid
UNION
SELECT orders.orderid , `order details`.unitprice
FROM orders
RIGHT JOIN `order details` ON orders.orderid = `order details`.orderid
WHERE orders.orderid IS NULL;




