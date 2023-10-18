INSERT INTO regions(region_id, region_name) VALUES (10, 'Testowy region');
SELECT * FROM regions;
DROP TABLE regions CASCADE CONSTRAINTS;
SELECT * FROM regions;
FLASHBACK TABLE regions TO BEFORE DROP;
SELECT * FROM regions;