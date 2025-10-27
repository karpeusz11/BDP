CREATE EXTENSION postgis;

--1)
SELECT b19.polygon_id
FROM buildings_2019 b19
LEFT JOIN buildings_2018 b18 ON b18.polygon_id = b19.polygon_id
WHERE b18.polygon_id IS NULL 
OR 
NOT ST_Equals(b18.geom, b19.geom)

--2)
WITH b_change AS (
SELECT b19.polygon_id, b19.geom
FROM buildings_2019 b19
LEFT JOIN buildings_2018 b18 ON b18.polygon_id = b19.polygon_id
WHERE b18.polygon_id IS NULL 
OR 
NOT ST_Equals(b18.geom, b19.geom)),

new_poi AS (
SELECT p19.poi_id, p19.type, p19.geom
FROM poi_2019 p19
LEFT JOIN poi_2018 p18 ON p18.poi_id = p19.poi_id
WHERE p18.poi_id IS NULL
)

SELECT np.type AS type, COUNT(np.poi_id) AS new_poi_count
FROM new_poi np
WHERE EXISTS (
SELECT 1
FROM b_change bc
WHERE ST_DWithin(bc.geom, np.geom, 500))
GROUP BY np.type
ORDER BY new_poi_count DESC;

--3
CREATE TABLE streets_reprojected AS
SELECT 
	gid,
	link_id,
	st_name,
	ref_in_id,
	nref_in_id,
	func_class,
	speed_cat,
	fr_speed_l,
	to_speed_l,
	dir_travel,
	ST_Transform(ST_SetSRID(geom, 4326), 3068) AS geom
FROM streets_2019;

--4
CREATE TABLE input_points(
    id serial primary key,
    point_name varchar(50),
    geom geometry(Point)  -- Bez SRID
);

INSERT INTO input_points (point_name, geom) VALUES
    ('Point 1', ST_GeomFromText('POINT(8.36093 49.03174)', 4326)),
    ('Point 2', ST_GeomFromText('POINT(8.39876 49.00644)', 4326));

--5
UPDATE input_points 
SET geom = ST_Transform(geom, 3068);

--6
WITH point_line AS (
    SELECT ST_MakeLine(geom ORDER BY id) AS geom
    FROM input_points
),

new_street_node AS (
SELECT 
	gid, 
	ST_Transform(ST_SetSRID(geom, 4326), 3068) AS geom, 
	"intersect"
FROM street_node_2019
WHERE geom IS NOT NULL
)

SELECT
    nsn.gid AS id_node,
    ST_AsText(nsn.geom) AS node_geom,
    ST_Distance(nsn.geom, pl.geom) AS distance
FROM new_street_node nsn, point_line pl
WHERE ST_DWithin(nsn.geom, pl.geom, 200) 
AND
(nsn.intersect like 'Y')
ORDER BY distance;

--7
WITH parks AS (
    SELECT geom
    FROM land_use_a_2019 
    WHERE type LIKE 'Park%'
),

sporting_goods_stores AS (
    SELECT geom
    FROM poi_2019 
    WHERE type = 'Sporting Goods Store' 
)
SELECT COUNT(*) AS stores_count
FROM sporting_goods_stores ss
WHERE EXISTS (
SELECT 1
FROM parks p
WHERE ST_DWithin(ss.geom, p.geom, 300)
);

--8
CREATE TABLE T2019_KAR_BRIDGES(
	id serial primary key,
	geometry geometry
)

INSERT INTO T2019_KAR_BRIDGES (geometry)
SELECT ST_Intersection(r.geom, wl.geom)
FROM water_lines_2019 wl
JOIN railways_2019 r ON ST_Intersects(r.geom, wl.geom)
WHERE NOT ST_IsEmpty(ST_Intersection(r.geom, wl.geom));
WHERE NOT ST_IsEmpty(ST_Intersection(r.geom, wl.geom));