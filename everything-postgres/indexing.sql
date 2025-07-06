-- (Generalized Inverted Index)-- This SQL command creates a GIN index on the 'attributes' column of the 'products' table.
CREATE INDEX idx_products_attributes_gin ON products USING GIN (attributes);
