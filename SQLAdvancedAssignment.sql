select * from bigquery-public-data.census_bureau_usa.population_by_zip_2010 limit 1;

--I need total Population in zipcode 94085 (Sunnyvale CA)
select zipcode, sum(population) as total_population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085'
group by zipcode;

/*zipcode	total_population
	94085	63741*/

--I need number of Male and Female head count in zipcode 94085 (Sunnyvale CA)
select distinct gender 
from bigquery-public-data.census_bureau_usa.population_by_zip_2010;

select zipcode,
sum(case gender
when 'male' then population else 0 end)as Male_count,
sum(case gender when 'female' then population else 0 end)as Female_count
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085'
group by zipcode;
/*zipcode	Male_count	Female_count
	94085	22314	20180*/
--I want which Age group has max headcount for both male and female genders combine (zipcode 94085 (Sunnyvale CA))
select concat(minimum_age,' to ',maximum_age) as Age_Group,zipcode,
sum(population) as max_headcount_per_agegroup
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085' and (gender='male' or gender='female') and minimum_age >0 and maximum_age>0
group by concat(minimum_age,' to ',maximum_age),zipcode
order by sum(population) desc
limit 1;
/*Ignored rows where gender,maxi_age and min_age has null values
Age_Group	zipcode	max_headcount_per_agegroup
	30 to 34	94085	2908*/
--I want age group for male gender which has max male population zipcode 94085 (Sunnyvale CA))

select concat(minimum_age,' to ',maximum_age) as Age_Group,zipcode,
sum(population) as max_male_population_agegroup
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085' and gender='male' and minimum_age >0 and maximum_age>0
group by concat(minimum_age,' to ',maximum_age),zipcode
order by sum(population) desc
limit 1;
/*
Age_Group	zipcode	max_male_population_agegroup
	30 to 34	94085	1622 */
--I want age group for female gender which has max female population zipcode 94085 (Sunnyvale CA))
select concat(minimum_age,' to ',maximum_age) as Age_Group,zipcode,
sum(population) as max_female_population_agegroup
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where zipcode='94085' and gender='female' and minimum_age >0 and maximum_age>0
group by concat(minimum_age,' to ',maximum_age),zipcode
order by sum(population) desc
limit 1;
/*Age_Group	zipcode	max_female_population_agegroup
	25 to 29	94085	1298*/
--I want zipcode which has highest male and female population in USA
select zipcode, sum(case gender when 'male' then population else 0 end) as total_male_population, 
sum(case gender when 'female' then population else 0 end) as total_female_population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
group by zipcode
order by sum(case gender when 'male' then population else 0 end) desc, 
sum(case gender when 'female' then population else 0 end) desc
limit 1;
/*zipcode	total_male_population	total_female_population
	11368	116842	103020*/
--I want first five age groups which has highest male and female population in USA

select concat(minimum_age,' to ',maximum_age) as Age_Group, sum(case gender when 'male' then population else 0 end) as total_male_population, 
sum(case gender when 'female' then population else 0 end) as total_female_population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where minimum_age>0 and maximum_age>0
group by concat(minimum_age,' to ',maximum_age)
order by sum(case gender when 'male' then population else 0 end) desc, 
sum(case gender when 'female' then population else 0 end) desc
limit 5;

/*Age_Group	total_male_population	total_female_population
1	45 to 49	11324082	11631883
2	50 to 54	11043452	11493914
3	25 to 29	10753264	10591689
4	10 to 14	10717038	10228514
5	5 to 9	10512762	10075703*/

--I want first five zipcodes which has highest female population in entire USA

select zipcode,
sum(case gender when 'female' then population else 0 end) as total_female_population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where minimum_age>0 and maximum_age>0
group by zipcode
order by sum(case gender when 'female' then population else 0 end) desc
limit 5;

/*zipcode	total_female_population
1	926	54138
2	79936	53237
3	11226	51907
4	60629	51830
5	11236	49076	*/

--I want first 10 which has lowest male population in entire USA

select zipcode,
sum(case gender when 'male' then population else 0 end) as total_male_population
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where minimum_age>0 and maximum_age>0
group by zipcode
order by sum(case gender when 'male' then population else 0 end) asc
limit 10;
/*zipcode	total_male_population
1	11371	0
2	80290	0
3	2203	0
4	70139	0
5	11424	0
6	11351	0
7	48397	0
8	7495	0
9	19109	0
10	48242	0 */

select zipcode,population 
from bigquery-public-data.census_bureau_usa.population_by_zip_2010
where population=0;