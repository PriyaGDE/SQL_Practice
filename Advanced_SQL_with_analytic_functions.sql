select * from bigquery-public-data.census_bureau_usa.population_by_zip_2010 limit 1;

--I need total Population in zipcode 94085 (Sunnyvale CA)
select zipcode, sum(population) as total_population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085'
group by zipcode;

/*zipcode	total_population
	94085	63741*/

--I need number of Male and Female head count in zipcode 94085 (Sunnyvale CA)
--- the sum() over () windows function is used
select distinct zipcode,
sum(case when gender='male'then population else 0 end) 
  over(partition by zipcode) as Male_count,
sum(case when gender='female' then population else 0 end)
  over(partition by zipcode) as Female_count
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085';
/*
zipcode	Male_count	Female_count
	94085	  22314	      20180
*/

--I want which Age group has max headcount for both male and female genders combine (zipcode 94085 (Sunnyvale CA))
--replaced group by and limit with windows and rank functions
with base_query as
(select concat(minimum_age,' to ',maximum_age) as Age_Group,zipcode,population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085' and (gender='male' or gender='female') and minimum_age >0 and maximum_age>0),
total_count as
(select *,sum(population) over(partition by Age_Group,zipcode) as max_headcount_per_agegroup from base_query),
rank_query as 
(select *,rank() over (partition by zipcode order by max_headcount_per_agegroup desc) as rank_1
from total_count)
select distinct zipcode,Age_Group,max_headcount_per_agegroup
from rank_query
where rank_1=1;

/*
zipcode	Age_Group	max_headcount_per_agegroup
	94085	30 to 34	2908
*/

--I want age group for male gender which has max male population zipcode 94085 (Sunnyvale CA))
with base_query as
(select concat(minimum_age,' to ',maximum_age) as Age_Group,zipcode,population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085' and gender='male' and minimum_age >0 and maximum_age>0),
total_count as
(select *,sum(population) over(partition by Age_Group,zipcode) as max_male_population_agegroup from base_query),
rank_query as 
(select *,rank() over (partition by zipcode order by max_male_population_agegroup desc) as rank_1
from total_count)
select distinct zipcode,Age_Group,max_male_population_agegroup
from rank_query
where rank_1=1;
/*
zipcode	Age_Group	max_male_population_agegroup
	94085	30 to 34	1622
*/

--I want age group for female gender which has max female population zipcode 94085 (Sunnyvale CA))

with base_query as
(select concat(minimum_age,' to ',maximum_age) as Age_Group,zipcode,population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085' and gender='female' and minimum_age >0 and maximum_age>0),
total_count as
(select *,sum(population) over(partition by Age_Group,zipcode) as max_female_population_agegroup from base_query),
rank_query as 
(select *,rank() over (partition by zipcode order by max_female_population_agegroup desc) as rank_1
from total_count)
select distinct zipcode,Age_Group,max_female_population_agegroup
from rank_query
where rank_1=1;
/*
zipcode	Age_Group	max_female_population_agegroup
	94085	  25 to 29	1298
*/

--I want zipcode which has highest male and female population in USA
with base_query as 
(select zipcode,population,gender
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where gender in ('male','female')),
total_population as
(select zipcode, sum(case gender when 'male' then population else 0 end) over (partition by zipcode) as total_male_population,
sum(case gender when 'female' then population else 0 end) over (partition by zipcode) as total_female_population
from base_query),
rank_query as 
(select distinct zipcode,total_male_population,total_female_population,
rank() over ( order by total_male_population desc, total_female_population desc)as rank_1 from total_population)
select zipcode,total_male_population,total_female_population
from rank_query
where rank_1=1;
/*zipcode	total_male_population	total_female_population
	11368	    116842	              103020*/

--I want first five age groups which has highest male and female population in USA
with base_query as 
(select population,gender,concat(minimum_age,' to ',maximum_age) as Age_Group
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where minimum_age>0 and maximum_age>0 and gender in ('male','female')),
top_five_agegroup as 
(select Age_group, sum(case gender when 'male' then population else 0 end) over (partition by Age_group) as total_male_population, 
sum(case gender when 'female' then population else 0 end) over (partition by Age_group) as total_female_population from base_query),
remove_duplicates as
(select distinct Age_group,total_male_population, total_female_population from top_five_agegroup ),
rank_query as 
(select Age_group,total_male_population,total_female_population,
rank() over (order by total_male_population desc,total_female_population desc)as rankoffive from remove_duplicates)
select Age_Group,total_male_population,total_female_population
from rank_query
where rankoffive<=5
order by rankoffive;

/*Age_Group	total_male_population	total_female_population
1	45 to 49	11324082	11631883
2	50 to 54	11043452	11493914
3	25 to 29	10753264	10591689
4	10 to 14	10717038	10228514
5	5 to 9	10512762	10075703*/

--I want first five zipcodes which has highest female population in entire USA
with base_query as 
(select zipcode,population,gender
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where gender in ('male','female')),
top_five_zipcode as 
(select zipcode, sum(case gender when 'female' then population else 0 end) over (partition by zipcode) as total_female_population from base_query),
remove_duplicates as
(select distinct zipcode, total_female_population from top_five_zipcode ),
rank_query as 
(select zipcode,total_female_population,
rank() over (order by total_female_population desc)as rankoffive from remove_duplicates)
select zipcode,total_female_population,rankoffive
from rank_query
where rankoffive<=5
order by rankoffive;
/*
zipcode	total_female_population	rankoffive
1	926	117314	1
2	79936	115690	2
3	60629	115352	3
4	11226	112238	4
5	90650	106370	5	
*/
--I want first 10 which has lowest male population in entire USA
with base_query as 
(select zipcode,population,gender
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where minimum_age>0 and maximum_age>0 and gender ='male'),
low_male_population as 
(select zipcode,sum(population) over (partition by zipcode) as total_male_population from base_query),
remove_duplicates as 
(select distinct zipcode,total_male_population from low_male_population),
rank_query as 
(select zipcode, total_male_population ,
row_number() over (order by total_male_population) as row_num from remove_duplicates)
select zipcode, total_male_population
from rank_query
where row_num<=10
order by row_num;

/*
zipcode	total_male_population
1	39269	0
2	20551	0
3	42356	0
4	20053	0
5	40231	0
6	11451	0
7	10153	0
8	17822	0
9	48554	0
10	48551	0
*/