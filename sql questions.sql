CREATE DATABASE POWERBI;
use powerbi;
select * from billings; 

insert into billings values (1, 'A', 'id1','2020-10-10', 100);
insert into billings values (1, 'A', 'id2','2021-11-11', 150);
insert into billings values (1, 'A', 'id3','2020-11-12', 100);
insert into billings values (2, 'B', 'id4','2019-11-10', 150);
insert into billings values (2, 'B', 'id5','2020-11-11', 200);
insert into billings values (2, 'B', 'id6','2021-11-12', 250);
insert into billings values (3, 'C', 'id7','2018-01-01', 100);
insert into billings values (3, 'C', 'id8','2019-01-05', 250);
insert into billings values (3, 'C', 'id9','2021-01-06', 300);

with cte as (
SELECT CUSTOMER_ID, CUSTOMER_NAME, 
sum(CASE WHEN date_format(Billing_creation_date, '%Y') = 2019 then Billings_ammount else 0 end) as sum_2019,
cast(sum(CASE WHEN date_format(Billing_creation_date, '%Y') = 2019 then Billings_ammount else 0 end) as decimal(10,2)) as sum_2019_decimal,
sum(CASE WHEN date_format(Billing_creation_date, '%Y') = 2020 then Billings_ammount else 0 end) as sum_2020,
cast(sum(CASE WHEN date_format(Billing_creation_date, '%Y') = 2020 then Billings_ammount else 0 end) as decimal(10,2)) as sum_2020_decimal,
sum(CASE WHEN date_format(Billing_creation_date, '%Y') = 2021 then Billings_ammount else 0 end) as sum_2021,
cast(sum(CASE WHEN date_format(Billing_creation_date, '%Y') = 2021 then Billings_ammount else 0 end) as decimal(10,2)) as sum_2021_decimal,
count(CASE WHEN date_format(Billing_creation_date, '%Y') = 2019 then Billings_ammount else null end) as count_2019,
count(CASE WHEN date_format(Billing_creation_date, '%Y') = 2020 then Billings_ammount else null end) as count_2020,
count(CASE WHEN date_format(Billing_creation_date, '%Y') = 2021 then Billings_ammount else null end) as count_2021
FROM BILLINGS
GROUP BY CUSTOMER_ID, CUSTOMER_NAME)
select customer_id,customer_name,
round((sum_2019_decimal + sum_2020_decimal + sum_2021_decimal)/(case when count_2019 =0 then 1 else count_2019 end 
+ case when count_2020 =0 then 1 else count_2020 end 
+ case when count_2021=0 then 1 else count_2021 end),2)as average_billings_amount
from cte
