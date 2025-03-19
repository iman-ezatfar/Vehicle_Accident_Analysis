SELECT TOP (1000) [VehicleID]
      ,[AccidentIndex]
      ,[VehicleType]
      ,[PointImpact]
      ,[LeftHand]
      ,[JourneyPurpose]
      ,[Propulsion]
      ,[AgeVehicle]
  FROM [PortfolioProjects].[dbo].[vehicle]

  SELECT TOP (1000) [AccidentIndex]
      ,[Severity]
      ,[Date]
      ,[Day]
      ,[SpeedLimit]
      ,[LightConditions]
      ,[WeatherConditions]
      ,[RoadConditions]
      ,[Area]
  FROM [PortfolioProjects].[dbo].[accident]

  -----------------------------------------

 --Question 1: How many accidents have occurred in urban areas versus rural areas?

 SELECT SUM(CASE WHEN Area= 'Urban' Then 1 Else 0 END) AS Urban_Accident,
		SUM(CASE WHEN Area = 'Rural' Then 1 Else 0 END) AS Rural_Accident
FROM PortfolioProjects..accident
------------------------------------------

--Question 2: Which day of the week has the highest number of accidents?

SELECT TOP(1) Day,COUNT(accidentIndex) as accident_count
FROM PortfolioProjects..accident
Group BY day
ORDER BY COUNT(accidentindex) DESC
-----------------------------------------

--Question 3: What is the average age of vehicles involved in accidents based on their type?

SELECT VehicleType,AVG(AgeVehicle) as Average_Vehicle_Age
FROM [dbo].vehicle
GROUP BY VehicleType
ORDER BY Average_Vehicle_Age DESC
-----------------------------------------

--Question 4: Can we identify any trends in accidents based on the age of the vehicles involved?
SELECT 
    CASE 
        WHEN v.AgeVehicle BETWEEN 0 AND 5 THEN '0-5 Years'
        WHEN v.AgeVehicle BETWEEN 6 AND 10 THEN '6-10 Years'
        WHEN v.AgeVehicle BETWEEN 11 AND 15 THEN '11-15 Years'
        ELSE '16+ Years' 
    END AS Vehicle_Age_Category,
    COUNT(a.AccidentIndex) AS Total_Accidents
FROM PortfolioProjects..accident a
LEFT JOIN PortfolioProjects..vehicle v 
    ON a.AccidentIndex = v.AccidentIndex
GROUP BY 
    CASE 
        WHEN v.AgeVehicle BETWEEN 0 AND 5 THEN '0-5 Years'
        WHEN v.AgeVehicle BETWEEN 6 AND 10 THEN '6-10 Years'
        WHEN v.AgeVehicle BETWEEN 11 AND 15 THEN '11-15 Years'
        ELSE '16+ Years'
    END
ORDER BY Total_Accidents DESC;


-----------------------------------------


--Question 5: Are there any specific weather conditions that contribute to severe accidents?

SELECT WeatherConditions, COUNT(accidentindex) as accident
FROM dbo.accident
WHERE WeatherConditions != 'Unknown'
GROUP BY WeatherConditions
ORDER BY accident DESC

----------------------------------------

--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?


SELECT v.LeftHand, COUNT(a.accidentindex) as accident
FROM dbo.accident a
LEFT JOIN dbo.vehicle v ON
a.AccidentIndex = v.AccidentIndex
WHERE v.LeftHand IS NOT NULL
GROUP BY v.LeftHand
ORDER BY accident DESC

---------------------------------------

--Question 7: Are there any relationships between journey purposes and the severity of accidents?


SELECT v.JourneyPurpose, COUNT(a.Severity) as accident_severity
FROM dbo.accident a
LEFT JOIN dbo.vehicle v ON
a.AccidentIndex = v.AccidentIndex
GROUP BY v.JourneyPurpose
ORDER BY accident_severity DESC
-----------------------------------------


--Question 8: Calculate the average age of vehicles involved in accidents, considering daylight and point of impact

SELECT a.LightConditions, v.PointImpact, AVG(v.agevehicle) AS Avg_Vehicle_Age
FROM dbo.accident a
LEFT JOIN dbo.vehicle v ON
a.AccidentIndex = v.AccidentIndex
GROUP BY a.LightConditions,v.PointImpact
ORDER BY Avg_Vehicle_Age DESC
----------------------------------------