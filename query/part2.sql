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
-- references SQL_1\Result\part2_regional_forest_area.csv




-- a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?
SELECT
    r.region,
    SUM(CASE WHEN fa.year = 1990 THEN fa.forest_area_sqkm END) / (SUM(CASE WHEN la.year = 1990 THEN la.total_area_sq_mi END) * 2.59) * 100 AS percent_forest_area_1990,
    SUM(CASE WHEN fa.year = 2016 THEN fa.forest_area_sqkm END) / (SUM(CASE WHEN la.year = 2016 THEN la.total_area_sq_mi END) * 2.59) * 100 AS percent_forest_area_2016
FROM forest_area fa
JOIN land_area la ON fa.country_code = la.country_code AND fa.year = la.year
JOIN regions r ON fa.country_code = r.country_code
GROUP BY r.region;


-- country_name : Peru 
-- total_area_sq_km: 1279999.9891
-- references QL_1\Result\part1_e.csv