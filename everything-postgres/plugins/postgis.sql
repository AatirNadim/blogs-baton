-- This command loads all the PostGIS types, functions, and operators
-- into the current database.
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE famous_landmarks (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    -- The 'geography' type is provided by PostGIS.
    -- 'Point' specifies we are storing single points.
    -- '4326' is the Spatial Reference System Identifier (SRID) for WGS 84,
    -- the standard used by GPS systems worldwide.
    location geography(Point, 4326)
);
