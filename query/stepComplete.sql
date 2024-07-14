-- create forestation 
/*
Steps to Complete
Create a View called “forestation” by joining all three tables - forest_area, land_area, and regions in the workspace.
The forest_area and land_area tables join on both country_code AND year.
The regions table joins these based on only country_code.
In the ‘forestation’ View, include the following:
All of the columns of the origin tables
A new column that provides the percent of the land area that is designated as forest.
Keep in mind that the column forest_area_sqkm in the forest_area table and the land_area_sqmi in the land_area table are in different units (square kilometers and square miles, respectively), so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km). 
*/
CREATE VIEW forestation AS 
SELECT 
    frst.country_name AS country,
    frst.country_code AS code,
    frst.year AS year,
    frst.forest_area_sqkm,
    la.total_area_sq_mi,
    la.total_area_sq_mi * 2.59 AS total_area_sqkm, -- Convert land area to square kilometers
    re.region,
    re.income_group,
    (frst.forest_area_sqkm / (la.total_area_sq_mi * 2.59)) * 100 AS percent_forest_area -- Calculate percent forest area
FROM 
    forest_area frst
JOIN 
    land_area la ON frst.country_code = la.country_code AND frst.year = la.year
JOIN 
    regions re ON frst.country_code = re.country_code;
    
select * from forestation;

-- references : query\stepComplete.sql
-- data: data\forestation.csv