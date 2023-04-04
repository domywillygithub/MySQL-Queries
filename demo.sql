create database Mysqldemo;

use Mysqldemo;

create table student_table (
       student_id INT,
       student_name VARCHAR(100),
       course_name VARCHAR(40)
       ); 
       
show tables;   

describe student_table;   

INSERT INTO student_table (student_id,student_name,course_name,email) 
VALUES (1, "Ushna", "Phyton", 'ushna@gmail.com' );  

INSERT INTO student_table (student_id,student_name,course_name,email) 
VALUES (2, "Usta", "Phytsics", 'usta@gmail.com' );  

INSERT INTO student_table (student_id,student_name,course_name,email) 
VALUES (3, "Ujna", "Philosophy", 'ujna@gmail.com' );  

INSERT INTO student_table (student_id,student_name,course_name,email) 
VALUES (4, "Ukna", "Biology", 'ukna@gmail.com' );  

INSERT INTO student_table (student_id,student_name,course_name,email) 
VALUES (5, "Ubona", "ton", 'ubona@gmail.com' );
Alter table student_table add email varchar(100);     

select student_id from student_table;  

select student_id,email,course_name from student_table;  

select * from student_table;  

select * from student_table where course_name = "Biology" ;   

select * from student_table where course_name = "Biology" and student_id = 9 ;  

select * from student_table where course_name = "Biology" or student_id = 9 ;  

select * from student_table where not student_name = "Ukna";  

select * from student_table where course_name in ("Biology" , "Philosophy");  

select * from student_table where student_id between 2 AND 3;  

select * from student_table where email like "u%";  

INSERT INTO student_table (student_id,student_name,course_name,email) 
VALUES (6, "Ukoa", "Phoen");   
INSERT INTO student_table (student_id,student_name,course_name,email) 
VALUES (7, "kaba", "chemistry");  
select * from student_table;