create table students (
student_id integer primary key,
first_name varchar(100),
last_name varchar(100),
homeroom_number integer,
phone varchar(100) not null unique,
email varchar(300) not null unique,
graduation_year integer
);

create table teachers(
teacher_id integer primary key, 
first_name varchar(100), 
last_name varchar(100),
homeroom_number integer, 
department varchar(100),
email varchar(300) not null unique, 
phone varchar(250) not null unique
);
--insert a student named Mark Watney (student_id=1) 
--who has a phone number of 777-555-1234 and doesn't have an email. 
--He graduates in 2035 and has 5 as a homeroom number.

alter table students
alter email drop not null;

insert into students
(student_id,first_name,last_name,homeroom_number,phone,graduation_year)
values
(1,'Mark','Watney',5,'777-555-1234',2035);


insert into teachers
(teacher_id,first_name,last_name,homeroom_number,department,email,phone)
values
(1,'Jonas','Salk',5,'Biology','jsalk@school.org','777-555-4321');

select * from teachers;
