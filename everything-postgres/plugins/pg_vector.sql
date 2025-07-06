CREATE EXTENSION vector;

CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    content TEXT,
    -- The vector type, with 3 dimensions.
    embedding vector(3)
);

INSERT INTO documents (content, embedding) VALUES
    ('An orange is a fruit', '[0.9, 0.1, 0.1]'),
    ('An apple is a fruit', '[0.8, 0.15, 0.2]'),
    ('A car is a vehicle', '[0.1, 0.2, 0.9]');

-- The query vector representing "What is a common fruit?"
SELECT
    id,
    content,
    -- Calculate the cosine distance between the stored embedding and our query vector
    embedding <=> '[0.85, 0.1, 0.15]' AS distance
FROM
    documents
ORDER BY
    -- Order by the distance to find the closest matches first
    distance
LIMIT 5;
