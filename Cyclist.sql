create database cyclistic_data;
use cyclistic_data;

CREATE TABLE cyc (
    ride_id VARCHAR(25),
    rideable_type varchar(50),
    start_station_name VARCHAR(100),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(100),
    end_station_id VARCHAR(50),
    start_lat DECIMAL(9,6),
    start_lng DECIMAL(9,6),
    end_lat DECIMAL(9,6),
    end_lng DECIMAL(9,6),
    member_casual VARCHAR(10),
    start_date DATE,
    end_date DATE,
    start_time TIME,
    end_time TIME
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cyclist.csv'
INTO TABLE cyc
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
ride_id,
rideable_type,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
@start_lat,
@start_lng,
@end_lat,
@end_lng,
member_casual,
@start_date,
@end_date,
start_time,
end_time
)
SET
start_lat = NULLIF(@start_lat, ''),
start_lng = NULLIF(@start_lng, ''),
end_lat   = NULLIF(@end_lat, ''),
end_lng   = NULLIF(@end_lng, ''),
start_date = STR_TO_DATE(@start_date, '%d-%m-%Y'),
end_date   = STR_TO_DATE(@end_date, '%d-%m-%Y');


show warnings;

select * from cyc limit 10;

-- / -- 🚴‍♂️ 1️⃣ Business Understanding (Core Case Study Questions)  -- /
## 1. How do annual members and casual riders differ in usage behavior?
select member_casual, count(*) as total_rides, avg(timestampdiff(minute, concat(start_date, ' ', start_time), concat(end_date, ' ', end_time))) as avg_duration from cyc group by member_casual;

## 2. What behavioral patterns indicate likelihood of conversion from casual to member?
select member_casual, dayname(start_date) as weekday, count(*) as rides from cyc group by member_casual, weekday order by weekday;

## 3. On which days are casual riders most active compared to members?
select member_casual, month(start_date) as months, count(*) as rides from cyc group by member_casual, months;

## 4. Do casual riders prefer weekends while members prefer weekdays?
select member_casual, case when dayofweek(start_date) in (1,7) then 'Weekend' else 'Weekday' end as day_type, count(*) as rides from cyc group by member_casual, day_type;

## 5. Which time-of-day segments show the biggest gap between member and casual usage?
select member_casual, hour(start_time) as hours, count(*) as rides from cyc group by member_casual, hours;



-- /-- 📊 2️⃣ Time-Based Deep Analysis  --/
## 6. What are peak ride hours for members vs casual riders?
select hour(start_time) as hours, count(*) as rides from cyc group by hours order by rides desc limit 5;

## 7. What is the average ride duration by hour of the day?
select hour(start_time) as hours, avg(timestampdiff(minute, concat(start_date, ' ', start_time), concat(end_date, ' ', end_time))) as avg_duration from cyc group by hour(start_time);

## 8. How does ride behavior vary across months (seasonality effect)?
select monthname(start_date) as months, count(*) as rides from cyc group by months order by months;

## 9. Which weekday generates the longest average rides?
select dayname(start_date) as days, avg(timestampdiff(minute, concat(start_date, ' ', start_time), concat(end_date, ' ', end_time))) as avg_duration from cyc group by dayname(start_date);

## 10. Are late-night rides more common among casual riders?
select member_casual, count(*) as rides from cyc where hour(start_time) between 0 and 4 group by member_casual;


-- / -- 🕒 3️⃣ Ride Duration Intelligence  -- /
## 11. What is the median ride duration for both segments?
WITH ride_durations AS (
    SELECT member_casual,
           TIMESTAMPDIFF(MINUTE,
               CONCAT(start_date,' ',start_time),
               CONCAT(end_date,' ',end_time)
           ) AS duration
    FROM cyc
),
ordered_data AS (
    SELECT member_casual,
           duration,
           ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY duration) AS row_num,
           COUNT(*) OVER (PARTITION BY member_casual) AS total_rows
    FROM ride_durations
)
SELECT member_casual,
       AVG(duration) AS median_duration
FROM ordered_data
WHERE row_num IN (
      FLOOR((total_rows + 1)/2),
      FLOOR((total_rows + 2)/2)
)
GROUP BY member_casual;


## 12. What percentage of rides exceed 60 minutes by user type?
select member_casual, count(*) * 100 / (select count(*) from cyc where member_casual = c.member_casual) as pct_over_60 from cyc c
where timestampdiff(minute, concat(start_date, ' ', start_time), concat(end_date, ' ', end_time)) > 60 group by member_casual;

## 13. How many rides are shorter than 15 minutes by user type?
select member_casual, count(*) * 100 / (select count(*) from cyc where member_casual = c.member_casual) as pct_over_60 from cyc c
where timestampdiff(minute, concat(start_date, ' ', start_time), concat(end_date, ' ', end_time)) < 15 group by member_casual;

## 14. What are the top 10 start stations for casual riders?
select start_station_name, count(*) as rides from cyc where member_casual='casual' group by start_station_name order by rides desc limit 10;

## 15. What are the top 10 start stations for members?
select start_station_name, count(*) as rides from cyc where member_casual='member' group by start_station_name order by rides desc limit 10;

## 16. What are the top 10 most common station pairs?
select start_station_name, end_station_name, count(*) as rides from cyc where member_casual='member' group by start_station_name, end_station_name order by rides desc limit 10;

## 17. What is the distribution of rides by bike type?
select rideable_type, count(*) * 100 / (select count(*) from cyc) as percen from cyc group by rideable_type;

## 18. How does bike preference differ between members and casual riders?
select member_casual, rideable_type, count(*) * 100 / (select count(*) from cyc) as percen from cyc group by member_casual, rideable_type;

## 19. What are the peak ride hours for each user type?
select member_casual, hour(start_time) as hours, count(*) as rides from cyc group by member_casual, hours order by rides desc;

## 20. What is the average ride distance (km) for each user type? 
select member_casual, avg(6371 * 2 * asin(sqrt(power(sin((radians(end_lat - start_lat))/2),2) + 
cos(radians(start_lat)) * cos(radians(end_lat)) * power(sin((radians(end_lng - start_lng))/2),2)))) as avg_dist_km from cyc group by member_casual;

## 21. What percentage of rides start and end at the same station?
select member_casual, count(*) as rides from cyc where start_station_name = end_station_name group by member_casual;

## 22. What is the monthly trend of casual rides?
select monthname(start_date) as months, count(*) as rides from cyc where member_casual='casual' group by months order by monthname(start_date);

## 23. What is total ride time (minutes) by user type?
select member_casual, sum(timestampdiff(minute, concat(start_date, ' ', start_time), concat(end_date, ' ', end_time))) as total from cyc group by member_casual;

## 24. Which stations are underutilized?
select start_station_name, count(*) as rides from cyc group by start_station_name order by rides desc limit 10;

## 25. Which stations show the highest imbalance (more starts than ends)?
select start_station_name, count(*) - (select count(*) from cyc c2 where c2.end_station_name = cyc.start_station_name) as imbalance from cyc group by start_station_name order by imbalance desc limit 10;

## 26. What are the peak hours for casual riders (marketing target)?
select hour(start_time) as hours, count(*) as rides from cyc where member_casual='casual' group by hours order by rides desc limit 10;

## 27. What percentage of total rides are from casual riders?
select sum(case when member_casual='casual' then 1 else 0 end) * 100 / count(*) as casual_pct from cyc;
























