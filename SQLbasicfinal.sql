--all queries are executed based on PostgreSQL syntax in the pgadmin tool
--created three tables

create table address(
add_id integer Primary Key,
country varchar(100),
state varchar(100), 
city varchar(150),			
street varchar(350),
zipcode integer, 
pre_known_add json,
created_ts timestamp,
last_updated_ts	timestamp
);

create table DEPARTMENT(
department_id integer Primary Key, 
department_name	varchar(50),
department_code	char(4) NOT NULL, 
address_id integer, 
dept_head_id integer NOT NULL,
constraint addresspk
	foreign key (address_id) references address(add_id) on delete set null
);


create table emp(
emp_id integer Primary Key, 
first_name varchar(100) NOT NULL, 
last_name varchar(100),
email varchar(250) NOT NULL,
phone_number varchar(100) NOT NULL,
dept_id	integer,
address_id integer,
blood_group varchar(50),
dob	date,
doj	date, 
dot	date, 
created_ts timestamp, 
reference varchar(300),
role varchar(100), 
salary float,
band integer, 
reports_to integer,
constraint deptfk
	foreign key (dept_id) references department(department_id) on delete set null,
constraint addfk
	foreign key (address_id) references address(add_id) on delete set null
);



--insert values into three tables

insert into address values 
(11,'united states','california','fremont','42555 cresley ave',96511,'{"old_add":"345,foaint street"}',current_timestamp,current_timestamp);

insert into address values 
(22,'united states','losangles','manteca','1422 santa ave',96512,'{"old_add":"3453,main street"}',current_timestamp,current_timestamp);

insert into address values 
(33,'united states','reno','mountain view','222 text ave',95335,'{"old_add":"444,saint street"}',current_timestamp,current_timestamp);


insert into department 
values (111,'IT','itxx',11,78);

insert into department 
values (222,'Network','nwxx',22,66);

insert into department 
values (333,'Backup','nwxx',33,46);

insert into emp
values (
1,'nilani','babu','nilanibabu@gmail.com','45637896547',111,11,'A+','1991-10-08','2015-11-10',
current_date,current_timestamp,'suresh mohan','IT manager',
125000.00,11,36
);
insert into emp
values (
2,'ilan','babu','ilanbabu@gmail.com','45637886547',222,22,'B+','1996-07-08','2016-12-21',
current_date,current_timestamp,'mohan raju','network manager',
100000.00,10,45
);
insert into emp
values (
3,'ilan','babu','ilanbabu@gmail.com','45637886547',333,33,'A-','1998-05-02','2019-02-07',
current_date,current_timestamp,'raju muthu','backup manager',
90000.00,03,32
);

--update into all three tables

update emp 
set last_name = 'suresh'
where emp_id=2
returning emp_id,first_name,last_name;

update department
set dept_head_id=89
where department_id =111
returning department_id,dept_head_id;

update address
set city = 'hollywood'
where add_id=22
returning add_id,city;


select * from emp;

select * from address;

select * from department;

---delete from all three tables
--delete error fixed with adding delete on null in the create statement

delete from address where add_id = 22;

delete from department where department_id= 222;

delete from emp where emp_id =2;

select * from emp;
select * from address;
select * from department;
--DROP Column reports_to from EMP Table
alter table emp
drop column reports_to;

--DROP column dept_head_id from DEPARTMENT Table
alter table department
drop column dept_head_id;

select * from emp;
--Change EMP.band column to STRING Type
alter table emp
alter column band type varchar(50);

--Find out EMP Age by using EMP.dob column
select * from emp;
select age(dob)
from emp
where emp_id=3;

--Print todays date 
select current_date;

--Find out EMP experience with this company by using  EMP.doj column
select age(doj)
from emp
where emp_id=3;

--Add column EMP.comment_col to EMP table
alter table emp
add column comment_col varchar(300);

select * from emp;

--Add column DEPARTMENT.comment_col to DEPARTMENT table 
alter table department
add column comment_col varchar(300);

--Add column ADDRESS.comment_col to ADDRESS table 
alter table address
add column comment_col varchar(300);

--Truncate all the tables
truncate table address cascade;
truncate table department cascade;
truncate table emp cascade;

select * from department;

--Create a view on top of EMP , DEPARTMENT & ADDRESS Tables
create view emp_details as
select 
emp.emp_id, 
case 
when emp.last_name is not null 
then concat(emp.first_name , ' ' , emp.last_name) 
else emp.first_name 
end as name, 
concat(address.street, ', ', address.city, ', ', address.state, ', ', address.country,', ', address.zipcode) 
as address,
department.department_name as dept_name,
EMP.salary as salary
from emp inner join address on emp.address_id =address.add_id
inner join department on address.add_id = department.address_id;

select * from emp_details;

--DROP All tables 
drop table address cascade;
drop table department cascade;
drop table emp cascade;


