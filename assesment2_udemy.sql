select * from cd.facilities;
select distinct(name),membercost from cd.facilities;

select * from cd.facilities
where membercost > 0;

select facid,name,membercost,monthlymaintenance 
from cd.facilities
where membercost > 0
and membercost < (monthlymaintenance)/50;

select * 
from cd.facilities
where name like '%Tennis%';

select * 
from cd.facilities
where facid in (1,5);

select memid,surname,firstname,joindate
from cd.members
where extract(month from joindate)>8;

select distinct surname
from cd.members
order by surname asc
limit 10;

select joindate 
from cd.members
order by joindate desc
limit 1;

select count(*)
from cd.facilities
where guestcost>10;

select facid,sum(slots)
from cd.bookings
where extract(month from starttime) = 9
group by facid
order by sum(slots);

select facid,sum(slots) as total_sales
from cd.bookings
group by facid
having sum(slots)>1000
order by facid;

select b.starttime as start,f.name
from cd.bookings as b
inner join cd.facilities as f
on f.facid=b.facid
where f.name like 'Ten%' and
extract(month from b.starttime)=09
and extract (day from b.starttime)=21;

select b.memid,b.starttime 
from cd.bookings as b
where b.memid=
(select m.memid from cd.members as m
where m.firstname='David' and m.surname='Farrell');



