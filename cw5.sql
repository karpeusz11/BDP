CREATE EXTENSION postgis;


CREATE TABLE obiekty (
    id INT PRIMARY KEY,
    geom geometry,
    name varchar(50)
);

--w tym przypadku użyłem na początku st_union, aczkolwiek w zadaniu 5
--potrzebna jest kolekcja, a nie ST_MultiLine_String
INSERT INTO obiekty VALUES
    (1, 
    ST_Union(ARRAY[		--st_union przyjmuje tylko 2 obiekty, dlatego lepiej użyć tablicy, st_collect też działa ale st_union nie tworzy geometrycollection
       	'LINESTRING(0 1, 1 1)',
        'CIRCULARSTRING(1 1, 2 0, 3 1)',	--ST_LineToCurve nie działa -> T_LineToCurve('LINESTRING(1 1, 2 0, 3 1)')
        'CIRCULARSTRING(3 1, 4 2, 5 1)',
        'LINESTRING(5 1, 6 1)'
	]), 'obiekt1'),
    (2,
	ST_Union(ARRAY[
		'LINESTRING(10 2, 10 6, 14 6)', 
		'CIRCULARSTRING(14 6, 16 4, 14 2)',
		'CIRCULARSTRING(14 2, 12 0, 10 2)',
		'CIRCULARSTRING(11 2, 13 2, 11 2)'
	]), 'obiekt2'),
	(3,
	'LINESTRING(7 15, 10 17, 12 13)',
	'obiekt3'	
	),
	(4,
	'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)',
	'obiekt4'	
	),
	(5,
	ST_LineFromMultiPoint('MULTIPOINT(30 30 59, 38 32 235)'),
	'obiekt5'
	),
    (6, 
     ST_GeomFromText('GEOMETRYCOLLECTION(
         LINESTRING(1 1, 3 2),
         POINT(4 2)
     )'), 'obiekt6');

--sprawdzenie działania ST_LineToCursive
SELECT 
  ST_AsText(ST_GeomFromText('LINESTRING(0 0, 2 2, 4 0)')) as original,
  ST_AsText(ST_LineToCurve(ST_GeomFromText('LINESTRING(0 0, 2 2, 4 0)'))) as curved;

--2
SELECT ST_Area
		(ST_Buffer
			(ST_ShortestLine
			((SELECT geom FROM obiekty WHERE id = 3), 
			(SELECT geom FROM obiekty WHERE id = 4)),
			5))
AS pole_powierzchni;

--3
SELECT ST_GeometryType(geom) --sprawdzamy geometrię
FROM obiekty
WHERE name = 'obiekt4';

SELECT ST_AsText(ST_MakePolygon(ST_AddPoint(geom, ST_StartPoint(geom))))
FROM obiekty
WHERE name = 'obiekt4';
--musimy dodać punkt zamykający poligon (pierwszy punkt), wtedy używając ST_Polygon go zamkniemy 

UPDATE obiekty 
SET geom = ST_MakePolygon(ST_AddPoint(geom, ST_StartPoint(geom)))
WHERE name = 'obiekt4';


--4
INSERT INTO obiekty VALUES
	(7, 
	ST_Union(
			(SELECT geom FROM obiekty WHERE id = 3), 
			(SELECT geom FROM obiekty WHERE id = 4)), 
	'obiekt7')

--5
SELECT ST_Area(ST_Buffer(geom,5))
FROM obiekty
WHERE ST_HasArc(geom) = true;

drop table obiekty