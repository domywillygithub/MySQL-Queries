SELECT * FROM book.mysample; 
use book; 
show tables; 

select * from mysample; 

select * from mysample 
where UnitCost > (select AVG(UnitCost) from mysample); 

select * from mysample m 
join (select AVG(UnitCost) as avgunicost from mysample) avg_unitcost
on m.UnitCost > avg_unitcost.avgunicost; 

select region,max(unitcost) from mysample
group by region; 

select * from mysample 
where (region, unitcost) in (select region,max(unitcost) from mysample
                              group by region);  
                              
                              
select * from mysample
where unitcost not in (19.99,1.99,4.99);      

select region,rep,units,units-avg(units) as raisedbar from mysample
group by region;  

select region, rep,units, avg(units) from mysample
group by region;   

select avg(units) from mysample where region = 'West'; 
select avg(units) from mysample where region = 'Central'; 
select avg(units) from mysample where region = 'East';

select * from mysample m1
where units > (select avg(units) from mysample m2
                where m2.region = m1.region
                ) ;
                
select region,rep,max(units) from mysample
group by region;    

select * from mysample 
where (rep,max(units)) in (select rep,max(units) from mysample
                              group by region);        
                              
                              
select region, sum(units) Total_units from mysample
group by region; 

select avg(Total_Units) 
from (select region, sum(units) Total_units from mysample
       group by region) x  ;   
       
select *
from (select region, sum(units) Total_units from mysample
       group by region) sales     
join (select avg(Total_Units) as sales 
from (select region, sum(units) Total_units from mysample
       group by region) x ) avg_sales 
       on sales.Total_units > avg_sales.sales; 
       
       
with sales as 
(select region, sum(units) Total_units from mysample
       group by region) 
 select * from sales    
join (select avg(Total_Units) as sales 
from sales x ) avg_sales 
       on sales.Total_units > avg_sales.sales;  