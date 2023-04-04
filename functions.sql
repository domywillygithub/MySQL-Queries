call eAge('Andrew', 'Fuller', @a);
select @a as age; 

select * from employees; 

create function full_name(first_nm varchar(30), last_nm varchar(30))
returns varchar(50) deterministic 
return concat(first_nm, ' ', last_nm); 

select EmployeeID, full_name(FirstName, LastName) as Full_Name, timestampdiff(year, birthdate,now()) as Age
from employees; 
