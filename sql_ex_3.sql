-- 14. Find the ships in the Ships table that have at least 10 guns, get the class, name, and country.
SELECT ships.class, ships.name, classes.country
FROM ships
JOIN classes ON ships.class = classes.class
WHERE classes.numGuns >= 10;

-- 31. For ship classes with a gun caliber of 16 in. or more, display the class and the country.
SELECT classes.class, classes.country
FROM classes
WHERE classes.bore >= 16;

-- 32. One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw).
-- Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.
-- CAST(<expr> AS <type>)
SELECT t1.country, CAST(AVG((POWER(t1.bore, 3) / 2)) AS DECIMAL(6, 2))
FROM (
        SELECT classes.country, classes.class, classes.bore, ships.name
        FROM classes
        JOIN ships ON classes.class = ships.class
        UNION ALL
        SELECT DISTINCT classes.country, classes.class, classes.bore, outcomes.ship
        FROM classes
        JOIN outcomes ON classes.class = outcomes.ship
        WHERE outcomes.ship = classes.class AND outcomes.ship NOT IN (
            SELECT ships.name
            FROM ships
        )
    ) AS t1
GROUP by t1.country;

-- 33. Get the ships sunk in the North Atlantic battle.
-- Result set: ship.
SELECT ship
FROM outcomes
WHERE battle = 'North Atlantic' AND result = 'sunk';

-- 34. In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons.
-- Get the ships violating this treaty (only consider ships for which the year of launch is known).
-- List the names of the ships.
SELECT ships.name
FROM ships, classes
WHERE ships.class = classes.class AND classes.displacement > 35000 AND classes.type = 'bb' AND ships.launched >= 1922;

-- 34.
SELECT ships.name
FROM ships
JOIN classes ON ships.class = classes.class
WHERE classes.displacement > 35000 AND classes.type = 'bb' AND ships.launched >= 1922;

-- 36. List the names of lead ships in the database (including the Outcomes table).
SELECT ships.name AS lead_ship
FROM ships
WHERE ships.name IN (
    SELECT classes.class 
    FROM classes
)
UNION
SELECT outcomes.ship AS lead_ship
FROM outcomes
WHERE outcomes.ship IN (
    SELECT classes.class 
    FROM classes
);

SELECT ships.name AS lead_ship
FROM ships
JOIN classes ON  ships.class = classes.class
UNION
SELECT outcomes.ship AS lead_ship
FROM outcomes
WHERE outcomes.ship IN (
    SELECT classes.class 
    FROM classes
);


-- 36.
SELECT classes.class
FROM classes
JOIN outcomes ON classes.class = outcomes.ship
UNION
SELECT classes.class
FROM classes
JOIN ships ON classes.class = ships.class
WHERE ships.class = ships.name;

-- 37. Find classes for which only one ship exists in the database (including the Outcomes table).
;
