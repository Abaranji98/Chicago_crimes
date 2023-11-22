--create database as chicago project

create database chicago_project;

--create a table chicago areas

create table chicago_areas
(
	community_id int,
	name varchar(100),
	population bigint,
	area_sq_mi decimal(4,2),
	density decimal(10,5)
);

-- import the data from the source data and check all the data is upload successfully
-- now you can see the data is successfully uploaded and view the data using select command below

select * from chicago_areas;

--create a table chicago_crime_2018

create table chicago_crime_2018 
(
	date_reported date,
	city_block varchar(100),
	primary_type varchar(100),
	primary_description	varchar(100), 
	location_description varchar(200),	
	arrest bool,
	domestic bool,
	community_area int,
	year text,	
	latitude text,
	longitude text,
	location text
);

-- import the data from the source data and check all the data is upload successfully
-- now you can see the data is successfully uploaded and view the data using select command below

select * from chicago_crime_2018;

--create a table chicago_crime_2019

create table chicago_crime_2019 
(
	date_reported date,
	city_block varchar(100),
	primary_type varchar(100),
	primary_description	varchar(100), 
	location_description varchar(200),	
	arrest bool,
	domestic bool,
	community_area int,
	year text,	
	latitude text,
	longitude text,
	location text
);

-- import the data from the source data and check all the data is upload successfully
-- now you can see the data is successfully uploaded and view the data using select command below

select * from chicago_crime_2019;

--create a table chicago_crime_2020

create table chicago_crime_2020
(
	date_reported date,
	city_block varchar(100),
	primary_type varchar(100),
	primary_description	varchar(100), 
	location_description varchar(200),	
	arrest bool,
	domestic bool,
	community_area int,
	year text,	
	latitude text,
	longitude text,
	location text
);

-- import the data from the source data and check all the data is upload successfully
-- now you can see the data is successfully uploaded and view the data using select command below

select * from chicago_crime_2020;

--create a table chicago_crime_2021

create table chicago_crime_2021
(
	date_reported date,
	city_block varchar(100),
	primary_type varchar(100),
	primary_description	varchar(100), 
	location_description varchar(200),	
	arrest bool,
	domestic bool,
	community_area int,
	year text,	
	latitude text,
	longitude text,
	location text
);

-- import the data from the source data and check all the data is upload successfully
-- now you can see the data is successfully uploaded and view the data using select command below

select * from chicago_crime_2021;

--create a table chicago_crime_2022

create table chicago_crime_2022
(
	date_reported date,
	city_block varchar(100),
	primary_type varchar(100),
	primary_description	varchar(100), 
	location_description varchar(200),	
	arrest bool,
	domestic bool,
	community_area int,
	year text,	
	latitude text,
	longitude text,
	location text
);

-- import the data from the source data and check all the data is upload successfully
-- now you can see the data is successfully uploaded and view the data using select command below

select * from chicago_crime_2022;

-- Create a table weather_data

CREATE TABLE weather_data (
    weather_date DATE,
    temp_high int,
    temp_low int,
    average decimal(5,3),
    precipitation decimal(5,3)
);

-- import the data from the source data and check all the data is upload successfully
-- now you can see the data is successfully uploaded and view the data using select command below

select * from weather_data;

-- now we are successfully imported all the data from the csv

-- Check how many tables are present in public;
-- this shows we are create 7 tables in this database

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- lets check what are the insights can be obtained from the table chicago_areas
-- finding how the population is distibuted among the chicago_areas

SELECT community_id, name, population
FROM chicago_areas
ORDER BY population DESC;

-- let find the min poplutation area and maximum population area

SELECT community_id, name, population
FROM chicago_areas
WHERE population = (SELECT MAX(population) FROM chicago_areas);

SELECT community_id, name, population
FROM chicago_areas
WHERE population = (SELECT MIN(population) FROM chicago_areas);

-- let find the no of areas available in chicago:

SELECT  distinct(count name) AS No_of_chicago_areas
FROM chicago_areas

--let see the population density 

SELECT community_id, name, population, area_sq_mi, ROUND(population/area_sq_mi, 2) AS population_density
FROM chicago_areas
ORDER BY population_density DESC;

-- let find the min poplutation area and maximum population area

SELECT community_id, name, area_sq_mi
FROM chicago_areas
WHERE area_sq_mi = (SELECT MAX(area_sq_mi) FROM chicago_areas);

SELECT community_id, name, area_sq_mi
FROM chicago_areas
WHERE area_sq_mi = (SELECT MIN(area_sq_mi) FROM chicago_areas);

 -- checking Small Areas with Higher Population:
 
SELECT community_id, name, population, area_sq_mi, ROUND(population/area_sq_mi, 2) AS population_density
FROM chicago_areas
WHERE population > 10000 and area_sq_mi < 1 
ORDER BY population DESC;

 -- checking large Areas with less Population:
 
SELECT community_id, name, population, area_sq_mi, ROUND(population/area_sq_mi, 2) AS population_density
FROM chicago_areas
WHERE population > 70000 and area_sq_mi > 7 
ORDER BY population DESC;

-- checking percentage change in the density in ascending with how much it lagging from previous

SELECT community_id, name, population, area_sq_mi,
	   round(density,2) as density, round(prev_density,2) as prev_density,
       CASE WHEN prev_density = 0 THEN NULL
            ELSE concat(ROUND(((density - prev_density) / prev_density * 100),2),'%')
       END AS density_change_percentage
FROM (
  SELECT 
    community_id, name, population, area_sq_mi, density, 
    LAG(density, 1, 0) OVER (ORDER BY density) AS prev_density
  FROM chicago_areas
) AS subtable
WHERE density > prev_density
ORDER BY density ASC

select * from chicago_crime_2018;

-- checking how many crimes are happen in respected areas in chicago in 2018

SELECT a.community_area, c.name, COUNT(*) AS crime_count
FROM chicago_crime_2018 a
JOIN chicago_areas c ON a.community_area = c.community_id
GROUP BY a.community_area, c.name;

-- In this we can able to get crime types along with no of crime happen in thos categories

SELECT distinct (primary_type), COUNT(*) AS crime_count
FROM  chicago_crime_2018
GROUP BY primary_type
ORDER BY crime_count DESC;

-- we want to see how many crime with location description in 2018

SELECT location_description, COUNT(*) AS crime_count
FROM chicago_crime_2018
GROUP BY location_description
ORDER BY crime_count DESC;

-- no of criminal were arrested 

SELECT arrest, COUNT(*) AS crime_count
FROM chicago_crime_2018
GROUP BY arrest;

--same can be done for all the years from 2018 t0 2022

-- now lets combine all the tables and get the year wise crime count

SELECT year, COUNT(*) AS crime_count
FROM (
    SELECT year FROM chicago_crime_2018
    UNION ALL
    SELECT year FROM chicago_crime_2019
    UNION ALL
    SELECT year FROM chicago_crime_2020
    UNION ALL
    SELECT year FROM chicago_crime_2021
    UNION ALL
    SELECT year FROM chicago_crime_2022
) AS combined_data
GROUP BY year
ORDER BY year;

-- total crime from year 2018 to 2022 with typewise count

SELECT primary_type, COUNT(*) AS crime_count
FROM (
    SELECT * FROM chicago_crime_2018
    UNION ALL
    SELECT * FROM chicago_crime_2019
    UNION ALL
    SELECT * FROM chicago_crime_2020
    UNION ALL
    SELECT * FROM chicago_crime_2021
    UNION ALL
    SELECT * FROM chicago_crime_2022
) AS combined_data
GROUP BY primary_type
ORDER BY crime_count DESC;

-- Daily how much crime happening in every year

SELECT
  EXTRACT(YEAR FROM w.weather_date) AS year,
  w.weather_date,
  COUNT(*) AS crime_count
FROM
  (
    SELECT * FROM chicago_crime_2018
    UNION ALL
    SELECT * FROM chicago_crime_2019
    UNION ALL
    SELECT * FROM chicago_crime_2020
    UNION ALL
    SELECT * FROM chicago_crime_2021
    UNION ALL
    SELECT * FROM chicago_crime_2022
  ) AS c
JOIN weather_data w ON c.date_reported = w.weather_date
GROUP BY year, w.weather_date
ORDER BY year, w.weather_date;

-- combining all the chicago_crimes from 2018 t0 2022

SELECT 
    date_reported, 
    city_block, 
    primary_type, 
    primary_description, 
    location_description, 
    arrest, 
    domestic, 
    community_area, 
    year
FROM 
    (
        SELECT date_reported, city_block, primary_type, primary_description, location_description, arrest, domestic, community_area, year FROM chicago_crime_2018
        UNION ALL
        SELECT date_reported, city_block, primary_type, primary_description, location_description, arrest, domestic, community_area, year FROM chicago_crime_2019
        UNION ALL
        SELECT date_reported, city_block, primary_type, primary_description, location_description, arrest, domestic, community_area, year FROM chicago_crime_2020
        UNION ALL
        SELECT date_reported, city_block, primary_type, primary_description, location_description, arrest, domestic, community_area, year FROM chicago_crime_2021
        UNION ALL
        SELECT date_reported, city_block, primary_type, primary_description, location_description, arrest, domestic, community_area, year FROM chicago_crime_2022
    ) AS combined_data;

SELECT 
    cc.*,
    ca.name AS community_name,
    ca.population,
    ca.area_sq_mi,
    ca.density,
    wd.temp_high,
    wd.temp_low,
    wd.average AS weather_average,
    wd.precipitation AS weather_precipitation
FROM (
    SELECT * FROM chicago_crime_2018
    UNION ALL
    SELECT * FROM chicago_crime_2019
    UNION ALL
    SELECT * FROM chicago_crime_2020
    UNION ALL
    SELECT * FROM chicago_crime_2021
    UNION ALL
    SELECT * FROM chicago_crime_2022
) cc
JOIN chicago_areas ca ON cc.community_area = ca.community_id
JOIN weather_data wd ON cc.date_reported = wd.weather_date;

