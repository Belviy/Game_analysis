-- What is the 5 most popular games from 2008 to 2019 yearly? 
ALTER TABLE new_schema.cleaned_data1 RENAME COLUMN `User Rating Count` TO `User_Rating_Count` ;
ALTER TABLE new_schema.cleaned_data1 RENAME COLUMN `Average User Rating` TO `Average_user_Rating` ;
ALTER TABLE new_schema.cleaned_data1 RENAME COLUMN `Release Date` TO `Release_Date` ;
ALTER TABLE new_schema.cleaned_data1 RENAME COLUMN `Price per App (USD)` TO `Price_per_App` ;
ALTER TABLE new_schema.cleaned_data1 RENAME COLUMN `Primary Genre` TO `Primary_Genre` ;
ALTER TABLE new_schema.cleaned_data1 RENAME COLUMN `App ID` TO `App_ID` ;

SELECT *,YEAR(Release_Date) AS year
FROM new_schema.cleaned_data1
-- group by YEAR(Release_Date)
order by User_Rating_Count desc
limit 5;

--  the 5 most popular games from 2008 to 2019 yearly
with t1 as (
select *,row_number() over (partition by year(Release_Date) order by Release_Date) as rn
from new_schema.cleaned_data1
)
select * from t1
where rn<=5
order by
year(Release_Date),rn;



-- creating anew table
 -- create table 5_popular between 2008 qnd 2019
SELECT Name,User_Rating_Count,Release_Date,YEAR(Release_Date) AS year
FROM new_schema.cleaned_data1
#group by YEAR(Release_Date)
order by User_Rating_Count desc
limit 5;
-- What game developer had the highest average game rating?
 -- create table dev_highest_avg
 with t1 as (
SELECT Average_user_Rating,Name,App_ID,User_Rating_Count, Developer,year(Release_Date) as year
FROM new_schema.cleaned_data1
where  Average_user_Rating = (select max(Average_user_Rating) FROM new_schema.cleaned_data1) and User_Rating_Count>20000
Order by User_Rating_Count desc
)
select distinct Developer,year,Average_user_Rating
from t1;
-- 3.	Who are the 3 game developers to have most income from their app store games iduring 2008 to 2019? 
create table 3_developpers
SELECT  Name,App_ID, User_Rating_Count,Price_per_App,Developer,Price_per_App*User_Rating_Count as income,year(Release_Date) as year
FROM new_schema.cleaned_data1
order by income desc
limit 3;
-- 4.	What is the average rating and price trend for the games from 2008 to 2019?
select Average_user_Rating,Avg(Price_per_App),year(Release_Date) as year 
FROM new_schema.cleaned_data1
group by year(Release_Date) ;
-- 5.	Which is the most popular language for the games in App Store from 2008 to 2019?


select  Languages  ,count(*) as counte
FROM new_schema.cleaned_data1
group by Languages
order by counte desc
limit 1;
-- 	What are the 3 games to have most user rating count from 2016 to 2019?
-- create table 3_most_rating_games
select  Name, User_Rating_Count,year(Release_Date) as year
FROM new_schema.cleaned_data1
order by User_Rating_Count desc
limit 3;
-- 7.	What are the most popular game genres every 3 years since 2008?
WITH GenreCounts AS (
    SELECT 
        YEAR(Release_Date) AS Year,
        Genres,
        COUNT(*) AS Genre_Count
    FROM 
        new_schema.cleaned_data1
    WHERE 
        YEAR(Release_Date) IN (2008, 2011, 2014, 2017, 2019)  
    GROUP BY 
        YEAR(Release_Date), Genres
),
MaxGenreCounts AS (
    SELECT 
        Year,
        MAX(Genre_Count) AS Max_Count
    FROM 
        GenreCounts
    GROUP BY 
        Year
)
SELECT 
gc.Year,
    gc.Genres,
    gc.Genre_Count
FROM 
    GenreCounts gc
JOIN 
    MaxGenreCounts mgc ON gc.Year = mgc.Year AND gc.Genre_Count = mgc.Max_Count;

    ;
-- 8.	For the new developers to start App Store, what is the price recommendation for them?
select avg(Price_per_App)
FROM new_schema.cleaned_data1;
-- 9.	For the new developers to start App Store, what is the genre recommendation for them?
select Primary_Genre,Count(*) as count_pri_Genre,year(Release_Date) as year
FROM new_schema.cleaned_data1
group by Primary_Genre,year
limit 5;








