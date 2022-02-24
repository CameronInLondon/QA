--------------- Course 3 - TASK2 ----------------
----- load in new data and check row count -------

SELECT COUNT (*) AS make_model
FROM [dbo].[Make_Model]

SELECT COUNT (*) AS vehicle_type
FROM [dbo].[Vehicle_Type]

----- Create new table --------
-- Create a new table using model from make_model table called Model_Type
SELECT DISTINCT model, make INTO Model_Type FROM [dbo].[Make_Model]

SELECT COUNT (*) AS count
FROM [dbo].Model_Type

-- add ID column to new model_type table
ALTER TABLE [dbo].Model_Type ADD code INT IDENTITY

-------------------------- Q1 ------------------------------------------- 
----- Q1 Show number and percentage of accidents where neither Make or Model has been recorded.

-- count of NOT NULLs vs full count
-- inner select counts not nulls, outer statement counts all.
CREATE VIEW Count_nulls_and_not_nulls_with_model
AS
SELECT NULLS, count(*) AS 'count of vehicles', [model]
FROM
(
	SELECT [model],
	CASE
	WHEN [model] is NOT NULL AND [make] is NOT NULL THEN 'NOT NULL'
	WHEN [model] is NULL OR [make] is NULL THEN 'IS_NULL'
	END AS NULLS
FROM [dbo].[Make_Model]
) MD
GROUP BY NULLS, [model]


-- percengtage of accidents where neither Make or Model has been recorded & rest of count percentage.
-- percengtage giving 28.9% which is correct
CREATE VIEW accidents_make_model_not_recorded_percent  -- create as a view.
AS
SELECT 100.0 * (COUNT(*) - COUNT(model)) / COUNT(*) AS 'Model_Percent', 
100 - (100.0 * (COUNT(*) - COUNT(model)) / COUNT(*))  AS 'not Model Percent'
FROM [dbo].[Make_Model]


-- agregate count of nulls and not nulls for model
CREATE VIEW [dbo].[Count_nulls_and_not_nulls]  -- create as a view.
AS
SELECT NULLS, count(*) AS 'count of vehicles' 
FROM
(
	SELECT 
	CASE
	WHEN [model] is NOT NULL AND [make] is NOT NULL THEN 'NOT NULL'
	WHEN [model] is NULL OR [make] is NULL THEN 'IS_NULL'
	END AS NULLS
FROM [dbo].[Make_Model]
) MD
GROUP BY NULLS







---------------------------------- Q2 ----------------------------------------------------
----- Q2 Show number and percentage of accidents where either Make or Model has been recorded but vehicle type is a motor vehicle of some kind.


-- view to show when NULLs and not NULLs - not 100% sure this is correct. 
CREATE VIEW NULLs_notNulls_make_or_model_and_motor_type
AS
SELECT NULLS, count(*) AS 'count of vehicles', [model], [Vehicle_Type]
FROM
(
	SELECT [model], [Vehicle_Type],
	CASE
	WHEN [model] is NOT NULL AND [make] is NOT NULL THEN 'NOT NULL'
	WHEN [model] is NULL OR [make] is NULL THEN 'IS_NULL'
	END AS NULLS
FROM [dbo].[Make_Model]
WHERE [Make_Model].[Vehicle_Type] NOT in (1, 16, 22, 90, 18, 17, -1)
) MD
GROUP BY NULLS, [model], [Vehicle_Type]


-- percenatage
CREATE VIEW accidents_make_model_not_recorded_percent_and_motor_type
AS
SELECT 100.0 * (COUNT(*) - COUNT(model)) / COUNT(*) AS 'Model_Percent', 
100 - (100.0 * (COUNT(*) - COUNT(model)) / COUNT(*))  AS 'not Model Percent'
FROM [dbo].[Make_Model]
WHERE [Make_Model].[Vehicle_Type] NOT in (1, 16, 22, 90, 18, 17, -1)



-- agregated view
CREATE VIEW [dbo].Count_nulls_and_not_nulls_only_motor_type
AS
SELECT NULLS, count(*) AS 'count of vehicles' 
FROM
(
	SELECT 
	CASE
	WHEN [model] is NOT NULL AND [make] is NOT NULL THEN 'NOT NULL'
	WHEN [model] is NULL OR [make] is NULL THEN 'IS_NULL'
	END AS NULLS
FROM [dbo].[Make_Model]
WHERE [Make_Model].[Vehicle_Type] NOT in (1, 16, 22, 90, 18, 17, -1)
) MD
GROUP BY NULLS


-------------------------------------- Q3 ---------------------------------------------------
------ Q3 Breakdown of vehicle types using the following categories:
------    Two-wheeled vehicles, cars, vans, taxis, goods vehicles, multiple passenger vehicles.



--- get a count of each Vehicle_Cat when model was not recored - this work but is long winded way of doing it.
CREATE VIEW Vehicle_Cat_model_not_recorded
AS
SELECT [Vehicle_Cat], COUNT(*) as 'count when model was not recorded'
FROM
(
	SELECT --[Make_Model].[model], [Make_Model].[Vehicle_Type],
	CASE
		WHEN (Vehicle_Type BETWEEN 2 AND 5) AND model IS NULL THEN 'Two-wheeled vehicles' 
		WHEN (Vehicle_Type = 9) AND model IS NULL THEN 'Cars'
		WHEN (Vehicle_Type = 19) AND model IS NULL THEN 'Vans'
		WHEN (Vehicle_Type = 8) AND model IS NULL THEN 'Taxis'
		WHEN (Vehicle_Type = 20 OR Vehicle_Type = 21 OR Vehicle_Type = 98) AND model IS NULL THEN 'Goods vehicles'
		WHEN (Vehicle_Type = 10 OR Vehicle_Type = 11) AND model IS NULL THEN 'multiple passenger vehicles'
		ELSE 'OTHER'
	END AS Vehicle_Cat
FROM [dbo].[Make_Model]
) XX
GROUP BY Vehicle_Cat



-- Vehicle_type with count of each, showing Vehicle_cat
CREATE VIEW Count_Vehicle_Cat_vehicle_type
AS

SELECT [Vehicle_Cat], COUNT(*) as count,  [Vehicle_Type]
FROM
(
	SELECT [Make_Model].[Vehicle_Type],
	CASE
		WHEN Vehicle_Type BETWEEN 2 AND 5 THEN 'Two-wheeled vehicles'
		WHEN Vehicle_Type = 9 THEN 'Cars'
		WHEN Vehicle_Type = 19 THEN 'Vans'
		WHEN Vehicle_Type = 8 THEN 'Taxis'
		WHEN Vehicle_Type = 20 OR Vehicle_Type = 21 OR Vehicle_Type = 98 THEN 'Goods vehicles'
		WHEN Vehicle_Type = 10 OR Vehicle_Type = 11 THEN 'multiple passenger vehicles'
		ELSE 'OTHER'
	END AS Vehicle_Cat
FROM [dbo].[Make_Model]
) VT
GROUP BY [Vehicle_Type], Vehicle_Cat 





















----------------------------------------------------------------------------------------------
---------------- NOT USING or NOT WORKIHG ----------------------------------------------------
----------------------------------------------------------------------------------------------

-- NOT WORKING - percentage of NOT NULLs -- percentage of accidents where neither Make or Model has been recorded.
SELECT  COUNT(*)
FROM [dbo].[Make_Model]
WHERE [model] is NOT NULL -- AND [make] is NOT NULL

-- NOT WORKING
SELECT (COUNT (MM.[model]) /  COUNT MM.[make]) * 100 AS PCT_NOT_Nulls
FROM [dbo].[Make_Model] as MM
WHERE [model] is NOT NULL



-- giving 28.9% which is not picking up the VT motor vehicle
SELECT 100.0 * (COUNT(*) - COUNT(model)) / COUNT(*) AS ModelPercent
FROM [dbo].[Make_Model] AS MM
INNER JOIN [dbo].[Vehicle_Type] AS VT ON MM.[Vehicle_Type] = VT.[code]

-- another way of working out percentage, giving 28.9% which is not picking up the VT motor vehicle
SELECT 100.0 * SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS ModelPercent
FROM [dbo].[Make_Model] AS MM
INNER JOIN [dbo].[Vehicle_Type] AS VT ON MM.[Vehicle_Type] = VT.[code]


-- percenatage as above and also perceantage of whats is left - NOT WORKING
SELECT perc 
FROM
(
	SELECT
	CASE
	WHEN sum (100.0 * (COUNT(*) - COUNT(model)) / COUNT(*)) THEN 'Model Percent'
	WHEN sum (100.0 * (COUNT(model) - COUNT(*)) / COUNT(*)) THEN 'not Model Percent'
	END AS perc
FROM [dbo].[Make_Model]
) model
GROUP BY perc

-- as above but not working............
SELECT 
sum (CASE WHEN 100.0 * (COUNT(*) - COUNT(model)) / COUNT(*) END) AS 'Model Percent',
sum (CASE WHEN 100.0 * (COUNT(model) - COUNT(*)) / COUNT(*) END) AS 'not Model Percent'
FROM [dbo].[Make_Model]



-- create view -- will do percentage in powerBI
CREATE VIEW percenatage_NULLs_make_or_model_and_motor_type
AS
SELECT 100.0 * SUM(CASE WHEN (model IS NULL) AND VT.[code] NOT in (1, 16, 22, 90, 18, 17, -1) THEN 1 ELSE 0 END) / COUNT(*) AS 'neither Make or Model but is motor vehicle as Percent'
FROM [dbo].[Make_Model] AS MM
INNER JOIN [dbo].[Vehicle_Type] AS VT ON MM.[Vehicle_Type] = VT.[code]



-- count of NOT NULLs -- count of accidents where neither Make or Model has been recorded.
SELECT  COUNT (*) AS 'count of not NULL, make and model'
FROM [dbo].[Make_Model]
WHERE [model] is NOT NULL AND [make] is NOT NULL

-- basic percentage of nulls - 28%
SELECT 100.0 * (COUNT(*) - COUNT(model)) / COUNT(*) AS 'Model Percent'
FROM [dbo].[Make_Model]
--WHERE [model] is NOT NULL AND [make] is NOT NULL

-- create view
CREATE VIEW percent_Make_and_model_not_recorded
AS
SELECT 100.0 * (COUNT(*) - COUNT(model)) / COUNT(*) AS 'Model Percent'
FROM [dbo].[Make_Model]


-- count of NULLs -- just to check the maths
SELECT  COUNT (*) AS 'count of NULLs, make OR model'
FROM [dbo].[Make_Model]
WHERE [model] is NULL AND [make] is NULL


-- Visualisation showing number and percentage of accidents where either Make or Model has been recorded.
-- create view
CREATE VIEW Make_and_model_not_recorded
AS
	SELECT  COUNT (*) AS 'count of not NULL, make and model'
	FROM [dbo].[Make_Model]
	WHERE [model] is NOT NULL AND [make] is NOT NULL


	-- count of NOT NULLs -- count of accidents where neither Make or Model has been recorded but vehicle type is a motor vehicle of some kind.
SELECT  COUNT (*) AS 'count of NULLs, make OR model when type motor vehicle'
FROM [dbo].[Make_Model] AS MM
INNER JOIN [dbo].[Vehicle_Type] AS VT ON MM.[Vehicle_Type] = VT.[code]
WHERE ([model] is NULL OR [make] is NULL) AND VT.[code] NOT in (1, 16, 22, 90, 18, 17, -1)


-- NOTE - COUNT(*) will count NULLS, COUNT(ColumnName) does not!!!
-- percentage of accidents where neither Make or Model has been recorded but vehicle type is a motor vehicle of some kind.
-- percengtage gives 20.8%
SELECT 100.0 * SUM(CASE WHEN (model IS NULL) AND VT.[code] NOT in (1, 16, 22, 90, 18, 17, -1) THEN 1 ELSE 0 END) / COUNT(*) AS 'neither Make or Model but is motor vehicle as Percent'
FROM [dbo].[Make_Model] AS MM
INNER JOIN [dbo].[Vehicle_Type] AS VT ON MM.[Vehicle_Type] = VT.[code]


-- Visualisation showing number and percentage of accidents where either Make or Model has been recorded 
-- but vehicle type is a motor vehicle of some kind.
-- create view

CREATE VIEW count_of_NULLs_make_or_model_and_motor_type
AS
SELECT  COUNT (*) AS 'count of NULLs, make OR model when type motor vehicle'
FROM [dbo].[Make_Model] AS MM
WHERE ([model] is NULL OR [make] is NULL) AND MM.[Vehicle_Type] NOT in (1, 16, 22, 90, 18, 17, -1)


-- model nulls and only motor type
SELECT  COUNT (*) AS 'count of NULLs, make OR model when type motor vehicle'
FROM [dbo].[Make_Model] AS MM
WHERE ([model] is NULL OR [make] is NULL) AND MM.[Vehicle_Type] NOT in (1, 16, 22, 90, 18, 17, -1) -- excluding 1,16,22,90,17,1 reduce count by 21635. 


------------------ from Q3 --------------------------

--- get a count of each Vehicle_Cat showing only accidents where either make or model has been record but vehicle type is motor vehicle
-- NOT WORKING as I want it to.
SELECT [Vehicle_Cat], COUNT(*) as count_of_motor_vehicles, COUNT(*) as count_of_motor_vehicles_NULLs
FROM 
(
	SELECT
	CASE
		WHEN Vehicle_Type BETWEEN 2 AND 5 THEN 'Two-wheeled vehicles'
		WHEN Vehicle_Type = 9 THEN 'Cars'
		WHEN Vehicle_Type = 19 THEN 'Vans'
		WHEN Vehicle_Type = 8 THEN 'Taxis'
		WHEN Vehicle_Type = 20 OR Vehicle_Type = 21 OR Vehicle_Type = 98 THEN 'Goods vehicles'
		WHEN Vehicle_Type = 10 OR Vehicle_Type = 11 THEN 'multiple passenger vehicles'
		ELSE 'OTHER'
	END AS Vehicle_Cat
FROM [dbo].[Make_Model] AS MM
) VT
GROUP BY Vehicle_Cat
UNION
SELECT [Vehicle_Cat], COUNT(*) as count_of_motor_vehicles, COUNT(*) as count_of_motor_vehicles_NULLs 
FROM 
(
	SELECT
	CASE
		WHEN (Vehicle_Type BETWEEN 2 AND 5) AND model IS NULL THEN 'Two-wheeled vehicles' 
		WHEN (Vehicle_Type = 9) AND model IS NULL THEN 'Cars when model is NULL'
		WHEN (Vehicle_Type = 19) AND model IS NULL THEN 'Vans when model is NULL'
		WHEN (Vehicle_Type = 8) AND model IS NULL THEN 'Taxis when model is NULL'
		WHEN (Vehicle_Type = 20 OR Vehicle_Type = 21 OR Vehicle_Type = 98) AND model IS NULL THEN 'Goods vehicles when model is NULL'
		WHEN (Vehicle_Type = 10 OR Vehicle_Type = 11) AND model IS NULL THEN 'multiple passenger vehicles when model is NULL'
		ELSE 'OTHER.'
	END AS Vehicle_Cat
FROM [dbo].[Make_Model] AS MM
) VT
GROUP BY Vehicle_Cat



SELECT  Vehicle_Type,
	CASE
		WHEN Vehicle_Type BETWEEN 2 AND 5 THEN 'Two-wheeled vehicles'
		WHEN Vehicle_Type = 9 THEN 'Cars'
		WHEN Vehicle_Type = 19 THEN 'Vans'
		WHEN Vehicle_Type = 8 THEN 'Taxis'
		WHEN Vehicle_Type = 20 OR Vehicle_Type = 21 OR Vehicle_Type = 98 THEN 'Goods vehicles'
		WHEN Vehicle_Type = 10 OR Vehicle_Type = 11 THEN 'multiple passenger vehicles'
		ELSE 'OTHER'
	END AS Vehicle_Cat
FROM [dbo].[Make_Model]




--- get a count of each Vehicle_Cat using subquery as per class -- NOT USED but is working I think.
SELECT [Vehicle_Cat], Sum(NomodelRecorded) as NoModelRecordedCount, Sum(VehicleCount) as VehicleCount
FROM
(
	SELECT 
	CASE
		WHEN Vehicle_Type BETWEEN 2 AND 5 THEN 'Two-wheeled vehicles'
		WHEN Vehicle_Type = 9 THEN 'Cars'
		WHEN Vehicle_Type = 19 THEN 'Vans'
		WHEN Vehicle_Type = 8 THEN 'Taxis'
		WHEN Vehicle_Type = 20 OR Vehicle_Type = 21 OR Vehicle_Type = 98 THEN 'Goods vehicles'
		WHEN Vehicle_Type = 10 OR Vehicle_Type = 11 THEN 'multiple passenger vehicles'
		ELSE 'OTHER'
	END AS Vehicle_Cat,
	CASE WHEN [model] is NULL then 1 else 0 end as NoModelRecorded,
	1 as VehicleCount
FROM [dbo].[Make_Model]
) VT
GROUP BY Vehicle_Cat


-- WORKs but did not use.
SELECT  Vehicle_Type,
	CASE
		WHEN Vehicle_Type BETWEEN 2 AND 5 THEN 'Two-wheeled vehicles'
		WHEN Vehicle_Type = 9 THEN 'Cars'
		WHEN Vehicle_Type = 19 THEN 'Vans'
		WHEN Vehicle_Type = 8 THEN 'Taxis'
		WHEN Vehicle_Type = 20 OR Vehicle_Type = 21 OR Vehicle_Type = 98 THEN 'Goods vehicles'
		WHEN Vehicle_Type = 10 OR Vehicle_Type = 11 THEN 'multiple passenger vehicles'
		ELSE 'OTHER'
	END AS Vehicle_Cat
FROM [dbo].[Make_Model]