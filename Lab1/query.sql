-- 1. Count summary delay for each city
-- Execution time:
-- row: 1s 271ms
-- columnar: 570 ms
SELECT C.city, A.departure_delay, B.arrival_delay, (A.departure_delay + B.arrival_delay) as total_delay
FROM (SELECT flights.origin as city, sum(flights.dep_delay) as departure_delay FROM flights GROUP BY city) AS A
         FULL OUTER JOIN
     (SELECT flights.dest as city, sum(flights.arr_delay) as arrival_delay FROM flights GROUP BY city) AS B
     ON A.city = B.city
         INNER JOIN airports AS C ON A.city = C.iata_code OR B.city = C.iata_code;


-- 2. Count the number of flights arriving and departing for each city
-- Execution time:
-- row: 523ms
-- columnar: 445 ms
SELECT C.city, origin_count, dest_count, (origin_count + dest_count) as overall_count
FROM (SELECT COUNT(*) as origin_count, origin as city FROM flights GROUP BY flights.origin) AS A
         FULL OUTER JOIN
     (SELECT COUNT(*) as dest_count, dest as city FROM flights GROUP BY flights.dest) AS B
     ON A.city = B.city
         INNER JOIN airports AS C ON A.city = C.iata_code OR B.city = C.iata_code;


-- 3. Find city with the minimal delay. Delay is counted as a sum of "arr_delay" and "dep_delay"
-- Execution time:
-- row: 450 ms
-- columnar: 360 ms
SELECT B.city, MIN(delay) as min_delay
FROM (SELECT MIN(flights.arr_delay + flights.dep_delay) as delay, dest as city
      FROM flights
      GROUP BY dest) as A
         INNER JOIN airports as B
                    ON A.city = B.iata_code
GROUP BY B.city
ORDER BY min_delay
LIMIT 1;

-- Execution time:
-- row: 464 ms
-- columnar: 384 ms
SELECT B.city, MAX(delay) as min_delay
FROM (SELECT MAX(flights.arr_delay + flights.dep_delay) as delay, dest as city
      FROM flights
      GROUP BY dest) as A
         INNER JOIN airports as B
                    ON A.city = B.iata_code
GROUP BY B.city
ORDER BY min_delay
LIMIT 1;


-- 4. Find all flights with a delay greater than the average delay time
-- Execution time:
-- row: 464 ms
-- columnar: 320 ms
SELECT *
FROM flights
WHERE flights.arr_delay + flights.dep_delay > (SELECT AVG(flights.dep_delay + flights.arr_delay) as avg_delay
                                               FROM flights);


SELECT pg_size_pretty(pg_database_size('flights_column_db')) AS columnstore_size,
       pg_size_pretty(pg_database_size('flights_db'))        as rowstore_size;


