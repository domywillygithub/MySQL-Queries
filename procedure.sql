create or replace procedure extrPrice(in cname varchar(40), in aggr varchar(3),out pname varchar(30))
begin 

select productname into pname from products p join categories c on p.categoryID=c.categoryid join
(
select aggr(unitprice) as e from products p join categories c on  p.categoryID=c.categoryid
where categoryname=cname
) s on p.UnitPrice=s.m
where c.categoryname=cname;
end 

call extrPrice('Beverages', 'MAX', @P)