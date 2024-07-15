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

-- references Result\part2\part3_b.csv
--c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?
WITH sub AS (
  SELECT country,
    CASE
      WHEN percent_forest_area < 25 THEN '0-25%'
      WHEN percent_forest_area >= 25 AND percent_forest_area < 50 THEN '25-50%'
      WHEN percent_forest_area >= 50 AND percent_forest_area < 75 THEN '50-75%'
      ELSE '75-100%'
    END AS quartile
  FROM forestation
  WHERE year = 2016
    AND percent_forest_area IS NOT NULL
)
SELECT quartile,
  COUNT(*) AS number_of_countries
FROM sub
GROUP BY quartile
ORDER BY number_of_countries DESC
LIMIT 1;

-- references Result\part2\part3_c.csv

--d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
WITH sub AS (
  SELECT country,
    CASE
      WHEN percent_forest_area < 25 THEN '0-25%'
      WHEN percent_forest_area >= 25 AND percent_forest_area < 50 THEN '25-50%'
      WHEN percent_forest_area >= 50 AND percent_forest_area < 75 THEN '50-75%'
      ELSE '75-100%'
    END AS quartile
  FROM forestation
  WHERE year = 2016
    AND percent_forest_area IS NOT NULL
)
SELECT country,
  quartile
FROM sub
WHERE quartile = '75-100%';

-- references Result\part2\part3_d.csv
--e. How many countries had a percent forestation higher than the United States in 2016?
SELECT COUNT(*) AS count
FROM (
  SELECT DISTINCT country
  FROM forestation
  WHERE percent_forest_area > (
    SELECT percent_forest_area
    FROM forestation
    WHERE country = 'United States'
      AND year = 2016
  )
) AS sub;

-- references Result\part2\part3_e.csv



-- support for GPT
--Top 5 Amount Decrease in Forest Area by Country, 1990 & 2016:
CREATE VIEW forestation_view AS
SELECT
    country,
    code,
    year,
    forest_area_sqkm,
    total_area_sq_mi,
    total_area_sqkm,
    region,
    income_group,
    percent_forest_area
FROM
    forestation;
SELECT * from forestation_view;
-- references data\forestation_view.csv
SELECT
    f1990.country,
    f1990.region,
    ABS(f1990.forest_area_sqkm - f2016.forest_area_sqkm) AS absolute_forest_area_change
FROM
    forestation_view f1990
JOIN
    forestation_view f2016
ON
    f1990.country = f2016.country
WHERE
    f1990.year = 1990
    AND f2016.year = 2016
ORDER BY
    absolute_forest_area_change DESC
LIMIT 5;
--references Result\part3\forest_area_by_country.csv

--Count of Countries Grouped by Forestation Percent Quartiles, 2016:
SELECT
    CASE
        WHEN percent_forest_area >= 75 THEN '75%-100%'
        WHEN percent_forest_area >= 50 THEN '50%-75%'
        WHEN percent_forest_area >= 25 THEN '25%-50%'
        ELSE '0%-25%'
    END AS quartile,
    COUNT(country) AS country_count
FROM
    forestation
WHERE
    year = 2016
GROUP BY
    quartile
ORDER BY
    quartile;

--references Result\part3\Quartile.csv
--Top Quartile Countries, 2016
SELECT
    country,
    percent_forest_area
FROM
    forestation
WHERE
    year = 2016
    AND percent_forest_area >= 75
ORDER BY
    percent_forest_area DESC;

--references Result\part3\Quartile_Countries.csv

    