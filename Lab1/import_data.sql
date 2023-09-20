COPY airlines
    FROM '/data/resources/airlines.csv'
    DELIMITER ','
    CSV HEADER;

COPY airports
    FROM '/data/resources/airports.csv'
    DELIMITER ','
    CSV HEADER;

COPY flights
    FROM '/data/resources/flights.csv'
    DELIMITER ','
    CSV HEADER;