-- ============================
-- PostgreSQL Geospatial Demo
-- ============================

-- Clean up previous tables if exist
DROP TABLE IF EXISTS locations CASCADE;

-- ----------------------------
-- Locations table
-- ----------------------------
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    coord POINT NOT NULL -- (longitude, latitude)
);

-- ----------------------------
-- Insert sample locations
-- ----------------------------
INSERT INTO locations (name, coord) VALUES
('Brussels', POINT(4.3517, 50.8503)),
('Antwerp', POINT(4.4025, 51.2194)),
('Ghent', POINT(3.7214, 51.0543)),
('Bruges', POINT(3.2257, 51.2093)),
('Leuven', POINT(4.7071, 50.8798));

-- ----------------------------
-- Basic queries
-- ----------------------------

-- 1. List all locations
SELECT id, name, coord[0] AS longitude, coord[1] AS latitude
FROM locations;

-- 2. Compute approximate Euclidean distance between all pairs of locations
SELECT 
    l1.name AS start_location,
    l2.name AS end_location,
	l2.coord <-> l1.coord AS euclidean_distance
FROM locations l1
JOIN locations l2 ON l1.id < l2.id
order by euclidean_distance asc;

-- 3. Find nearest location to a given point (example: Leuven)
SELECT name, coord
FROM locations
ORDER BY coord <-> POINT(4.7000, 50.8800)
LIMIT 1;

-- 4. Bounding box search: find locations in a rectangle
SELECT name, coord
FROM locations
WHERE coord[0] BETWEEN 3.83456 AND 5.71215
AND coord[1] BETWEEN 50.46777 AND 51.30884;