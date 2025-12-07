
-- We'll create a sample table with text data and a tsvector column for full-text search
CREATE TABLE news_articles (
    id SERIAL PRIMARY KEY,
    headline TEXT NOT NULL,
    body TEXT NOT NULL,
    search_vector tsvector
);

-- Insert sample data into the news_articles table
INSERT INTO news_articles (headline, body)
VALUES
    ('Climate Change Summit Concludes', 'World leaders agreed on new measures to combat global warming at the climate summit.'),
    ('New Study on Climate Change', 'Scientists publish groundbreaking research on the effects of climate change on biodiversity.'),
    ('Tech Giant Announces Green Initiative', 'Major tech company pledges to be carbon neutral by 2030 in fight against climate change.'),
    ('Introduction to PostgreSQL', 'This is an introductory post about PostgreSQL and its recent changes. It covers basic concepts and features.'),
    ('Advanced PostgresSQL Techniques', 'In this post, we delve into advanced PostgreSQL techniques for efficient querying and data manipulation.'),
    ('PostgreSQL Optimization Strategies', 'This post explores various strategies for optimizing PostgreSQL database performance and efficiency.');

-- Update the search_vector column with tsvector data for full-text search
UPDATE news_articles
SET search_vector = to_tsvector('english', headline || ' ' || body);

-- Example full-text search query to find articles related to 'climate AND change'
SELECT headline, body, query, ts_rank(search_vector, query) AS rank, search_vector
FROM news_articles, to_tsquery('english', 'climate & change') query
WHERE search_vector @@ query
ORDER BY rank DESC;

-- Example full-text search query to find articles related to 'climate or change'
SELECT headline, body, query, ts_rank(search_vector, query) AS rank, search_vector 
FROM news_articles, to_tsquery('english', 'climate | change') query
WHERE search_vector @@ query
ORDER BY rank DESC;