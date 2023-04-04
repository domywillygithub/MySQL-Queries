SELECT * FROM book.mysample;

use book;
select * from mysample; 

select distinct(Region) from mysample; 

select * 
from (select *, 
row_number() over (partition by Region order by OrderDate) as rn
from mysample
order by Region) x
where x.rn > 10; 

select rep1.*
from mysample rep1
join mysample rep2 on rep1.Region <> rep2.Region and rep1.Item = rep2.Item
and rep1.UnitCost = rep2.UnitCost; 

select * from (select * ,
case when Units > 50
        and lead(Units) over (order by OrderDate) > 50
        and lead(Units,2) over (order by OrderDate) > 50
        then 'Goal reached'
        when Units > 50
        and lag(Units) over (order by OrderDate) > 50
        and lead(Units) over (order by OrderDate) > 50
		then 'Goal reached'
         when Units > 50
        and lag(Units) over (order by OrderDate) > 50
        and lag(Units,2) over (order by OrderDate) > 50
		then 'Goal reached'
        else null 
end as 'Goals'        
from mysample) x 
where x.Goals = 'Goal reached'; 