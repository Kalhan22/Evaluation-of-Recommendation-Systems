CREATE DATABASE DWH;
CREATE DATABASE DM_BIZ;

SET SQL_SAFE_UPDATES = 0;

drop table dwh.dim_movies_raw;
create table dwh.dim_movies_raw(
movie_id INT PRIMARY KEY,
title VARCHAR(100) NOT NULL,
genre VARCHAR(100) NOT NULL
);

 
##Loading Data from the .CSV File
LOAD DATA LOCAL INFILE 
'/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/ml-latest-small/movies.csv' 
INTO TABLE dwh.dim_movies_raw FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' LINES TERMINATED BY '\n';

drop table dwh.dim_genres_raw;
create table dwh.dim_genres_raw(
movie_id INT PRIMARY KEY,
title VARCHAR(100) NOT NULL,
genre VARCHAR(100) NOT NULL
);

 
##Loading Data from the .CSV File
LOAD DATA LOCAL INFILE 
'/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/ml-latest-small/movies.csv' 
INTO TABLE dwh.dim_movies_raw FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' LINES TERMINATED BY '\n';


##Removing the begining row of data
delete from dwh.dim_movies_raw where movie_id = 0;


##Declaring the String function
CREATE FUNCTION SPLIT_STR(
  x VARCHAR(255),
  delim VARCHAR(12),
  pos INT
)
RETURNS VARCHAR(255)
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '');

## Creation of a data set to figure out whether there exists a 
## movie with more than 4 genres
drop table movie_genre_length_check;
create temporary table movie_genre_length_check as (
select 
COALESCE(SPLIT_STR(genre,'|',1)) as genre_1, 
COALESCE(SPLIT_STR(genre,'|',2)) as genre_2,
COALESCE(SPLIT_STR(genre,'|',3)) as genre_3,
COALESCE(SPLIT_STR(genre,'|',4)) as genre_4,
COALESCE(SPLIT_STR(genre,'|',5)) as genre_5,
COALESCE(SPLIT_STR(genre,'|',6)) as genre_6,
COALESCE(SPLIT_STR(genre,'|',7)) as genre_7,
COALESCE(SPLIT_STR(genre,'|',8)) as genre_8,
COALESCE(SPLIT_STR(genre,'|',9)) as genre_9,
COALESCE(SPLIT_STR(genre,'|',10)) as genre_10
from DWH.dim_movies_raw
);


drop table movie_genre_length_check;
create temporary table movie_genre_length_check as (
select 
COALESCE(SPLIT_STR(genre,'|',1)) as genre_1, 
COALESCE(SPLIT_STR(genre,'|',2)) as genre_2,
COALESCE(SPLIT_STR(genre,'|',3)) as genre_3,
COALESCE(SPLIT_STR(genre,'|',4)) as genre_4,
COALESCE(SPLIT_STR(genre,'|',5)) as genre_5,
COALESCE(SPLIT_STR(genre,'|',6)) as genre_6,
COALESCE(SPLIT_STR(genre,'|',7)) as genre_7,
COALESCE(SPLIT_STR(genre,'|',8)) as genre_8,
COALESCE(SPLIT_STR(genre,'|',9)) as genre_9,
COALESCE(SPLIT_STR(genre,'|',10)) as genre_10
from DWH.dim_movies_raw
);

##Temporary movie_data table
drop table movie_data;
create temporary table movie_data as (
select 
movie_id,
title,
COALESCE(SPLIT_STR(genre,'|',1)) as genre_1, 
COALESCE(SPLIT_STR(genre,'|',2)) as genre_2,
COALESCE(SPLIT_STR(genre,'|',3)) as genre_3,
COALESCE(SPLIT_STR(genre,'|',4)) as genre_4,
COALESCE(SPLIT_STR(genre,'|',5)) as genre_5,
COALESCE(SPLIT_STR(genre,'|',6)) as genre_6,
COALESCE(SPLIT_STR(genre,'|',7)) as genre_7,
COALESCE(SPLIT_STR(genre,'|',8)) as genre_8,
COALESCE(SPLIT_STR(genre,'|',9)) as genre_9,
COALESCE(SPLIT_STR(genre,'|',10)) as genre_10
from DWH.dim_movies_raw
);


##Temporary table for finding distinct genre
create temporary table distinct_genre as (
select distinct genre as b from (
select distinct REPLACE(TRIM(genre_1),'\r','') as genre from dwh.dim_movie_raw_2
union 
select distinct REPLACE(TRIM(genre_2),'\r','') as genre from dwh.dim_movie_raw_2
union
select distinct REPLACE(TRIM(genre_3),'\r','') as genre from dwh.dim_movie_raw_2
union 
select distinct REPLACE(TRIM(genre_4),'\r','') as genre from dwh.dim_movie_raw_2
union
select distinct REPLACE(TRIM(genre_5),'\r','') as genre from dwh.dim_movie_raw_2
union 
select distinct REPLACE(TRIM(genre_6),'\r','') as genre from dwh.dim_movie_raw_2
union
select distinct REPLACE(TRIM(genre_7),'\r','') as genre  from dwh.dim_movie_raw_2
union 
select distinct REPLACE(TRIM(genre_8),'\r','') as genre from dwh.dim_movie_raw_2
union 
select distinct REPLACE(TRIM(genre_9),'\r','') as genre from dwh.dim_movie_raw_2
union 
select distinct REPLACE(TRIM(genre_10),'\r','')as genre from dwh.dim_movie_raw_2
) as x 
)
;

drop table dwh.dim_movies_raw_2;
create table dwh.dim_movies_raw_2 as (
select * from movie_data
);



##Intermeditary querry
select movie_id,title,'Action' as genre from dwh.dim_movies_raw_2  where (genre_1 like '%Action%' or genre_2 = '%Action%' or genre_3 = '%Action%' or genre_4 = '%Action%' or genre_5 = '%Action%' or genre_6 = '%Action%' or genre_7 = '%Action%' or genre_8 = '%Action%' or genre_9 = '%Action%' or genre_10 = '%Action%')
union
select movie_id,title,'Adventure' as genre from dwh.dim_movies_raw_2 where (genre_1 = '%Adventure%' or genre_2 = '%Adventure%' or genre_3 = '%Adventure%' or genre_4 = '%Adventure%' or genre_5 = '%Adventure%' or genre_6 = '%Adventure%' or genre_7 = '%Adventure%' or genre_8 = '%Adventure%' or genre_9 = '%Adventure%' or genre_10 = '%Adventure%')  
union
select movie_id,title,'Animation' as genre from dwh.dim_movies_raw_2 where (genre_1 = '%Animation%' or genre_2 = '%Animation%' or genre_3 = '%Animation%' or genre_4 = '%Animation%' or genre_5 = '%Animation%' or genre_6 = '%Animation%' or genre_7 = '%Animation%' or genre_8 = '%Animation%' or genre_9 = '%Animation%' or genre_10 = '%Animation%')  
union
select movie_id,title,'Childrens' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Childrens%' or genre_2 = '%Childrens%' or genre_3 = '%Childrens%' or genre_4 = '%Childrens%' or genre_5 = '%Childrens%' or genre_6 = '%Childrens%'or genre_7 = '%Childrens%' or genre_8 = '%Childrens%' or genre_9 = '%Childrens%' or genre_10 = '%Childrens%')  
union
select movie_id,title,'Comedy' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Comedy%' or genre_2 = '%Comedy%' or genre_3 = '%Comedy%' or genre_4 = '%Comedy%' or genre_5 = '%Comedy%' or genre_6 = '%Comedy%' or genre_7 = '%Comedy%' or genre_8 = '%Comedy%' or genre_9 = '%Comedy%' or genre_10 = '%Comedy%')  
union
select movie_id,title,'Crime' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Crime%' or genre_2 = '%Crime%' or genre_3 = '%Crime%' or genre_4 = '%Crime%' or genre_5 = '%Crime%' or genre_6 = '%Crime%' or genre_7 = '%Crime%' or genre_8 = '%Crime%' or genre_9 = '%Crime%' or genre_10 = '%Crime%')  
union
select movie_id,title,'Documentary' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Documentary%' or genre_2 = '%Documentary%' or genre_3 = '%Documentary%' or genre_4 = '%Documentary%' or genre_5 = '%Documentary%' or genre_6 = '%Documentary%' or genre_7 = '%Documentary%' or genre_8 = '%Documentary%' or genre_9 = '%Documentary%' or genre_10 = '%Documentary%')  
union
select movie_id,title,'Drama' as genre from dwh.dim_movies_raw_2 where (genre_1 = '%Drama%' or genre_2 = '%Drama%' or genre_3 = '%Drama%' or genre_4 = '%Drama%' or genre_5 = '%Drama%' or genre_6 = '%Drama%' or genre_7 = '%Drama%' or genre_8 = '%Drama%' or genre_9 = '%Drama%' or genre_10 = '%Drama%')  
union
select movie_id,title,'Fantasy' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Fantasy%' or genre_2 = '%Fantasy%' or genre_3 = '%Fantasy%' or genre_4 = '%Fantasy%' or genre_5 = '%Fantasy%' or genre_6 = '%Fantasy%' or genre_7 = '%Fantasy%' or genre_8 = '%Fantasy%' or genre_9 = '%Fantasy%' or genre_10 = '%Fantasy%')  
union
select movie_id,title,'Film-Noir' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Film-Noir%' or genre_2 = '%Film-Noir%' or genre_3 = '%Film-Noir%' or genre_4 = '%Film-Noir%' or genre_5 = '%Film-Noir%' or genre_6 = '%Film-Noir%' or genre_7 = '%Film-Noir%' or genre_8 = '%Film-Noir%' or genre_9 = '%Film-Noir%' or genre_10 = '%Film-Noir%')  
union
select movie_id,title,'Horror' as genre from dwh.dim_movies_raw_2 where (genre_1 = '%Horror%' or genre_2 = '%Horror%' or genre_3 = '%Horror%' or genre_4 = '%Horror%' or genre_5 = '%Horror%' or genre_6 = '%Horror%' or genre_7 = '%Horror%' or genre_8 = '%Horror%' or genre_9 = '%Horror%' or genre_10 = '%Horror%')  
union
select movie_id,title,'Musical' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Musical%' or genre_2 = '%Musical%' or genre_3 = '%Musical%' or genre_4 = '%Musical%' or genre_5 = '%Musical%' or genre_6 = '%Musical%' or genre_7 = '%Musical%' or genre_8 = '%Musical%' or genre_9 = '%Musical%' or genre_10 = '%Musical%')  
union
select movie_id,title,'Mystery' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Mystery%' or genre_2 = '%Mystery%' or genre_3 = '%Mystery%' or genre_4 = '%Mystery%' or genre_5 = '%Mystery%' or genre_6 = '%Mystery%' or genre_7 = '%Mystery%' or genre_8 = '%Mystery%' or genre_9 = '%Mystery%' or genre_10 = '%Mystery%')  
union
select movie_id,title,'Romance' as genre from dwh.dim_movies_raw_2 where (genre_1 = '%Romance%' or genre_2 = '%Romance%' or genre_3 = '%Romance%' or genre_4 = '%Romance%' or genre_5 = '%Romance%' or genre_6 = '%Romance%' or genre_7 = '%Romance%' or genre_8 = '%Romance%' or genre_9 = '%Romance%' or genre_10 = '%Romance%')  
union
select movie_id,title,'Sci-Fi' as genre from dwh.dim_movies_raw_2 where (genre_1 = '%Sci-Fi%' or genre_2 = '%Sci-Fi%' or genre_3 = '%Sci-Fi%' or genre_4 = '%Sci-Fi%' or genre_5 = '%Sci-Fi%' or genre_6 = '%Sci-Fi%' or genre_7 = '%Sci-Fi%' or genre_8 = '%Sci-Fi%' or genre_9 = '%Sci-Fi%' or genre_10 = '%Sci-Fi%')  
union
select movie_id,title,'Thriller' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Thriller%' or genre_2 = '%Thriller%' or genre_3 = '%Thriller%' or genre_4 = '%Thriller%' or genre_5 = '%Thriller%' or genre_6 = '%Thriller%' or genre_7 = '%Thriller%' or genre_8 = '%Thriller%' or genre_9 = '%Thriller%' or genre_10 = '%Thriller%')  
union
select movie_id,title,'War' as genre from dwh.dim_movies_raw_2 where (genre_1 = '%War%' or genre_2 = '%War%' or genre_3 = '%War%' or genre_4 = '%War%' or genre_5 = '%War%' or genre_6 = '%War%' or genre_7 = '%War%' or genre_8 = '%War%' or genre_9 = '%War%' or genre_10 = '%War%')  
union
select movie_id,title,'Western' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%Western%' or genre_2 = '%Western%' or genre_3 = '%Western%' or genre_4 = '%Western%' or genre_5 = '%Western%' or genre_6 = '%Western%' or genre_7 = '%Western%' or genre_8 = '%Western%' or genre_9 = '%Western%' or genre_10 = '%Western%')  
union
select movie_id,title,'(no genres listed)' as genre from dwh.dim_movies_raw_2  where (genre_1 = '%(no genres listed)%' or genre_2 = '%(no genres listed)%' or genre_3 = '%(no genres listed)%' or genre_4 = '%(no genres listed)%' or genre_5 = '%(no genres listed)%' or genre_6 = '%(no genres listed)%' or genre_7 = '%(no genres listed)%' or genre_8 = '%(no genres listed)%' or genre_9 = '%(no genres listed)%' or genre_10 = '%(no genres listed)'%)
;  



##Creating the final dataset
drop table dwh.dim_movies;
create table dwh.dim_movies
select movie_id,title,'Action' as genre from dwh.dim_movies_raw_2  where (genre_1 like '%Action%' or genre_2  like  '%Action%' or genre_3  like  '%Action%' or genre_4  like  '%Action%' or genre_5  like  '%Action%' or genre_6  like  '%Action%' or genre_7  like  '%Action%' or genre_8  like  '%Action%' or genre_9  like  '%Action%' or genre_10  like  '%Action%')
union
select movie_id,title,'Adventure' as genre from dwh.dim_movies_raw_2 where (genre_1  like  '%Adventure%' or genre_2  like  '%Adventure%' or genre_3  like  '%Adventure%' or genre_4  like  '%Adventure%' or genre_5  like  '%Adventure%' or genre_6  like  '%Adventure%' or genre_7  like  '%Adventure%' or genre_8  like  '%Adventure%' or genre_9  like  '%Adventure%' or genre_10  like  '%Adventure%')
union
select movie_id,title,'Animation' as genre from dwh.dim_movies_raw_2 where (genre_1  like  '%Animation%' or genre_2  like  '%Animation%' or genre_3  like  '%Animation%' or genre_4  like  '%Animation%' or genre_5  like  '%Animation%' or genre_6  like  '%Animation%' or genre_7  like  '%Animation%' or genre_8  like  '%Animation%' or genre_9  like  '%Animation%' or genre_10  like  '%Animation%')  
union
select movie_id,title,'Childrens' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Childrens%' or genre_2  like  '%Childrens%' or genre_3  like  '%Childrens%' or genre_4  like  '%Childrens%' or genre_5  like  '%Childrens%' or genre_6  like  '%Childrens%'or genre_7  like  '%Childrens%' or genre_8  like  '%Childrens%' or genre_9  like  '%Childrens%' or genre_10  like  '%Childrens%')  
union
select movie_id,title,'Comedy' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Comedy%' or genre_2  like  '%Comedy%' or genre_3  like  '%Comedy%' or genre_4  like  '%Comedy%' or genre_5  like  '%Comedy%' or genre_6  like  '%Comedy%' or genre_7  like  '%Comedy%' or genre_8  like  '%Comedy%' or genre_9  like  '%Comedy%' or genre_10  like  '%Comedy%')  
union
select movie_id,title,'Crime' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Crime%' or genre_2  like  '%Crime%' or genre_3  like  '%Crime%' or genre_4  like  '%Crime%' or genre_5  like  '%Crime%' or genre_6  like  '%Crime%' or genre_7  like  '%Crime%' or genre_8  like  '%Crime%' or genre_9  like  '%Crime%' or genre_10  like  '%Crime%')  
union
select movie_id,title,'Documentary' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Documentary%' or genre_2  like  '%Documentary%' or genre_3  like  '%Documentary%' or genre_4  like  '%Documentary%' or genre_5  like  '%Documentary%' or genre_6  like  '%Documentary%' or genre_7  like  '%Documentary%' or genre_8  like  '%Documentary%' or genre_9  like  '%Documentary%' or genre_10  like  '%Documentary%')  
union
select movie_id,title,'Drama' as genre from dwh.dim_movies_raw_2 where (genre_1  like  '%Drama%' or genre_2  like  '%Drama%' or genre_3  like  '%Drama%' or genre_4  like  '%Drama%' or genre_5  like  '%Drama%' or genre_6  like  '%Drama%' or genre_7  like  '%Drama%' or genre_8  like  '%Drama%' or genre_9  like  '%Drama%' or genre_10  like  '%Drama%')  
union
select movie_id,title,'Fantasy' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Fantasy%' or genre_2  like  '%Fantasy%' or genre_3  like  '%Fantasy%' or genre_4  like  '%Fantasy%' or genre_5  like  '%Fantasy%' or genre_6  like  '%Fantasy%' or genre_7  like  '%Fantasy%' or genre_8  like  '%Fantasy%' or genre_9  like  '%Fantasy%' or genre_10  like  '%Fantasy%')  
union
select movie_id,title,'Film-Noir' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Film-Noir%' or genre_2  like  '%Film-Noir%' or genre_3  like  '%Film-Noir%' or genre_4  like  '%Film-Noir%' or genre_5  like  '%Film-Noir%' or genre_6  like  '%Film-Noir%' or genre_7  like  '%Film-Noir%' or genre_8  like  '%Film-Noir%' or genre_9  like  '%Film-Noir%' or genre_10  like  '%Film-Noir%')  
union
select movie_id,title,'Horror' as genre from dwh.dim_movies_raw_2 where (genre_1  like  '%Horror%' or genre_2  like  '%Horror%' or genre_3  like  '%Horror%' or genre_4  like  '%Horror%' or genre_5  like  '%Horror%' or genre_6  like  '%Horror%' or genre_7  like  '%Horror%' or genre_8  like  '%Horror%' or genre_9  like  '%Horror%' or genre_10  like  '%Horror%')  
union
select movie_id,title,'Musical' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Musical%' or genre_2  like  '%Musical%' or genre_3  like  '%Musical%' or genre_4  like  '%Musical%' or genre_5  like  '%Musical%' or genre_6  like  '%Musical%' or genre_7  like  '%Musical%' or genre_8  like  '%Musical%' or genre_9  like  '%Musical%' or genre_10  like  '%Musical%')  
union
select movie_id,title,'Mystery' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Mystery%' or genre_2  like  '%Mystery%' or genre_3  like  '%Mystery%' or genre_4  like  '%Mystery%' or genre_5  like  '%Mystery%' or genre_6  like  '%Mystery%' or genre_7  like  '%Mystery%' or genre_8  like  '%Mystery%' or genre_9  like  '%Mystery%' or genre_10  like  '%Mystery%')  
union
select movie_id,title,'Romance' as genre from dwh.dim_movies_raw_2 where (genre_1  like  '%Romance%' or genre_2  like  '%Romance%' or genre_3  like  '%Romance%' or genre_4  like  '%Romance%' or genre_5  like  '%Romance%' or genre_6  like  '%Romance%' or genre_7  like  '%Romance%' or genre_8  like  '%Romance%' or genre_9  like  '%Romance%' or genre_10  like  '%Romance%')  
union
select movie_id,title,'Sci-Fi' as genre from dwh.dim_movies_raw_2 where (genre_1  like  '%Sci-Fi%' or genre_2  like  '%Sci-Fi%' or genre_3  like  '%Sci-Fi%' or genre_4  like  '%Sci-Fi%' or genre_5  like  '%Sci-Fi%' or genre_6  like  '%Sci-Fi%' or genre_7  like  '%Sci-Fi%' or genre_8  like  '%Sci-Fi%' or genre_9  like  '%Sci-Fi%' or genre_10  like  '%Sci-Fi%')  
union
select movie_id,title,'Thriller' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Thriller%' or genre_2  like  '%Thriller%' or genre_3  like  '%Thriller%' or genre_4  like  '%Thriller%' or genre_5  like  '%Thriller%' or genre_6  like  '%Thriller%' or genre_7  like  '%Thriller%' or genre_8  like  '%Thriller%' or genre_9  like  '%Thriller%' or genre_10  like  '%Thriller%')  
union
select movie_id,title,'War' as genre from dwh.dim_movies_raw_2 where (genre_1  like  '%War%' or genre_2  like  '%War%' or genre_3  like  '%War%' or genre_4  like  '%War%' or genre_5  like  '%War%' or genre_6  like  '%War%' or genre_7  like  '%War%' or genre_8  like  '%War%' or genre_9  like  '%War%' or genre_10  like  '%War%')  
union
select movie_id,title,'Western' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%Western%' or genre_2  like  '%Western%' or genre_3  like  '%Western%' or genre_4  like  '%Western%' or genre_5  like  '%Western%' or genre_6  like  '%Western%' or genre_7  like  '%Western%' or genre_8  like  '%Western%' or genre_9  like  '%Western%' or genre_10  like  '%Western%')  
union
select movie_id,title,'(no genres listed)' as genre from dwh.dim_movies_raw_2  where (genre_1  like  '%(no genres listed)%' or genre_2  like  '%(no genres listed)%' or genre_3  like  '%(no genres listed)%' or genre_4  like  '%(no genres listed)%' or genre_5  like  '%(no genres listed)%' or genre_6  like  '%(no genres listed)%' or genre_7  like  '%(no genres listed)%' or genre_8  like  '%(no genres listed)%' or genre_9  like  '%(no genres listed)%' or genre_10  like  '%(no genres listed)%')
; 


select * from DWh.DIM_MOVIES LiMIT 10; 

##Final Data Set
select * from dwh.dim_movies order by movie_id;


drop table dwh.fact_ratings;
create table dwh.fact_ratings(
user_id INT NOT NULL,
movie_id INT NOT NULL,
rating INT NOT NULL,
timestamp BIGINT NOT NULL
);

##Loading Data from the .CSV File
LOAD DATA LOCAL INFILE 
'/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/ml-latest-small/ratings.csv' 
INTO TABLE dwh.fact_ratings FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' LINES TERMINATED BY '\n';

delete from dwh.fact_ratings where user_id = 0;



drop table dwh.fact_tags;
create table dwh.fact_tags(
user_id INT NOT NULL,
movie_id INT NOT NULL,
tag VARCHAR(30),
timestamp BIGINT NOT NULL
);

##Loading Data from the .CSV File
LOAD DATA LOCAL INFILE 
'/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/ml-latest-small/tags.csv' 
INTO TABLE dwh.fact_tags FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' LINES TERMINATED BY '\n';


drop table dwh.dim_tags;
create table dwh.dim_tags(
tag_id INT,
tag VARCHAR(30)
);

##Loading Data from the .CSV File
LOAD DATA LOCAL INFILE 
'/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/ml-20m/genome-tags.csv' 
INTO TABLE dwh.dim_tags FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' LINES TERMINATED BY '\n';



drop table dwh.dim_genome_scores;
create table dwh.dim_genome_scores(
movie_id INT,
tag_id INT,
relevance FLOAT
);

##Loading Data from the .CSV File
LOAD DATA LOCAL INFILE 
'/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/ml-20m/fact_tagsgenome-scores.csv' 
INTO TABLE dwh.dim_genome_scores FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' LINES TERMINATED BY '\n';

delete from fact_tags where user_id = 0;
delete from dwh.dim_genome_scores where movie_id = 0;


select genre,count(distinct a.movie_id),count(distinct user_id) 
from DWh.DIM_MOVIES as a join
(select distinct user_id,movie_id from DWh.FACT_RATINGS
where user_id < 101 
) as b  on a.movie_id = b.movie_id
group by 1
;


create table DWH.FACT_RATINGS_SMALL as (
select * from DWH.FACT_RATINGS LIMIT 15000
);

create table DWH.DIM_USER_MOVIE_CARTESIAN as (
select * from  (select distinct user_id from DWH.FACT_RATINGS_SMALL) as a 
cross join (select distinct movie_id from DWh.DIM_MOVIES) as x
);

##Content Based Recommednation Logic
## MySQl Script for Creation of the Item Profile of all the movies in the system

drop table temporary_item_matrix ;
create table temporary_item_matrix as (
select 
distinct
movie_id,
title,
case when genre like '%Action%' then 1 else 0 end as 'Action',
case when genre like '%Adventure%' then 1 else 0 end as 'Adventure',
case when genre like '%Animation%' then 1 else 0 end as 'Animation',
case when genre like '%Comedy%' then 1 else 0 end as 'Comedy',
case when genre like '%Crime%' then 1 else 0 end as 'Crime',
case when genre like '%Documentary%' then 1 else 0 end as 'Documentary',
case when genre like '%Drama%' then 1 else 0 end as 'Drama',
case when genre like '%Fantasy%' then 1 else 0 end as 'Fantasy',
case when genre like '%Film-Noir%' then 1 else 0 end as 'Film-Noir',
case when genre like '%Horror%' then 1 else 0 end as 'Horror',
case when genre like '%Musical%' then 1 else 0 end as 'Musical',
case when genre like '%Mystery%' then 1 else 0 end as 'Mystery',
case when genre like '%Romance%' then 1 else 0 end as 'Romance',
case when genre like '%Sci-Fi%' then 1 else 0 end as 'Sci-Fi',
case when genre like '%Thriller%' then 1 else 0 end as 'Thriller',
case when genre like '%War%' then 1 else 0 end as 'War',
case when genre like '%Western%' then 1 else 0 end as 'Western',
case when genre like '%(no genres listed)%' then 1 else 0 end as 'No Genre'
from DWh.DIM_MOVIES_RAW
)
;

drop table all_movie_ratings ;
create table all_movie_ratings as(
select movie_id, AVG(rating) as rating from DWH.FACT_RATINGS group by 1
);

drop table DWH.DIM_ITEM_PROFILE;
create table DWH.DIM_ITEM_PROFILE as (
select a.*,b.rating as avg_rating from temporary_item_matrix as a join all_movie_ratings as b
on a.movie_id = b.movie_id
)
;

select * from  DWH.DIM_ITEM_PROFILE;

drop table user_movie_genre_rating_all;
create temporary table user_movie_genre_rating_all as (
select b.user_id,a.movie_id,a.genre,b.rating from 
DWh.DIM_MOVIES as a join DWh.FACT_RATINGS as b on
a.movie_id = b.movie_id
)
;

drop table user_all_average_rating ;
create temporary table user_all_average_rating as (
select user_id,AVG(rating) rating from DWH.FACT_RATINGS group by 1
);

drop table user_genre_movie_norm_rating;
create temporary table user_genre_movie_norm_rating as (
select 
a.user_id,
a.genre,
(a.rating - b.rating) as normalized_rating
from user_movie_genre_rating_all as a join user_all_average_rating as b
on (a.user_id = b.user_id)
)
;

drop table user_genre_movie_freq;
create temporary table user_genre_movie_freq as (
select user_id,genre,count(distinct movie_id)  as num_movies from 
user_movie_genre_rating_all group by 1,2
)
;


create temporary table user_profile_temp as (
select 
a.user_id,
a.genre,
a.sum_normalized/b.num_movies as user_prof_wt
from
(select 
a.user_id,
a.genre,
sum(a.normalized_rating) as sum_normalized
from user_genre_movie_norm_rating as a 
group by 1,2
) as a join  user_genre_movie_freq as b 
on (a.user_id = b.user_id and a.genre = b.genre)
)
;

drop table DWh.DIM_USER_PROFILE;
create table DWh.DIM_USER_PROFILE as (
select user_id, 
sum(case when genre like '%Action%' then user_prof_wt else 0 end) as 'Action',
sum(case when genre like '%Adventure%' then user_prof_wt else 0 end) as 'Adventure',
sum(case when genre like '%Animation%' then user_prof_wt else 0 end) as 'Animation',
sum(case when genre like '%Comedy%' then user_prof_wt else 0 end) as 'Comedy',
sum(case when genre like '%Crime%' then user_prof_wt else 0 end) as 'Crime',
sum(case when genre like '%Documentary%' then user_prof_wt else 0 end) as 'Documentary',
sum(case when genre like '%Drama%' then user_prof_wt else 0 end) as 'Drama',
sum(case when genre like '%Fantasy%' then user_prof_wt else 0 end) as 'Fantasy',
sum(case when genre like '%Film-Noir%' then user_prof_wt else 0 end) as 'Film-Noir',
sum(case when genre like '%Horror%' then user_prof_wt else 0 end) as 'Horror',
sum(case when genre like '%Musical%' then user_prof_wt else 0 end) as 'Musical',
sum(case when genre like '%Mystery%' then user_prof_wt else 0 end) as 'Mystery',
sum(case when genre like '%Romance%' then user_prof_wt else 0 end) as 'Romance',
sum(case when genre like '%Sci-Fi%' then user_prof_wt else 0 end) as 'Sci-Fi',
sum(case when genre like '%Thriller%' then user_prof_wt else 0 end) as 'Thriller',
sum(case when genre like '%War%' then user_prof_wt else 0 end) as 'War',
sum(case when genre like '%Western%' then user_prof_wt else 0 end) as 'Western',
sum(case when genre like '%(no genres listed)%' then user_prof_wt else 0 end) as 'No Genre'
from user_profile_temp
group by 1
)
;

describe DWh.DIM_USER_PROFILE;



##Now the only thing left is to get the do product of user_profile and item profile
##Those items which have the maximum cos theta are the items which should be shown to user
#Predict ratings of all the movies that the suer has not rated

##Final Table Structure:
##Item profile: movie, title, actio adventure.... avg_rating
## User profile: user_id , action 

drop table wt_calculation;
create temporary table wt_calculation as (
select 
a.user_id, 
b.movie_id,
(a.`Action`*b.`Action`) as z  ,
(a.Adventure*b.Adventure) as y ,
(a.Animation*b.Animation) as c,
(a.Comedy*b.Comedy) as d,
(a.Crime*b.Crime) as e,
(a.Documentary*b.Documentary) as f,
(a.Drama*b.Drama) as g,
(a.Fantasy*b.Fantasy) as h,
(a.`Film-Noir`*b.`Film-Noir`) as i,
(a.Horror*b.Horror) as j,
(a.Musical*b.Musical) as k,
(a.Mystery*b.Mystery) as l,
(a.Romance*b.Romance) as m,
(a.`Sci-Fi`*b.`Sci-Fi`) as n,
(a.Thriller*b.Thriller) as o,
(a.War*b.War) as p ,
(a.Western*b.Western) as q,
(a.`No Genre` * b.`No Genre`)  as r,
pow(a.`Action`,2) as a_Action_2,
pow(b.`Action`,2) as b_Action_2,
pow(a.`Adventure`,2) as a_Adventure_2,
pow(b.`Adventure`,2) as b_Adventure_2,
pow(a.`Animation`,2) as a_Animation_2,
pow(b.`Animation`,2) as b_Animation_2,
pow(a.`Comedy`,2) as a_Comedy_2,
pow(b.`Comedy`,2) as b_Comedy_2,
pow(a.`Crime`,2) as a_Crime_2,
pow(b.`Crime`,2) as b_Crime_2,
pow(a.`Documentary`,2) as a_Documentary_2,
pow(b.`Documentary`,2) as b_Documentary_2,
pow(a.`Drama`,2) as a_Drama_2,
pow(b.`Drama`,2) as b_Drama_2,
pow(a.`Fantasy`,2) as a_Fantasy_2,
pow(b.`Fantasy`,2) as b_Fantasy_2,
pow(a.`Film-Noir`,2) as a_Film_Noir_2,
pow(b.`Film-Noir`,2) as b_Film_Noir_2,
pow(a.`Horror`,2) as a_Horror_2,
pow(b.`Horror`,2) as b_Horror_2,
pow(a.`Musical`,2) as a_Musical_2,
pow(b.`Musical`,2) as b_Musical_2,
pow(a.`Mystery`,2) as a_Mystery_2,
pow(b.`Mystery`,2) as b_Mystery_2,
pow(a.`Romance`,2) as a_Romance_2,
pow(b.`Romance`,2) as b_Romance_2,
pow(a.`Sci-Fi`,2) as a_Sci_Fi_2,
pow(b.`Sci-Fi`,2) as b_Sci_Fi_2,
pow(a.`Thriller`,2) as a_Thriller_2,
pow(b.`Thriller`,2) as b_Thriller_2,
pow(a.`War`,2) as a_War_2,
pow(b.`War`,2) as b_War_2,
pow(a.`Western`,2) as a_Western_2,
pow(b.`Western`,2) as b_Western_2,
pow(a.`No Genre`,2) as a_No_Genre_2,
pow(b.`No Genre`,2) as b_No_Genre_2
from 
(select * from DWh.DIM_USER_PROFILE) as a 
cross join 
(select * from DWh.DIM_Item_PROFILE) as b 
);

##Movies to Recommends to each user
create temporary table recommendation_all as (
select
user_id,movie_id,
((z+y+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r)/nullif(((a_Action_2 + a_Adventure_2 + a_Animation_2 + a_Comedy_2 + a_Crime_2 + a_Documentary_2 + a_Fantasy_2 + a_Drama_2 + a_Film_Noir_2 + a_Horror_2 + a_Musical_2 + a_Romance_2 + a_Sci_Fi_2 + a_Thriller_2 + a_War_2 + a_Western_2 + a_No_Genre_2)*sqrt(b_Action_2 + b_Adventure_2 + b_Animation_2 + b_Comedy_2 + b_Crime_2 + b_Documentary_2 + b_Fantasy_2 + b_Drama_2 + b_Film_Noir_2 + b_Horror_2 + b_Musical_2 + b_Romance_2 + b_Sci_Fi_2 + b_Thriller_2 + b_War_2 + b_Western_2 + b_No_Genre_2)),0))as wt
from 
wt_calculation
) 
;

##Final User Rating
##Has a lot of errors and bugs.
drop table zz;
create temporary table zz as (
select user_id,movie_id,numerator,denominator,(numerator/denominator) as wt from 
(
select
user_id,movie_id,
(z+y+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r) as numerator,
nullif(sqrt((a_Action_2 + a_Adventure_2 + a_Animation_2 + a_Comedy_2 + a_Crime_2 + a_Documentary_2 + a_Fantasy_2 + a_Drama_2 + a_Film_Noir_2 + a_Horror_2 + a_Musical_2 + a_Romance_2 + a_Sci_Fi_2 + a_Thriller_2 + a_War_2 + a_Western_2 + a_No_Genre_2)*(b_Action_2 + b_Adventure_2 + b_Animation_2 + b_Comedy_2 + b_Crime_2 + b_Documentary_2 + b_Fantasy_2 + b_Drama_2 + b_Film_Noir_2 + b_Horror_2 + b_Musical_2 + b_Romance_2 + b_Sci_Fi_2 + b_Thriller_2 + b_War_2 + b_Western_2 + b_No_Genre_2)),0) as denominator
from wt_calculation
) as x
) ;


create table DWH.CB_USER_MOVIE_WT as (
select * from zz
);


select * from DWH.CB_USER_MOVIE_WT LIMIT 10;

select user_id,count(*) from DWH.CB_USER_MOVIE_WT group by 1;


select user_id,max(wt),min(wt) from DWH.CB_USER_MOVIE_WT group by 1;


create table DWH.movie_rating_pred as (
select user_id,movie_id,(wt +1)*2.5 as rating_prediction
from zz
);



Alter table DWH.movie_rating_pred ADD INDEX(user_id,movie_id);

Alter table DWH.FACT_RATINGS ADD INDEX(user_id,movie_id);

select * from DWH.movie_rating_pred LIMIT 10;

select user_id,count(movie_id),count(distinct movie_id) from DWH.movie_rating_pred group by 1;



## RMSE with Cosine Similarity and Range Converting one range to another method
select sqrt(sum(power((rating-rating_prediction),2))/100004) from DWH.validation_table;

drop table DWH.movie_rating_pred_short ;
create table DWH.movie_rating_pred_short  as (
select * from DWH.movie_rating_pred where rating_prediction > 3 
);

select count(*) from DWH.movie_rating_pred_short;

drop table DWH.validation_table;
create table DWH.validation_table as (
select a.user_id,a.movie_id,rating,rating_prediction from
DWH.FACT_RATINGS as a left join movie_rating_pred_short as b on (a.user_id = b.user_id and 
a.movie_id = b.movie_id)
)
;


##Get Percentile Rating Score
drop table DWH.CB_Percentile;
create table DWH.CB_Percentile as (
SELECT t.user_id,t.movie_id,t.wt, 
       @rownum := mod(@rownum + 1,9067) AS rank
  FROM zz t, 
       (SELECT @rownum := 0) r
	 order by user_id,wt,movie_id
    )
       ;

select count(*) from  DWH.CB_Percentile;

select * from DWH.movie_rating_pred where user_id = 2 and movie_id = 661;


select * from DWh.DIM_USER_PROFILE LIMIT 10;


select * from DWh.DIM_ITEM_PROFILE LIMIT 10;

drop table DWH.MOVIE_GENRE_RATING;
create table DWH.MOVIE_GENRE_RATING as(
select a.genre,b.user_id,a.movie_id,b.rating from DWh.DIM_MOVIES as a join DWH.FACT_RATINGS as b on (a.movie_id = b.movie_id)
);



select count(*) from DWH.FACT_RATINGS;



select count(*) from (
select movie_id,count(genre) from DWh.DIM_MOVIES group by 1
)a;

select * from DWH.DIM_ITEM_PROFILE LIMIT 2;

select * from DWH.DIM_USER_PROFILE LIMIT 2;