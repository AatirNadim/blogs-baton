-- Define a new composite type for addresses
CREATE TYPE full_address AS (
    street_address TEXT,
    city TEXT,
    postal_code VARCHAR(10)
);

-- Use the new type in a table
ALTER TABLE users ADD COLUMN shipping_address full_address;

-- Insert data using the ROW constructor
UPDATE users
SET shipping_address = ROW('123 Elephant Way', 'Postgresville', '54321')
WHERE user_id = 1;

-- Query the fields using dot notation, just like an object
SELECT
    email,
    (shipping_address).city,
    (shipping_address).street_address
FROM users
WHERE user_id = 1;
