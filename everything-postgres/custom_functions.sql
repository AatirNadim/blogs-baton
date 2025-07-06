-- First, enable the Python language extension (once per database)
CREATE EXTENSION IF NOT EXISTS plpython3u;

CREATE OR REPLACE FUNCTION calculate_discount(price NUMERIC, discount_pct INT)
RETURNS NUMERIC AS $$
    if price is None or discount_pct is None:
        return None
    if not (0<= discount_pct <= 100):
        raise ValueError("Discount percentage must be within 0 and 100")
    discounted_price = price * (1 - (discount_pct / 100.0))
      return round(discounted_price, 2)
$$ LANGUAGE plpython3u;

-- Use it directly in a query!
SELECT name, price, calculate_discount(price, 15) AS discounted_price
FROM products;
