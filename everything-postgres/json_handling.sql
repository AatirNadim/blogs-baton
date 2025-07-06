ALTER TABLE products ADD COLUMN attributes JSONB;

-- Now let's add a product with rich, nested attributes
INSERT INTO products (name, price, attributes) VALUES
('Noise-Cancelling Headphones', 249.99,
 '{
    "brand": "AudioPhile",
    "color": "Midnight Blue",
    "wireless": true,
    "specs": {
        "driver_size_mm": 40,
        "battery_life_hrs": 30
    },
    "features": ["Active Noise Cancellation", "Ambient Mode"]
 }');

-- Find all products that are 'Midnight Blue'
-- The `->>` operator extracts a field as text.
SELECT name, price FROM products
WHERE attributes ->> 'color' = 'Midnight Blue';

-- Find all products that have Active Noise Cancellation
-- The `@>` operator checks if the left JSON contains the right JSON.
SELECT name FROM products
WHERE attributes -> 'features' @> '["Active Noise Cancellation"]';
