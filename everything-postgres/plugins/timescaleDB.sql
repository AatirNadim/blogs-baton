-- # In your postgresql.conf file:
-- shared_preload_libraries = 'timescaledb'


-- Create the extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- 1. Create the regular SQL table
CREATE TABLE device_metrics (
    -- The time column is essential. TIMESTAMPTZ is recommended.
    time        TIMESTAMPTZ       NOT NULL,
    device_id   TEXT              NOT NULL,
    temperature  DECIMAL(5, 2),
    humidity     DECIMAL(5, 2)
);

-- 2. Convert it into a hypertable, partitioned by the 'time' column. 
-- <Look up hypertable, it is an interesting concept>
SELECT create_hypertable('device_metrics', 'time');

INSERT INTO device_metrics (time, device_id, temperature, humidity) VALUES
    (NOW() - INTERVAL '7 minutes', 'device_A', 24.5, 60.1),
    (NOW() - INTERVAL '6 minutes', 'device_A', 24.6, 60.3),
    (NOW() - INTERVAL '1 minute',  'device_A', 25.1, 61.0),
    (NOW(),                       'device_B', 22.1, 56.0);
