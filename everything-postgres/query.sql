SELECT
    u.email,
    p.name,
    o.quantity
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN products p ON o.product_id = p.product_id
WHERE p.name = 'Quantum Keyboard';