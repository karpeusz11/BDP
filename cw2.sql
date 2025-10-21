CREATE EXTENSION postgis;

CREATE TABLE buildings (
	id INT PRIMARY KEY,
	geometry geometry,
	name varchar(50)
);

CREATE TABLE roads (
	id INT PRIMARY KEY,
	geometry geometry,
	name varchar(50)
);

CREATE TABLE poi (
	id INT PRIMARY KEY,
	geometry geometry,
	name varchar(50)
);

INSERT INTO buildings VALUES 
	(1, 'POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 'BuildingA'),
	(2, 'POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))', 'BuildingB'),
	(3, 'POLYGON((3 6, 3 8, 5 8, 5 6, 3 6))', 'BuildingC'),
	(4, 'POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))', 'BuildingD'),
	(5, 'POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))', 'Buildingf');

INSERT INTO roads VALUES
	(1, 'LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
	(2, 'LINESTRING(7.5 10.5, 7.5 0)', 'RoadY');

INSERT INTO poi VALUES
	(1, 'POINT(1 3.5)', 'G'),
	(2, 'POINT(5.5 1.5)', 'H'),
	(3, 'POINT(9.5 6)', 'I'),
	(4, 'POINT(6.5 6)', 'J'),
	(5, 'POINT(6 9.5)', 'K');

--a
SELECT SUM(ST_Length(geometry)) FROM roads;

--b
SELECT ST_Area(geometry), ST_Perimeter(geometry), ST_AsText(geometry)
FROM buildings
WHERE name='BuildingA';

--c
SELECT name, ST_Area(geometry)
FROM buildings
ORDER BY name ASC;

--d
SELECT name, ST_Perimeter(geometry)
FROM buildings
ORDER BY name ASC
limit 2;

--e
SELECT b.name, p.name, ST_Distance(b.geometry, p.geometry) AS distance
FROM buildings AS b
CROSS JOIN poi AS p
WHERE b.name like 'BuildingC' and p.name like 'K';

--f
SELECT ST_Area(bc.geometry) - ST_Area(ST_Intersection(ST_Buffer(bb.geometry, 0.5), bc.geometry)) as area_b
FROM buildings AS bc
JOIN buildings AS bb ON bb.name like 'BuildingB'
WHERE bc.name like 'BuildingC';

--g
SELECT b.name 
FROM buildings AS b
JOIN roads AS r ON r.name = 'RoadX'
WHERE ST_Y(ST_Centroid(b.geometry)) > ST_Y(ST_Centroid(r.geometry));

--h
SELECT ST_Area(ST_Union(bc.geometry, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) - ST_Area(ST_Intersection(bc.geometry, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) AS area
FROM buildings AS bc 
WHERE bc.name = 'BuildingC';