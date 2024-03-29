-- How many stops are in the database.

SELECT COUNT(name) 
FROM stops;

-- Find the id value for the stop 'Craiglockhart'

SELECT id 
FROM stops 
WHERE name = 'Craiglockhart';

-- Give the id and the name for the stops on the '4' 'LRT' service.

SELECT stops.id, stops.name 
FROM stops
INNER JOIN route ON stops.id = route.stop
WHERE route.num = '4' AND route.company = 'LRT' 

-- Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num 
HAVING COUNT(*) = 2;

--Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149;

--Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT DISTINCT a.company, a.num
FROM route AS a
INNER JOIN route AS b
ON (a.company = b.company AND a.num = b.num)
INNER JOIN stops AS stopa ON (a.stop = stopa.id)
INNER JOIN stops AS stopb ON (b.stop = stopb.id)
WHERE stopa.name ='Haymarket' AND stopb.name ='Leith';

-- Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT DISTINCT a.company, a.num
FROM route AS a
INNER JOIN route AS b
ON (a.company = b.company AND a.num = b.num)
INNER JOIN stops AS stopa ON (a.stop = stopa.id)
INNER JOIN stops AS stopb ON (b.stop = stopb.id)
WHERE stopa.name ='Craiglockhart' AND stopb.name ='Tollcross';

-- Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company.

SELECT DISTINCT stopb.name, a.company, a.num
FROM route AS a JOIN route AS b
ON (a.company = b.company AND a.num = b.num)
 JOIN stops AS stopa ON a.stop = stopa.id
 JOIN stops AS stopb ON b.stop = stopb.id
WHERE stopa.name ='Craiglockhart' AND a.company ='LRT'

-- Find the routes involving two buses that can go from Craiglockhart to Lochend. Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.

SELECT DISTINCT bus1.num, bus1.company, bus1.name, bus2.num, bus2.company FROM (
SELECT a.num, a.company, stopb.name FROM
route a JOIN route b ON
a.company = b.company AND a.num = b.num
JOIN stops stopa  ON a.stop = stopa.id
JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart'
) AS bus1
JOIN (
SELECT a.num, a.company, stopb.name FROM
route a JOIN route b ON
a.company = b.company AND a.num = b.num
JOIN stops stopa  ON a.stop = stopa.id
JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Lochend'
) AS bus2
ON bus1.name = bus2.name
ORDER BY bus1.num, bus1.company, bus1.name, bus2.num, bus2.company