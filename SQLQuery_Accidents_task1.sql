----------------------------
--- Chllenge 3 - Task 1
----------------------------

-- check all imported correctly (140056)
SELECT COUNT (*)
FROM [dbo].[Accidents_2015]

-- (3)
SELECT COUNT (*)
FROM [dbo].[Accident_Severity]

-- (10)
SELECT COUNT (*)
FROM [dbo].[Weather]

--------------------------------------------------------------------
--- Q1 Do lower speed limits reduce the likelihood of accidents? ---
-- Count the number of accidents in at each speed

SELECT [Speed_limit], COUNT (*) AS count
FROM [dbo].[Accidents_2015]
GROUP BY [Speed_limit]
ORDER BY count DESC

-- create a view of the above query
CREATE VIEW speed_of_accidents
AS
SELECT [Speed_limit], COUNT (*) AS count
FROM [dbo].[Accidents_2015]
GROUP BY [Speed_limit]
-- ORDER BY count DESC

-----------
-- Q1 Answer - there are more accidents at 30mph. But this is not conclusive as there might just be more cars driving at 30mph
-----------



--------------------------------------------------------------
--- Q2 Do lower speed limits reduce the severity of accidents?

SELECT COUNT(*) AS count, SEV.[label] AS accident_severity, ACC.[Speed_limit]
FROM [dbo].[Accidents_2015] AS ACC
INNER JOIN [dbo].[Accident_Severity] AS SEV 
ON ACC.[Accident_Severity] = SEV.[code]
GROUP BY SEV.[label], ACC.[Speed_limit]
ORDER BY COUNT(*) DESC

-- create a view of the above query
CREATE VIEW speed_and_severity
AS
SELECT COUNT(*) AS count, SEV.[label] AS accident_severity, ACC.[Speed_limit]
FROM [dbo].[Accidents_2015] AS ACC
INNER JOIN [dbo].[Accident_Severity] AS SEV 
ON ACC.[Accident_Severity] = SEV.[code]
GROUP BY SEV.[label], ACC.[Speed_limit]

---------
-- Q2 Answer - There does not seem to be a link between speed and severity as there are simlar number of fatal accidents at both 30mph and 60mph
---------


--------------------------------------------------------------
-- Q3 How much of a factor is prevailing weather?

SELECT COUNT(*) as count, WET.[label] AS weather_conditions
-- joining Accidents_2015 and Weather tables
FROM [dbo].[Accidents_2015] AS ACC
INNER JOIN [dbo].[Weather] AS WET
-- join on 
ON ACC.[Weather_Conditions] = WET.[code]
GROUP BY WET.[label]
ORDER BY COUNT(*) DESC


CREATE VIEW prevailing_weather
AS
SELECT COUNT(*) as count, WET.[label] AS weather_conditions
FROM [dbo].[Accidents_2015] AS ACC
INNER JOIN [dbo].[Weather] AS WET
ON ACC.[Weather_Conditions] = WET.[code]
GROUP BY WET.[label]


--------
-- Q3 Answer - There does not seem to be a link between speed and weather conditions.
--------


------
-- Q3 Is the type of weather encountered a significant factor?
------

-- See data from Q3.



