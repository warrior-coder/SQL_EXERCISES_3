-- 14. Find the ships in the Ships table that have at least 10 guns, get the class, name, and country.
SELECT ships.class, ships.name, classes.country
FROM ships
JOIN classes ON ships.class = classes.class
WHERE classes.numGuns >= 10;
