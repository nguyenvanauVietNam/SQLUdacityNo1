/*
Part 1 - Global Situation
Instructions:
Answering these questions will help you add information into the template.
Use these questions as guides to write SQL queries.
Use the output from the query to answer these questions.
*/

-- a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.

SELECT SUM(forest_area_sqkm) AS total_forest_area_1990
FROM forest_area
WHERE country_name = 'World' AND year = 1990;

-- total_forest_area_1990 : 41282694.9
-- references QL_1\Result\part1_a.csv

-- b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”
SELECT SUM(forest_area_sqkm) AS total_forest_area_2016
FROM forest_area
WHERE country_name = 'World' AND year = 2016;
-- total_forest_area_2016 : 39958245
-- references QL_1\Result\part1_b.csv

-- c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?
SELECT
    (SELECT SUM(forest_area_sqkm) FROM forest_area WHERE country_name = 'World' AND year = 2016) -
    (SELECT SUM(forest_area_sqkm) FROM forest_area WHERE country_name = 'World' AND year = 1990) AS change_in_forest_area;
-- change_in_forest_area : -1324449  (Forest area decreased :1324449)
-- references QL_1\Result\part1_c.csv


-- d. What was the percent change in forest area of the world between 1990 and 2016?
SELECT
    ((SELECT SUM(forest_area_sqkm) FROM forest_area WHERE country_name = 'World' AND year = 2016) -
    (SELECT SUM(forest_area_sqkm) FROM forest_area WHERE country_name = 'World' AND year = 1990)) /
    (SELECT SUM(forest_area_sqkm) FROM forest_area WHERE country_name = 'World' AND year = 1990) * 100 AS percent_change_in_forest_area;


-- percent_change_in_forest_area : -3.20824258980244  ( Forest area decreased by 3.2%)
-- references QL_1\Result\part1_d.csv


-- e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?
SELECT country_name, total_area_sq_km
FROM (
    SELECT country_name, total_area_sq_mi * 2.59 AS total_area_sq_km
    FROM land_area
    WHERE year = 2016
) AS subquery
ORDER BY ABS((SELECT SUM(forest_area_sqkm) FROM forest_area WHERE country_name = 'World' AND year = 1990) -
             (SELECT SUM(forest_area_sqkm) FROM forest_area WHERE country_name = 'World' AND year = 2016) -
             total_area_sq_km)
LIMIT 1;

-- country_name : Peru 
-- total_area_sq_km: 1279999.9891
-- references QL_1\Result\part1_e.csv

------------------------------------------------------------------------

