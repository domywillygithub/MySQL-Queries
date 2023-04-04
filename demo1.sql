create database mydemo1; 

use mydemo1;  

create table dataofcustomer (
custid varchar(100) PRIMARY KEY,
fname varchar(50),
mname varchar(50),
lname varchar(50),
city varchar(50),
age int(10),
mobileno varchar(50),
occupation varchar(50),
dob DATE 
); 

show tables; 

select * from dataofcustomer; 

INSERT INTO dataofcustomer VALUES ('c001','Jamal','Hussein', 'Ally', 'Tokyo',65,'897-987-987','Teacher','1989-09-23'); 
INSERT INTO dataofcustomer VALUES ('c002','John','Hussan', 'Mduma', 'Kyoto',45,'897-457-447','Pilot','1993-11-03'); 
INSERT INTO dataofcustomer VALUES ('c003','Koffi','Chameleon', 'Jose', 'Manila',36,'337-767-876','Data Analyst','1997-02-11'); 
INSERT INTO dataofcustomer VALUES ('c004','Naasibu','Abdul', 'Msodoki', 'Pune',38,'337-567-987','Musician','1980-11-09'); 
INSERT INTO dataofcustomer VALUES ('c005','Mudy','Japhet', 'Choki', 'Dodoma',76,'987-876-223','Businessman','1997-11-22'); 
INSERT INTO dataofcustomer VALUES ('c006','Lucy','Hamza', 'Komba', 'Delhi',34,'337-447-347','Nurse','1998-07-22'); 
INSERT INTO dataofcustomer VALUES ('c007','Juma','Julius', 'Juma', 'Arusha',88,'897-347-987','Programmer','1980-10-01'); 
INSERT INTO dataofcustomer VALUES ('c008','kay','Mfaume', 'Kikoti', 'Mwanza',35,'897-873-554','Singer','1977-11-11'); 
INSERT INTO dataofcustomer VALUES ('c009','Jackline','Kikosa', 'Buti', 'Lagos',25,'786-677-334','Engineer','199-09-08'); 
INSERT INTO dataofcustomer VALUES ('c0010','Jillian','Hunin', 'Msey', 'Moshi',33,'833-987-987','Rigger','1996-06-05'); 

select min(age),fname from dataofcustomer; 
select max(age),fname from dataofcustomer; 

select fname from dataofcustomer where age = 25; 

select * from dataofcustomer where age>25;

select count(fname) from dataofcustomer where city = 'Delhi'; 

select count(fname),city from dataofcustomer group by city;

select concat(fname, ' ' ,lname) as FULL_NAME, age from dataofcustomer
where age not  between 35 and 45
order by FULL_NAME; 

SELECT fname,mname,lname from dataofcustomer
where lower(fname) not like '%a%' ; 

select fname,lname from dataofcustomer
where fname like '___' ; 

select * from dataofcustomer
where lower(fname) like '%a%'; 

select substr(upper(fname),1,3) INITIALS from dataofcustomer; 

select fname,lname,concat(substr(upper(fname),1,1), substr(upper(lname),1,3), '@mymail.com') EMAILS from dataofcustomer;  

select fname,lname,concat(substr(upper(fname),1,1), substr(upper(lname),-3,3), '@mymail.com') EMAILS from dataofcustomer; 

select fname, length(fname) from dataofcustomer
where length(fname) > 4; 

select * from dataofcustomer; 

select fname,lname,mobileno,replace(mobileno, '33', '$$') as new_mobileno from dataofcustomer; 

select fname,lname mobileno, (case when left(mobileno, '2') = '33' then 
replace(mobileno, '33','$$')  when right (mobileno, '2') = '34' then replace (mobileno, '34', '&&')
else mobileno end) as new_mobileno from dataofcustomer; 

/* NUMERIC FUNCTIONS
*/
select round(1.524*age, '3') from dataofcustomer; 

select age, (1.5*age) modified_age, floor(1.5*age) from dataofcustomer; 

select age, (1.5*age) modified_age,ceiling(1.5*age) from dataofcustomer; 

select fname,dob,datediff(current_date(),dob) from dataofcustomer; 

select fname,dob,date_add(dob, interval -10 day), date_add(dob, interval 1 month),datediff(current_date(),dob) from dataofcustomer;  

select fname,dob, floor(datediff(current_date(),dob)/365) as age from dataofcustomer; 

select fname,dob, floor(datediff(current_date(),dob)/365) as age from dataofcustomer
where datediff(current_date(),dob) > 30*365 ; 

select * from dataofcustomer
where month(dob) = month(current_date()) ; 

select fname,lname from dataofcustomer 
where lower(substr(lname,1,1)) in ('a','d','m','w'); 

select concat(upper(lname), convert(age, char))
from dataofcustomer
where lower(substr(lname,1,1)) in ('a','d','m','w'); 

select fname,lname,age,
(case 
when age between 20 and 30 then 'young'
when age between 30 and 40 then 'old'
when age between 40 and 50 then 'Too old'
else 'Too damn old' end) as age_group 
from dataofcustomer;
select fname,lname,age from dataofcustomer
where age between 30 and 40; 

select * from dataofcustomer 
where fname like '___y';

show tables; 
use demo3;

select * from account; 
select * from dataofcustomer;

select d.fname,d.mname,d.lname, a.acnumber, a.bid, a.aod 
from dataofcustomer d inner join account a
on d.custid = a.custid; 

select concat(d.fname, ' ' ,mname,' ' ,d.lname) as customer_name, a.acnumber, a.bid, a.aod 
from dataofcustomer d inner join account a
on d.custid = a.custid
where year(a.aod) = '2021';  

select concat(d.fname, ' ' ,d.mname,' ' ,d.lname) as customer_name, a.acnumber, a.bid, a.aod 
from dataofcustomer d inner join account a
on d.custid = a.custid
where year(a.aod) between '2020' and '2022';

select concat(substr(fname,1,3),' ', substr(lname,1,3)) INITIALS from dataofcustomer;