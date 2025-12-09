-- ============================================================
-- PostgreSQL Semi-Structured Data Demo
-- ============================================================

CREATE EXTENSION IF NOT EXISTS hstore;

DROP TABLE IF EXISTS documents;

-- ============================================================
-- 1) Create a table storing JSON, JSONB, and HSTORE together
-- ============================================================

CREATE TABLE documents (
    id          SERIAL PRIMARY KEY,
    title       TEXT,
    json_raw    JSON,             -- Stored as text, no indexing
    json_doc    JSONB,            -- Binary, indexable, ideal for document structures
    hstore_attributes  HSTORE,    -- Flat key/value metadata
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 2) Insert sample semi-structured data
-- We insert the SAME logical data into json_raw, json_doc, and hstore_attributes.
-- ============================================================

INSERT INTO documents (title, json_raw, json_doc, hstore_attributes)
VALUES
(
    'User Login',
    '{"event":"login","user":{"id":101,"name":"Alice"},"device":"mobile"}',
    '{"event":"login","user":{"id":101,"name":"Alice"},"device":"mobile"}',
    '"device" => "mobile", "event" => "login"'
),
(
    'Order Placed',
    '{"event":"purchase","user":{"id":101,"name":"Alice"},"order":{"items":2,"total":49.90}}',
    '{"event":"purchase","user":{"id":101,"name":"Alice"},"order":{"items":2,"total":49.90}}',
    '"event" => "purchase", "items" => "2", "total" => "49.90"'
),
(
    'User Logout',
    '{"event":"logout","user":{"id":101},"metadata":{"ip":"10.1.2.3"}}',
    '{"event":"logout","user":{"id":101},"metadata":{"ip":"10.1.2.3"}}',
    '"event" => "logout", "ip" => "10.1.2.3"'
);

-- ============================================================
-- 3) JSON & JSONB extraction examples
-- ============================================================

-- Extract nested fields
SELECT
    id,
    json_doc -> 'user' ->> 'name'      AS username_jsonb,
    json_raw -> 'user' ->> 'name'      AS username_json,
    hstore_attributes -> 'event'              AS event_hstore
FROM documents;

-- Deep path extraction with #>>
SELECT
    id,
    json_doc #>> '{metadata,ip}' AS metadata_ip_jsonb
FROM documents;

-- ============================================================
-- 4) Querying semi-structured documents
-- ============================================================

-- JSONB: Filter by nested fields
SELECT *
FROM documents
WHERE json_doc -> 'user' ->> 'id' = '101';

-- HSTORE: Filter by key/value
SELECT *
FROM documents
WHERE hstore_attributes -> 'event' = 'logout';

-- ============================================================
-- 5) Demonstrate containment queries (@>)
-- This is like MongoDB's `find({ "event": "login" })`
-- ============================================================

SELECT *
FROM documents
WHERE json_doc @> '{"event": "login"}';

-- ============================================================
-- 6) Indexing
-- JSON cannot be indexed, but JSONB and HSTORE can
-- ============================================================

CREATE INDEX idx_documents_jsonb ON documents USING GIN (json_doc);
CREATE INDEX idx_documents_hstore ON documents USING GIN (hstore_attributes);

-- ============================================================
-- 7) Updating structured parts of JSONB and HSTORE
-- ============================================================

-- Update a nested JSONB property (partial document update)
UPDATE documents
SET json_doc = jsonb_set(json_doc, '{device}', '"tablet"', true)
WHERE title = 'User Login';

-- Update part of HSTORE
UPDATE documents
SET hstore_attributes = hstore_attributes || '"device" => "tablet"'
WHERE title = 'User Login';

SELECT id, json_doc, hstore_attributes FROM documents WHERE title = 'User Login';
