/*
Part 3 - Country-Level Detail
Instructions:
Answering these questions will help you add information to the template.
Use these questions as guides to write SQL queries.
Use the output from the query to answer these questions
*/

-- a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?
WITH forest_change AS (
    SELECT 
        country,
        region,
        SUM(CASE WHEN year = 1990 THEN forest_area_sqkm END) AS forest_area_1990,
        SUM(CASE WHEN year = 2016 THEN forest_area_sqkm END) AS forest_area_2016
    FROM forestation
    GROUP BY country, region
)
SELECT 
    country,
    region,
    forest_area_1990,
    forest_area_2016,
    (forest_area_1990 - forest_area_2016) AS difference_forest_area
FROM forest_change
ORDER BY difference_forest_area
LIMIT 5;

-- region : China 
--Decrease: 527229.06
-- references Result\part2\part3_a.csv

-- b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?

SELECT 
    f1.country,
    f1.region,
    f1.forest_area_sqkm AS forest_area_1990,
    f2.forest_area_sqkm AS forest_area_2016,
    -((1 - (f2.forest_area_sqkm / NULLIF(f1.forest_area_sqkm, 0))) * 100) AS percent_decrease
FROM 
    forestation f1
JOIN 
    forestation f2 ON f1.code = f2.code
WHERE 
    f1.year = 1990 AND f2.year = 2016
    AND f2.forest_area_sqkm < f1.forest_area_sqkm
    AND f1.country NOT LIKE 'World'
ORDER BY 
    percent_decrease
LIMIT 5;

-- country: Togo
-- region : Sub-Saharan Africa	 
--Decrease: 527229.06
-- references Result\part2\part3_a.csv