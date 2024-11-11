CREATE DATABASE PROJECT;
USE PROJECT;
#KPI 1----Total Revenue


SELECT	SUM(revenue_realized) AS TOTAL_REVENUE
FROM fact_booking;

#KPI 2---- Occupancy 

RENAME TABLE project.`fact aggregate_bookings` TO fact_aggregate_bookings;
SELECT * FROM fact_aggregate_bookings;

SELECT CONCAT(ROUND( SUM(successful_bookings)/SUM(capacity)*100,2),"%")AS OCCUPANCY_PERCENTAGE 
FROM fact_aggregate_bookings;


#KPI 3---Cancellation Rate
SELECT 
    CONCAT(
    ROUND(
    (SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(booking_id)) * 100,2),'%')
    AS cancellation_rate
	FROM fact_booking;
    

#KPI 4---- TOTAL BOOKINGS
SELECT COUNT(booking_id) AS TOTAL_BOOKINGS FROM fact_booking;


#KPI 5---- Utilize capacity 
SELECT CONCAT(ROUND(SUM(successful_bookings) / SUM(capacity) ,2), '%') AS Utilize_capacity
FROM fact_aggregate_bookings;

#KPI 6---- TREND ANALYSIS

SELECT 
    SUM(booking_date) AS week_number, 
    SUM(revenue_generated) AS weekly_revenue 
FROM fact_booking 
GROUP BY WEEK(booking_date);

SELECT SUM(revenue_generated) AS TREND_ANALYSIS FROM fact_booking;

#KPI 7----Weekday  & Weekend  Revenue and Booking

SELECT 
    CASE WHEN DAYOFWEEK(booking_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type, 
    COUNT(booking_id) AS total_bookings, 
    SUM(revenue_realized) AS total_revenue
FROM fact_booking 
GROUP BY day_type;

#KPI 8 ----Revenue by State & hotel

SELECT 
    city, 
    property_name, 
    SUM(revenue_realized) AS total_revenue 
FROM dim_hotel,fact_booking
GROUP BY city, 
    property_name;
    
#KPI 9----Class Wise Revenue

SELECT 
    room_class, 
    SUM(revenue_realized) AS class_wise_revenue 
FROM dim_room,fact_booking
GROUP BY room_class;

#KPI 10----Checked out cancel No show

SELECT 
    booking_status, 
    COUNT(booking_id) AS total_bookings
FROM fact_booking 
WHERE booking_status IN ( 'cancelled', 'no_show','checked_out') 
GROUP BY booking_status;

#KPI 11----Weekly trend Key trend (Revenue, Total booking, Occupancy) 

SELECT 
    WEEK(booking_date) AS week_number, 
    SUM(revenue_realized) AS weekly_revenue, 
    COUNT(*) AS weekly_bookings,
    -- Assuming occupancy rate calculation with available data
    (SUM(no_guests) / NULLIF(COUNT(*), 0)) * 100 AS occupancy_rate
FROM fact_booking
GROUP BY WEEK(booking_date);


