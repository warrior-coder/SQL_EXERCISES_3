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
SELECT t1.class
FROM (
    SELECT classes.class, outcomes.ship AS ship_name
    FROM classes
    JOIN outcomes ON classes.class = outcomes.ship
    UNION
    SELECT classes.class, ships.name AS ship_name
    FROM classes
    JOIN ships ON classes.class = ships.class
) AS t1
GROUP BY t1.class
HAVING COUNT(t1.ship_name) = 1;

-- 38. Find countries that ever had classes of both battleships ('bb') and cruisers ('bc').
SELECT country
FROM classes
WHERE type = 'bb'
INTERSECT
SELECT country
FROM classes
WHERE type = 'bc'

-- 39. Find the ships that 'survived for future battles';
-- that is, after being damaged in a battle, they participated in another one, which occurred later.
SELECT DISTINCT o.ship
FROM outcomes AS o
JOIN battles AS b ON o.battle = b.name
WHERE o.result = 'damaged' AND EXISTS (
    SELECT outcomes.ship
    FROM outcomes
    JOIN battles ON outcomes.battle = battles.name
    WHERE outcomes.ship = o.ship AND battles.date > b.date
);

-- 39.
SELECT DISTINCT t1.ship
FROM (
    SELECT *
    FROM outcomes
    JOIN battles ON outcomes.battle = battles.name
    WHERE outcomes.result = 'damaged'
) AS t1
WHERE EXISTS (
    SELECT outcomes.ship
    FROM outcomes
    JOIN battles ON outcomes.battle = battles.name
    WHERE outcomes.ship = t1.ship AND battles.date > t1.date
);

-- 42. Find the names of ships sunk at battles, along with the names of the corresponding battles.
SELECT ship, battle
FROM outcomes
WHERE result = 'sunk';

-- 43. Get the battles that occurred in years when no ships were launched into water.
SELECT name
FROM battles
WHERE YEAR([date]) NOT IN (
    SELECT launched
    FROM ships
    WHERE launched IS NOT NULL
);

-- 44. Find all ship names beginning with the letter R.
SELECT name
FROM ships
WHERE name LIKE 'R%'
UNION
SELECT ship
FROM outcomes
WHERE ship LIKE 'R%';

-- 44.
SELECT t1.ship_name
FROM (
    SELECT ships.name AS ship_name FROM ships
    UNION
    SELECT ship AS ship_name FROM outcomes
) AS t1
WHERE t1.ship_name LIKE 'R%';

-- 45. Find all ship names consisting of three or more words (e.g., King George V).
-- Consider the words in ship names to be separated by single spaces, and the ship names to have no leading or trailing spaces.
SELECT name
FROM ships
WHERE name LIKE '% % %'
UNION
SELECT ship
FROM outcomes
WHERE ship LIKE '% % %';

-- 46. For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns.
SELECT DISTINCT outcomes.ship, classes.displacement, classes.numGuns
FROM classes
LEFT JOIN ships ON classes.class = ships.class
RIGHT JOIN outcomes ON (classes.class = outcomes.ship OR ships.name = outcomes.ship)
WHERE outcomes.battle = 'Guadalcanal';

-- 48. Find the ship classes having at least one ship sunk in battles.
SELECT classes.class
FROM classes
JOIN outcomes ON classes.class = outcomes.ship
WHERE outcomes.result = 'sunk'
UNION
SELECT ships.class
FROM ships
JOIN outcomes ON ships.name = outcomes.ship
WHERE outcomes.result = 'sunk';

-- 48.
SELECT t1.class
FROM (
    SELECT classes.class, outcomes.result
    FROM classes
    JOIN outcomes ON classes.class = outcomes.ship
    UNION
    SELECT ships.class, outcomes.result
    FROM ships
    JOIN outcomes ON ships.name = outcomes.ship
) AS t1
WHERE t1.result = 'sunk';


-- 48.
SELECT DISTINCT classes.class
FROM classes
LEFT JOIN ships ON ships.class = classes.class
WHERE classes.class IN (
    SELECT ship
    FROM outcomes
    WHERE result = 'sunk'
) OR ships.name IN (
    SELECT ship
    FROM outcomes
    WHERE result = 'sunk'
);

-- 49. Find the names of the ships having a gun caliber of 16 inches (including ships in the Outcomes table).
-- classes.class = outcomes.ship – lead ship – ship whose name is assigned to class
SELECT t1.ship_name
FROM (
    SELECT classes.bore, outcomes.ship AS ship_name
    FROM outcomes
    JOIN classes ON classes.class = outcomes.ship
    UNION
    SELECT classes.bore, ships.name AS ship_name
    FROM ships
    JOIN classes ON ships.class = classes.class
) AS t1
WHERE t1.bore = 16;

-- 50. Find the battles in which Kongo-class ships from the Ships table were engaged.
SELECT DISTINCT outcomes.battle
FROM outcomes
JOIN ships ON outcomes.ship = ships.name
WHERE ships.class = 'Kongo';

-- 50.
SELECT DISTINCT outcomes.battle
FROM outcomes
WHERE outcomes.ship IN (
    SELECT ships.name
    FROM ships
    WHERE ships.class = 'Kongo'
);