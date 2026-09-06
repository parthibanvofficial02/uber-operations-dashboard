-- ============================================================
-- NCR RIDE BOOKINGS ANALYSIS - SQL QUERY SET (MySQL syntax)
-- Table: ride_bookings
-- ============================================================

-- Q1: Overall booking status split
SELECT `Booking Status`, COUNT(*) AS total_bookings,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ride_bookings), 2) AS pct_share
FROM ride_bookings
GROUP BY `Booking Status`
ORDER BY total_bookings DESC;

-- Q2: Total revenue, avg booking value, avg distance by vehicle type (completed rides only)
SELECT `Vehicle Type`,
       COUNT(*) AS completed_rides,
       ROUND(SUM(`Booking Value`),2) AS total_revenue,
       ROUND(AVG(`Booking Value`),2) AS avg_booking_value,
       ROUND(AVG(`Ride Distance`),2) AS avg_distance_km
FROM ride_bookings
WHERE `Booking Status` = 'Completed'
GROUP BY `Vehicle Type`
ORDER BY total_revenue DESC;

-- Q3: Monthly booking trend
SELECT `Month`, COUNT(*) AS total_bookings,
       SUM(CASE WHEN `Booking Status`='Completed' THEN 1 ELSE 0 END) AS completed
FROM ride_bookings
GROUP BY `Month`
ORDER BY `Month`;

-- Q4: Peak hour analysis
SELECT `Hour`, COUNT(*) AS total_bookings
FROM ride_bookings
GROUP BY `Hour`
ORDER BY `Hour`;

-- Q5: Top 10 pickup locations
SELECT `Pickup Location`, COUNT(*) AS bookings
FROM ride_bookings
GROUP BY `Pickup Location`
ORDER BY bookings DESC
LIMIT 10;

-- Q6: Top 10 customer cancellation reasons
SELECT `Reason for cancelling by Customer` AS reason, COUNT(*) AS cnt
FROM ride_bookings
WHERE `Booking Status` = 'Cancelled by Customer'
GROUP BY reason
ORDER BY cnt DESC;

-- Q7: Top driver cancellation reasons
SELECT `Driver Cancellation Reason` AS reason, COUNT(*) AS cnt
FROM ride_bookings
WHERE `Booking Status` = 'Cancelled by Driver'
GROUP BY reason
ORDER BY cnt DESC;

-- Q8: Incomplete ride reasons
SELECT `Incomplete Rides Reason` AS reason, COUNT(*) AS cnt
FROM ride_bookings
WHERE `Booking Status` = 'Incomplete'
GROUP BY reason
ORDER BY cnt DESC;

-- Q9: Payment method distribution (completed rides)
SELECT `Payment Method`, COUNT(*) AS rides, ROUND(SUM(`Booking Value`),2) AS revenue
FROM ride_bookings
WHERE `Booking Status` = 'Completed'
GROUP BY `Payment Method`
ORDER BY revenue DESC;

-- Q10: Avg driver & customer ratings by vehicle type
SELECT `Vehicle Type`,
       ROUND(AVG(`Driver Ratings`),2) AS avg_driver_rating,
       ROUND(AVG(`Customer Rating`),2) AS avg_customer_rating
FROM ride_bookings
WHERE `Booking Status` = 'Completed'
GROUP BY `Vehicle Type`
ORDER BY avg_driver_rating DESC;

-- Q11: Avg VTAT (arrival time) & CTAT (trip time) by vehicle type
SELECT `Vehicle Type`,
       ROUND(AVG(`Avg VTAT`),2) AS avg_vtat_min,
       ROUND(AVG(`Avg CTAT`),2) AS avg_ctat_min
FROM ride_bookings
GROUP BY `Vehicle Type`
ORDER BY avg_vtat_min DESC;

-- Q12: Top 10 customers by number of completed rides & spend
SELECT `Customer ID`, COUNT(*) AS total_rides, ROUND(SUM(`Booking Value`),2) AS total_spend
FROM ride_bookings
WHERE `Booking Status` = 'Completed'
GROUP BY `Customer ID`
ORDER BY total_spend DESC
LIMIT 10;

-- Q13: Weekday-wise booking pattern
SELECT `Weekday`, COUNT(*) AS total_bookings,
       ROUND(SUM(CASE WHEN `Booking Status`='Completed' THEN `Booking Value` ELSE 0 END),2) AS revenue
FROM ride_bookings
GROUP BY `Weekday`
ORDER BY total_bookings DESC;

-- Q14: Overall cancellation rate (customer + driver) and no-driver-found rate
SELECT
  ROUND(SUM(CASE WHEN `Booking Status`='Cancelled by Customer' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS pct_cancelled_by_customer,
  ROUND(SUM(CASE WHEN `Booking Status`='Cancelled by Driver' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS pct_cancelled_by_driver,
  ROUND(SUM(CASE WHEN `Booking Status`='No Driver Found' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS pct_no_driver_found,
  ROUND(SUM(CASE WHEN `Booking Status`='Completed' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS pct_completed
FROM ride_bookings;
