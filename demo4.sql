
/* Difference between WHERE and HAVING
WHERE is used to filter rows and it works on row's data but not on aggregated functions 
on the other hand 
HAVING works on aggregated data 
aggregated functions are used to perform calculations on multiple rows of a single column
-It returns a single value 
-its used to summarize data
examples of aggregated functions are 
MAX
MIN 
AVG
SUM 
COUNT
consider below examples */ 
use book; 

select * from mysample; 
select * from mysample
where UnitCost > 10
having Total > 100; 

show tables;  

select Region,Rep,count(*)
from mysample
group by Region,Rep
having count(*) > 1
order by count(*) desc; 
select *from mysample; 

/* UNION VS UNION ALL 

UNION - removes duplicates
-combines result of 2 or more select statements but each statement should have 
.same number of columns
.columns must have similar data types 
.columns must be in the same order
UNION ALL - does not remove duplicates */
create database student; 
use student; 

create table student_details1
(
s_id int(10),
s_name varchar(10),
s_marks int(10)
); 
select * from student_details1; 

create table student_details2
(
s_id int(10),
s_name varchar(10),
s_marks int(10)
); 

insert into student_details1 values (1, 'Sam', 45);
insert into student_details1 values (2, 'Bob', 87);
insert into student_details1 values (3, 'Anne', 73);
insert into student_details1 values (4, 'Julia', 92); 

insert into student_details2 values (3, 'Anne', 73);
insert into student_details2 values (4, 'Julia', 92);
insert into student_details2 values (5, 'Matt', 65); 

show tables; 

select *from student_details1
union
select *from student_details2; 

select *from student_details1
union all
select *from student_details2;  

select * from student_details2 
where s_marks in (65,92); 

select * from student_details1;  

create table Professor
(
E_id int(10),
E_name varchar(10)
); 
create table student
(
Roll_num int(10),
S_name varchar(10),
S_advisor int(10),
Sex varchar(10)
); 

insert into Professor values (1, 'Khan');
insert into Professor values (2, 'Mitus');
insert into Professor values (3, 'Kajale');
insert into Professor values (4, 'Paul');
insert into Professor values (5, 'Mahamba'); 

insert into student values(101, 'Lucy', 2, 'F');
insert into student values(102, 'ALLy', 4, 'M');
insert into student values(103, 'Eva', 3, 'F');
insert into student values(104, 'Veronica', 2, 'F');
insert into student values(105, 'Adam', 5, 'M');
insert into student values(106, 'Martha', 1, 'F'); 

select E_id, E_name from Professor as P
where exists (select Roll_num from student as S
              where S.S_advisor = P.E_id 
              and S.Sex = 'F'); 
              
/* IN VS EXISTS 

IN - used as a multiple OR statements
where 
EXISTS used to return True or False values
as ILLUSTRATED WITH EXAMPLES ABOVE  */ 

/* JOIN VS SUBQUERY
Both are used to combine data from different tables into one single result    
SUBQUERY is slower and can select only from first table while 
JOIN is faster and can select from either of the tables */

create table customer
(
cust_id int(10),
cust_name varchar (10),
Phone_num varchar(50)
); 

create table Orders
(
Cust_id int(10),
order_id int(10),
city varchar(10) 
);         

insert into customer values (101, 'John','882-778-882');
insert into customer values (102, 'Marian','832-338-442');
insert into customer values (103, 'Shaft','838-887-778');
insert into customer values (104, 'Jackie','822-338-442');
insert into customer values (105, 'Ahmed','892-663-447'); 

insert into orders values (101, 178292,'Dodoma');
insert into orders values (102, 2738449,'Arusha');
insert into orders values (103, 2738497,'Tanga');
insert into orders values (104, 348494,'Mwanza');
insert into orders values (105, 474983,'Mbeya'); 

select Phone_num, cust_name from customer 
where cust_id in (select cust_id from orders); 

select cust_name,Phone_num,order_id from customer 
join orders 
on customer.cust_id = orders.cust_id; 

 

