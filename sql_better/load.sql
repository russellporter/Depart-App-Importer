/*  

Script contributed by Michael Perkins, updated to support shapes, and more fields in April 2011 by Russell Porter

example usage:
cat load.sql | mysql -u root
(assumes user is in same directory as GTFS source files)

*/

CREATE DATABASE IF NOT EXISTS transit_russellporter_ca;

USE transit_russellporter_ca

DROP TABLE IF EXISTS agency;

CREATE TABLE `agency` (
    agency_id VARCHAR(25) PRIMARY KEY,
    agency_name VARCHAR(255),
    agency_url VARCHAR(255),
    agency_timezone VARCHAR(50),
    agency_lang CHAR(2)
);

DROP TABLE IF EXISTS calendar;

CREATE TABLE `calendar` (
    service_id VARCHAR(25),
	monday TINYINT(1),
	tuesday TINYINT(1),
	wednesday TINYINT(1),
	thursday TINYINT(1),
	friday TINYINT(1),
	saturday TINYINT(1),
	sunday TINYINT(1),
	start_date VARCHAR(8),	
	end_date VARCHAR(8),
	start_date_timestamp INT(11),
	end_date_timestamp INT(11),
	KEY `service_id` (service_id),
    KEY `start_date_timestamp` (start_date_timestamp),
	KEY `end_date_timestamp` (end_date_timestamp)
);
DROP TABLE IF EXISTS calendar_dates;

CREATE TABLE `calendar_dates` (
    id INT(11) NOT NULL AUTO_INCREMENT,
    service_id VARCHAR(25),
    `date` VARCHAR(8),
    date_timestamp INT(11),
    exception_type INT(2),
    PRIMARY KEY (id),
    KEY `service_id` (service_id),
    KEY `date_timestamp` (date_timestamp),
    KEY `exception_type` (exception_type)    
);

DROP TABLE IF EXISTS routes;

CREATE TABLE `routes` (
    route_id INT(11) PRIMARY KEY,
	agency_id VARCHAR(25),
	route_short_name VARCHAR(50),
	route_text_color VARCHAR(10),
	route_color VARCHAR(10),
	route_url VARCHAR(255),
	route_desc TEXT,
	route_long_name VARCHAR(255),
	route_type INT(2),
	KEY `agency_id` (agency_id),
	KEY `route_type` (route_type)
);


DROP TABLE IF EXISTS stop_times;

CREATE TABLE `stop_times` (
	id INT(11) NOT NULL AUTO_INCREMENT,
    trip_id INT(11),
	arrival_time VARCHAR(8),
	arrival_time_seconds INT(11),
	departure_time VARCHAR(8),
	departure_time_seconds INT(11),
	stop_id INT(11),
	stop_sequence INT(11),
	stop_headsign VARCHAR(50),
	pickup_type INT(2),
	drop_off_type INT(2),
	shape_dist_traveled INT(11),
	PRIMARY KEY (id),
	KEY `trip_id` (trip_id),
	KEY `arrival_time_seconds` (arrival_time_seconds),
	KEY `departure_time_seconds` (departure_time_seconds),
	KEY `stop_id` (stop_id),
	KEY `stop_sequence` (stop_sequence),
	KEY `pickup_type` (pickup_type),
	KEY `drop_off_type` (drop_off_type)
);
DROP TABLE IF EXISTS stops;

CREATE TABLE `stops` (
    stop_id INT(11) PRIMARY KEY,
    stop_code VARCHAR(50),
	stop_name VARCHAR(255),
	stop_desc VARCHAR(255),
	stop_lat DOUBLE,
	stop_lon DOUBLE,
	zone_id INT(11),
	stop_url VARCHAR(255),
	location_type INT(2),
	parent_station INT(11),
	KEY `zone_id` (zone_id),
	KEY `stop_lat` (stop_lat),
	KEY `stop_lon` (stop_lon),
	KEY `location_type` (location_type),
	KEY `parent_station` (parent_station)
);

DROP TABLE IF EXISTS trips;

CREATE TABLE `trips` (
    route_id INT(11),
	service_id VARCHAR(25),
	trip_id INT(11) PRIMARY KEY,
	trip_headsign VARCHAR(255),
	trip_short_name VARCHAR(255),
	direction_id TINYINT(1),
	block_id VARCHAR(20),
	shape_id INT(11),
	KEY `route_id` (route_id),
	KEY `service_id` (service_id),
	KEY `direction_id` (direction_id),
	KEY `block_id` (block_id),
	KEY `shape_id` (shape_id)
);

DROP TABLE IF EXISTS shapes;

CREATE TABLE `shapes` (
	id INT(11) NOT NULL AUTO_INCREMENT,
    shape_id INT(11),
	shape_pt_lat DOUBLE,
	shape_pt_lon DOUBLE,
	shape_pt_sequence INT(11),
	shape_dist_traveled INT(11),
	PRIMARY KEY (id),
	KEY `shape_id` (shape_id),
	KEY `shape_pt_lat` (shape_pt_lat),
	KEY `shape_pt_lon` (shape_pt_lon),
	KEY `shape_pt_sequence` (shape_pt_sequence),
	KEY `shape_dist_traveled` (shape_dist_traveled)
);

LOAD DATA LOCAL INFILE 'agency.txt' INTO TABLE agency FIELDS TERMINATED BY ',' IGNORE 1 LINES (agency_url,agency_name,agency_timezone,agency_id,agency_lang);

LOAD DATA LOCAL INFILE 'calendar.txt' INTO TABLE calendar FIELDS TERMINATED BY ',' IGNORE 1 LINES (service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date);

LOAD DATA LOCAL INFILE 'calendar_dates.txt' INTO TABLE calendar_dates FIELDS TERMINATED BY ',' IGNORE 1 LINES (service_id,date,exception_type);

LOAD DATA LOCAL INFILE 'routes.txt' INTO TABLE routes FIELDS TERMINATED BY ',' IGNORE 1 LINES (route_id,agency_id,route_short_name,route_long_name,route_desc,route_type,route_url,route_color,route_text_color);

LOAD DATA LOCAL INFILE 'stop_times.txt' INTO TABLE stop_times FIELDS TERMINATED BY ',' IGNORE 1 LINES (trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,shape_dist_traveled);

LOAD DATA LOCAL INFILE 'stops.txt' INTO TABLE stops FIELDS TERMINATED BY ',' IGNORE 1 LINES (stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station);

LOAD DATA LOCAL INFILE 'trips.txt' INTO TABLE trips FIELDS TERMINATED BY ',' IGNORE 1 LINES ();

LOAD DATA LOCAL INFILE 'shapes.txt' INTO TABLE shapes FIELDS TERMINATED BY ',' IGNORE 1 LINES (shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled);