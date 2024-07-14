/*
Part 2 - Regional Outlook
Instructions:
Answering these questions will help you add information to the template.
Use these questions as guides to write SQL queries.
Use the output from the query to answer these questions.
Create a table that shows the Regions and their percent forest area (sum of forest area divided by the sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km)
*/




--Create a table that shows the Regions and their percent forest area (sum of forest area divided by the sum of land area) in 1990 and 2016.
CREATE TABLE regional_forest_area AS
SELECT
    r.region,
    SUM(CASE WHEN fa.year = 1990 THEN fa.forest_area_sqkm END) AS forest_area_1990,
    SUM(CASE WHEN la.year = 1990 THEN la.total_area_sq_mi END) * 2.59 AS land_area_1990_sqkm,
    SUM(CASE WHEN fa.year = 2016 THEN fa.forest_area_sqkm END) AS forest_area_2016,
    SUM(CASE WHEN la.year = 2016 THEN la.total_area_sq_mi END) * 2.59 AS land_area_2016_sqkm
FROM forest_area fa
JOIN land_area la ON fa.country_code = la.country_code AND fa.year = la.year
JOIN regions r ON fa.country_code = r.country_code
GROUP BY r.region;

--
select * from regional_forest_area;
--
-- references SQL_1\Result\part2\part2_regional_forest_area.csv

-- create table
CREATE TABLE combined_forest_data AS
SELECT
    r.region,
    SUM(CASE WHEN fa.year = 1990 THEN fa.forest_area_sqkm END) AS forest_area_1990,
    SUM(CASE WHEN la.year = 1990 THEN la.total_area_sq_mi END) * 2.59 AS land_area_1990_sqkm,
    SUM(CASE WHEN fa.year = 2016 THEN fa.forest_area_sqkm END) AS forest_area_2016,
    SUM(CASE WHEN la.year = 2016 THEN la.total_area_sq_mi END) * 2.59 AS land_area_2016_sqkm,
    ROUND(CAST(100.00 * (SUM(CASE WHEN fa.year = 1990 THEN fa.forest_area_sqkm END) / (SUM(CASE WHEN la.year = 1990 THEN la.total_area_sq_mi END) * 2.59)) AS NUMERIC), 2) AS percent_forest_1990,
    ROUND(CAST(100.00 * (SUM(CASE WHEN fa.year = 2016 THEN fa.forest_area_sqkm END) / (SUM(CASE WHEN la.year = 2016 THEN la.total_area_sq_mi END) * 2.59)) AS NUMERIC), 2) AS percent_forest_2016
FROM forest_area fa
JOIN land_area la ON fa.country_code = la.country_code AND fa.year = la.year
JOIN regions r ON fa.country_code = r.country_code
GROUP BY r.region;

select * from combined_forest_data;
--- references \Result\part2\combined_forest_data.csv

---- create view
CREATE VIEW combined_forest_view AS
SELECT
    r.region,
    SUM(CASE WHEN fa.year = 1990 THEN fa.forest_area_sqkm END) AS forest_area_1990,
    SUM(CASE WHEN la.year = 1990 THEN la.total_area_sq_mi END) * 2.59 AS land_area_1990_sqkm,
    SUM(CASE WHEN fa.year = 2016 THEN fa.forest_area_sqkm END) AS forest_area_2016,
    SUM(CASE WHEN la.year = 2016 THEN la.total_area_sq_mi END) * 2.59 AS land_area_2016_sqkm,
    ROUND(CAST(100.00 * (SUM(CASE WHEN fa.year = 1990 THEN fa.forest_area_sqkm END) / (SUM(CASE WHEN la.year = 1990 THEN la.total_area_sq_mi END) * 2.59)) AS NUMERIC), 2) AS percent_forest_1990,
    ROUND(CAST(100.00 * (SUM(CASE WHEN fa.year = 2016 THEN fa.forest_area_sqkm END) / (SUM(CASE WHEN la.year = 2016 THEN la.total_area_sq_mi END) * 2.59)) AS NUMERIC), 2) AS percent_forest_2016
FROM forest_area fa
JOIN land_area la ON fa.country_code = la.country_code AND fa.year = la.year
JOIN regions r ON fa.country_code = r.country_code
GROUP BY r.region;


select * from combined_forest_view;
----

-- a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?
-- 1. Percent forest of the entire world in 2016
    SELECT region,percent_forest_2016
    FROM combined_forest_view
    where region = 'World'
    -- region : World 
    -- percent_forest_2016: 31.38
    -- references Result\part2\part2_a_1.csv
 -- 2. Region with highest percent forest in 2016   
    SELECT region, percent_forest_2016
    FROM combined_forest_view
    WHERE region != 'World'
    ORDER BY percent_forest_2016 DESC
    LIMIT 1;
    -- region : Latin America & Caribbean	
    -- percent_forest_2016: 46.16
    -- references Result\part2\part2_a_2.csv
-- 3. Region with lowest percent forest in 2016
    SELECT region, percent_forest_2016
    FROM combined_forest_view
    WHERE region != 'World'
    ORDER BY percent_forest_2016 ASC
    LIMIT 1;
     -- region : Middle East & North Africa	
    -- percent_forest_2016: 2.07
    -- references Result\part2\part2_a_3.csv

-- b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?
-- 1.Percent forest of the entire world in 1990
    SELECT region,percent_forest_1990
    FROM combined_forest_view
    where region = 'World'
    -- region : World 
    -- percent_forest_1990: 32.42
    -- references Result\part2\part2_b_1.csv
-- 2.Region with highest percent forest in 1990
    SELECT region, percent_forest_1990
    FROM combined_forest_view
    WHERE region != 'World'
    ORDER BY percent_forest_1990 DESC
    LIMIT 1;
    -- region : Latin America & Caribbean	 
    -- percent_forest_1990: 51.03
    -- references Result\part2\part2_b_2.csv
-- 3. Region with lowest percent forest in 1990
    SELECT region, percent_forest_1990
    FROM combined_forest_view
    WHERE region != 'World'
    ORDER BY percent_forest_1990 ASC
    LIMIT 1;
    -- region : Middle East & North Africa	
    -- percent_forest_1990: 1.78
    -- references Result\part2\part2_b_3.csv
-- c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?
    SELECT region, percent_forest_1990,percent_forest_2016
    FROM combined_forest_view
    WHERE region != 'World'
-- references Result\part2\part2_c.csv

/*
| Region                        | 1990 Forest Percentage | 2016 Forest Percentage |
|-------------------------------|------------------------|------------------------|
| East Asia & Pacific           | 25.78%                 | 26.36%                 |
| Middle East & North Africa    | 1.78%                  | 2.07%                  |
| Europe & Central Asia         | 37.28%                 | 38.04%                 |
| Latin America & Caribbean     | 51.03%                 | 46.16%                 |
| North America                 | 35.65%                 | 36.04%                 |
| Sub-Saharan Africa            | 30.67%                 | 28.79%                 |
| South Asia                    | 16.51%                 | 17.51%                 |
*/