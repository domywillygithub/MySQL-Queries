create database demo3; 

use demo3; 

show tables; 

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

select * from dataofcustomer; 

create table account 
(
acnumber varchar(6),
custid varchar(6),
bid varchar(6),
opening_balance int(7),
aod date,
atype varchar(10),
astatus varchar(10),
constraint account_acnumber_pk primary key (acnumber),
constraint account_custid_fk foreign key (custid) references dataofcustomer(custid) 
); 

select * from account; 
insert into account values ('A0001', 'c001', 'B0001', 100, '2020-09-12','Saving', 'Active'); 
insert into account values ('A0002', 'c002', 'B0002', 100, '2021-10-19','Saving', 'Active'); 
insert into account values ('A0003', 'c003', 'B0003', 100, '2004-11-12','Saving', 'Active'); 
insert into account values ('A0004', 'c004', 'B0004', 100, '2003-09-11','Saving', 'Active'); 
insert into account values ('A0005', 'c005', 'B0005', 100, '2019-10-23','Saving', 'Suspended'); 
insert into account values ('A0006', 'c006', 'B0006', 100, '2018-03-24','Saving', 'Terminated'); 
insert into account values ('A0007', 'c007', 'B0007', 100, '2016-11-12','Saving', 'Active'); 
insert into account values ('A0008', 'c008', 'B0008', 100, '2010-10-26','Saving', 'Active'); 
insert into account values ('A0009', 'c009', 'B0009', 100, '2009-07-25','Saving', 'Terminated'); 
insert into account values ('A0010', 'c0010', 'B0010', 100, '2022-06-02','Saving', 'Active'); 

select * from account; 

select custid,astatus from account where custid = any (select custid from dataofcustomer where city = 'Tokyo'); 

select custid from account where custid = all (select custid from dataofcustomer where city = 'Tokyo'); 

select custid,fname,age, 
case 
when age > 36 then 'Age is greater than 36'
when age = 36 then  'Age is equal to 36'
else 'the age is not in group of 36'
end as 'age_information'
from dataofcustomer; 

select fname,city,age
from dataofcustomer
order by 
(case 
when city is null then 'no city'
else city 
end); 

create view agedcustomers as
select fname,city,age
from dataofcustomer
where age>=45;
 
 select * from agedcustomers; 
 /* baba kasema kila mtu kwao 
 imeisha hiyo .
 */
 select distinct(city) from dataofcustomer;
 select count(*) from dataofcustomer; 
 
 select max(age) from dataofcustomer; 
 
 select age,city from dataofcustomer
     where city = 'Tokyo' ; 
     
use mydemo1; 
show tables;  

select fname,lname,city from dataofcustomer
where city <> "Delhi" ;     
 