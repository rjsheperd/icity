DROP DATABASE IF EXISTS gtfs;
DROP ROLE IF EXISTS gtfs;
CREATE ROLE gtfs WITH LOGIN CREATEDB PASSWORD 'gtfs';
CREATE DATABASE gtfs WITH OWNER gtfs;
\c gtfs

-- Table: agency

CREATE TABLE agency (
    agency_id               VARCHAR(255)    NOT NULL,
    agency_name             VARCHAR(255)    NOT NULL,
    agency_url              VARCHAR(255)    NOT NULL,
    agency_timezone         VARCHAR(255)    NOT NULL,
    agency_lang             VARCHAR(255),
    agency_phone            VARCHAR(255),
    agency_fare_url         VARCHAR(255),
    agency_email            VARCHAR(255),
    agency_license          VARCHAR(255),
    CONSTRAINT agency_pkey PRIMARY KEY (agency_id)
);

-- Table: stops

CREATE TABLE stops (
    stop_id                 VARCHAR(255)    NOT NULL,
    stop_code               VARCHAR(255),
    stop_name               VARCHAR(255)    NOT NULL,
    stop_desc               VARCHAR(255),
    stop_lat                NUMERIC(18, 15) NOT NULL,
    stop_lon                NUMERIC(18, 15) NOT NULL,
    zone_id                 VARCHAR(255),
    stop_url                VARCHAR(255),
    location_type           INTEGER,
    parent_station          VARCHAR(255),
    stop_timezone           VARCHAR(255),
    wheelchair_boarding     INTEGER,
    CONSTRAINT stops_pkey PRIMARY KEY (stop_id)
);

-- Table: routes

CREATE TABLE routes (
    route_id                VARCHAR(255)    NOT NULL,
    agency_id               VARCHAR(255),
    route_short_name        VARCHAR(255),
    route_long_name         VARCHAR(255)    NOT NULL,
    route_desc              VARCHAR(255),
    route_type              INTEGER         NOT NULL,
    route_url               VARCHAR(255),
    route_color             VARCHAR(255),
    route_text_color        VARCHAR(255),
    CONSTRAINT routes_pkey PRIMARY KEY (route_id)
);

-- Table: trips

CREATE TABLE trips (
    route_id                VARCHAR(255)    NOT NULL,
    service_id              VARCHAR(255)    NOT NULL,
    trip_id                 VARCHAR(255)    NOT NULL,
    trip_headsign           VARCHAR(255),
    trip_short_name         VARCHAR(255),
    direction_id            INTEGER,
    block_id                VARCHAR(255),
    shape_id                VARCHAR(255),
    wheelchair_accessible   INTEGER,
    bikes_allowed           INTEGER,
    CONSTRAINT trips_pkey PRIMARY KEY (trip_id)
);

-- Table: stop_times

CREATE TABLE stop_times (
    trip_id                 VARCHAR(255)    NOT NULL,
    arrival_time            VARCHAR(255)    NOT NULL,
    departure_time          VARCHAR(255)    NOT NULL,
    stop_id                 VARCHAR(255)    NOT NULL,
    stop_sequence           INTEGER         NOT NULL,
    stop_headsign           VARCHAR(255),
    pickup_type             INTEGER,
    drop_off_type           INTEGER,
    shape_dist_traveled     VARCHAR(255),
    timepoint               INTEGER,
    CONSTRAINT stop_times_pkey PRIMARY KEY (trip_id, stop_sequence)
);

-- Table: calendar

CREATE TABLE calendar (
    service_id              VARCHAR(255)    NOT NULL,
    monday                  INTEGER         NOT NULL,
    tuesday                 INTEGER         NOT NULL,
    wednesday               INTEGER         NOT NULL,
    thursday                INTEGER         NOT NULL,
    friday                  INTEGER         NOT NULL,
    saturday                INTEGER         NOT NULL,
    sunday                  INTEGER         NOT NULL,
    start_date              VARCHAR(255)    NOT NULL,
    end_date                VARCHAR(255)    NOT NULL,
    CONSTRAINT calendar_pkey PRIMARY KEY (service_id)
);

-- Table: calendar_dates

CREATE TABLE calendar_dates (
    service_id       VARCHAR(255) NOT NULL,
    date             DATE NOT NULL,
    holiday_name     VARCHAR(255),
    exception_type   INTEGER NOT NULL,
    PRIMARY KEY (service_id, date)
);

-- Table: shapes

CREATE TABLE shapes (
    shape_id VARCHAR(255) NOT NULL,
    shape_pt_lat NUMERIC(18, 15) NOT NULL,
    shape_pt_lon NUMERIC(18, 15) NOT NULL,
    shape_pt_sequence INTEGER NOT NULL,
    shape_dist_traveled VARCHAR(255),
    CONSTRAINT shapes_pkey PRIMARY KEY (shape_id, shape_pt_sequence)
);

-- Table: frequencies

CREATE TABLE frequencies (
    trip_id VARCHAR(255) NOT NULL,
    start_time VARCHAR(255) NOT NULL,
    end_time VARCHAR(255) NOT NULL,
    headway_secs INTEGER NOT NULL,
    exact_times INTEGER,
    CONSTRAINT frequencies_pkey PRIMARY KEY (trip_id, start_time)
);

-- Table: transfers

CREATE TABLE transfers (
    from_stop_id VARCHAR(255) NOT NULL,
    to_stop_id VARCHAR(255) NOT NULL,
    transfer_type INTEGER NOT NULL,
    min_transfer_time INTEGER,
    from_route_id VARCHAR(255),
    to_route_id VARCHAR(255),
    from_trip_id VARCHAR(255),
    to_trip_id VARCHAR(255),
    CONSTRAINT transfers_pkey PRIMARY KEY (from_stop_id, to_stop_id, transfer_type)
);

-- Table: attributions

CREATE TABLE attributions (
attribution_id VARCHAR(255) NOT NULL,
agency_id VARCHAR(255) NOT NULL,
attribution_name VARCHAR(255) NOT NULL,
CONSTRAINT attributions_pkey PRIMARY KEY (attribution_id)
);

-- Table: translations

CREATE TABLE translations (
    table_name VARCHAR(255) NOT NULL,
    field_name VARCHAR(255) NOT NULL,
    language VARCHAR(255) NOT NULL,
    translation VARCHAR(255) NOT NULL,
    record_id VARCHAR(255) NOT NULL,
    CONSTRAINT translations_pkey PRIMARY KEY (table_name, field_name, language, record_id)
);

-- Table: pathways

CREATE TABLE pathways (
    pathway_id VARCHAR(255) NOT NULL,
    from_stop_id VARCHAR(255) NOT NULL,
    to_stop_id VARCHAR(255) NOT NULL,
    pathway_mode INTEGER NOT NULL,
    is_bidirectional INTEGER NOT NULL,
    length NUMERIC(18, 15),
    traversal_time INTEGER,
    stair_count INTEGER,
    max_slope NUMERIC(18, 15),
    min_width NUMERIC(18, 15),
    signposted_as VARCHAR(255),
    reversed_signposted_as VARCHAR(255),
    CONSTRAINT pathways_pkey PRIMARY KEY (pathway_id)
);

-- Table: directions
CREATE TABLE directions (
    route_id       VARCHAR(255) NOT NULL,
    direction_id   INTEGER NOT NULL,
    direction      VARCHAR(255) NOT NULL,
    PRIMARY KEY (route_id, direction_id)
);

-- Table: levels

CREATE TABLE levels (
    level_id VARCHAR(255) NOT NULL,
    level_index NUMERIC(18, 15) NOT NULL,
    level_name VARCHAR(255),
    CONSTRAINT levels_pkey PRIMARY KEY (level_id)
);

-- Table: fare_attributes

CREATE TABLE fare_attributes (
    agency_id          VARCHAR(255) NOT NULL,
    fare_id            VARCHAR(255) NOT NULL,
    price              NUMERIC(10, 2) NOT NULL,
    currency_type      VARCHAR(255) NOT NULL,
    payment_method     INTEGER NOT NULL,
    transfers          INTEGER,
    transfer_duration  INTEGER,
    PRIMARY KEY (agency_id, fare_id)
);


-- Table: fare_rules

CREATE TABLE fare_rules (
    fare_id VARCHAR(255),
    route_id VARCHAR(255),
    origin_id VARCHAR(255),
    destination_id VARCHAR(255),
    contains_id VARCHAR(255),
    CONSTRAINT fare_rules_pkey PRIMARY KEY (fare_id, route_id, origin_id, destination_id, contains_id)
);

-- Table: fare_rider_categories

CREATE TABLE fare_rider_categories (
    fare_id             VARCHAR(255) NOT NULL,
    rider_category_id   VARCHAR(255) NOT NULL,
    price               NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (fare_id, rider_category_id)
);


-- Table: farezone_attributes

CREATE TABLE farezone_attributes (
    zone_id     VARCHAR(255) NOT NULL,
    zone_name   VARCHAR(255) NOT NULL,
    PRIMARY KEY (zone_id)
);

-- Table: feed_info

CREATE TABLE feed_info (
    feed_publisher_name VARCHAR(255) NOT NULL,
    feed_publisher_url VARCHAR(255) NOT NULL,
    feed_lang VARCHAR(255),
    feed_start_date VARCHAR(255),
    feed_end_date VARCHAR(255),
    feed_version VARCHAR(255),
    CONSTRAINT feed_info_pkey PRIMARY KEY (feed_publisher_name, feed_publisher_url)
);

-- Import GTFS TXT/CSV file into SQL table

CREATE OR REPLACE FUNCTION file_exists(file_path TEXT)
RETURNS BOOLEAN
AS $$
DECLARE
    _size INTEGER;
    _exists BOOLEAN;
BEGIN
    _exists := false;

    RAISE NOTICE 'Attempting to open %...', file_path;
    SELECT size INTO _size FROM pg_stat_file(file_path, true);
    IF _size IS NOT NULL and _size > 0 THEN
        _exists := true;
    END IF;
    RETURN _exists;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION import_gtfs_table(import_dir TEXT, table_name TEXT)
RETURNS VOID
AS $$
DECLARE
    txt_path TEXT := import_dir || table_name || '.txt';
    csv_path TEXT := import_dir || table_name || '.csv';
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = table_name) THEN
        RAISE EXCEPTION 'Table % does not exist', table_name;
    END IF;
    IF file_exists(txt_path) THEN
        RAISE NOTICE 'Importing data from %...', txt_path;
        EXECUTE format('COPY %I FROM %L WITH CSV HEADER DELIMITER AS '',''', table_name, txt_path);
    ELSIF file_exists(csv_path) THEN
        RAISE NOTICE 'Importing data from %...', csv_path;
        EXECUTE format('COPY %I FROM %L WITH CSV HEADER DELIMITER AS '',''', table_name, csv_path);
    ELSE
        RAISE EXCEPTION 'File %.txt or %.csv does not exist', table_name, table_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION pg_stat_file(text) TO gtfs;
GRANT EXECUTE ON FUNCTION file_exists(text) TO gtfs;
GRANT EXECUTE ON FUNCTION import_gtfs_table(text, text) TO gtfs;
