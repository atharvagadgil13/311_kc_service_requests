
--RUNNING--
SELECT COUNT(*) 
FROM dbo.Atharva311Data;

--Testing--
SELECT MIN([CREATION DATE]) AS min_creation_date,
       MAX([CREATION DATE]) AS max_creation_date
FROM dbo.Atharva311Data;

--Q1A--
SELECT
    YEAR([CREATION DATE]) AS [Year],
    COUNT(*)              AS Requests
FROM dbo.Atharva311Data
WHERE [CREATION DATE] >= '2018-01-01'
  AND [CREATION DATE] <  '2022-01-01'
GROUP BY YEAR([CREATION DATE])
ORDER BY [Year];

--Q1B--
SELECT
    CONVERT(date, DATEFROMPARTS(YEAR([CREATION DATE]),
                                 MONTH([CREATION DATE]), 1)) AS [Month],
    COUNT(*) AS Requests
FROM dbo.Atharva311Data
WHERE [CREATION DATE] >= '2018-01-01'
  AND [CREATION DATE] <  '2022-01-01'
GROUP BY CONVERT(date, DATEFROMPARTS(YEAR([CREATION DATE]),
                                     MONTH([CREATION DATE]), 1))
ORDER BY [Month];

--Q2--
SELECT [SOURCE], COUNT(*) AS Requests
FROM dbo.Atharva311Data
GROUP BY [SOURCE]
ORDER BY Requests DESC;

-- Monthly by source (for a stacked area/line)
SELECT
    CONVERT(date, DATEFROMPARTS(YEAR([CREATION DATE]),
                                 MONTH([CREATION DATE]), 1)) AS [Month],
    [SOURCE],
    COUNT(*) AS Requests
FROM dbo.Atharva311Data
GROUP BY CONVERT(date, DATEFROMPARTS(YEAR([CREATION DATE]),
                                     MONTH([CREATION DATE]), 1)), [SOURCE]
ORDER BY [Month], [SOURCE];


--Q3--
SELECT [DEPARTMENT], COUNT(*) AS Requests
FROM dbo.Atharva311Data
GROUP BY [DEPARTMENT]
ORDER BY Requests DESC;

--Q4--
SELECT TOP (10)
    [CASE ID],
    [CATEGORY1],
    [TYPE],
    [CREATION DATE],
    [CLOSED DATE],
    TRY_CONVERT(float, [DAYS TO CLOSE]) AS DaysToClose
FROM dbo.Atharva311Data
WHERE TRY_CONVERT(float, [DAYS TO CLOSE]) IS NOT NULL
ORDER BY TRY_CONVERT(float, [DAYS TO CLOSE]) ASC, [CREATION DATE];

--Q5 by zip--
SELECT TOP (10)
    CAST(CAST([ZIP CODE] AS int) AS varchar(10)) AS ZipCode,
    COUNT(*) AS Requests
FROM dbo.Atharva311Data
WHERE [ZIP CODE] IS NOT NULL
GROUP BY CAST(CAST([ZIP CODE] AS int) AS varchar(10))
ORDER BY Requests DESC; 

--Q5 by street--
SELECT TOP (10)
    [STREET ADDRESS],
    COUNT(*) AS Requests
FROM dbo.Atharva311Data
WHERE [STREET ADDRESS] IS NOT NULL AND LTRIM(RTRIM([STREET ADDRESS])) <> ''
GROUP BY [STREET ADDRESS]
ORDER BY Requests DESC;  

--Q5 by latlog--
SELECT TOP (10)
    ROUND(TRY_CONVERT(float, [LATITUDE]), 3)  AS Lat_3dp,
    ROUND(TRY_CONVERT(float, [LONGITUDE]), 3) AS Lon_3dp,
    COUNT(*) AS Requests
FROM dbo.Atharva311Data
WHERE [LATITUDE]  IS NOT NULL
  AND [LONGITUDE] IS NOT NULL
GROUP BY ROUND(TRY_CONVERT(float, [LATITUDE]), 3),
         ROUND(TRY_CONVERT(float, [LONGITUDE]), 3)
ORDER BY Requests DESC;

--Q6--
SELECT
    [DEPARTMENT],
    [WORK GROUP],
    COUNT(*) AS Requests
FROM dbo.Atharva311Data
GROUP BY [DEPARTMENT], [WORK GROUP]
ORDER BY [DEPARTMENT], Requests DESC;

--Q7--
WITH D AS (
    SELECT
        [DEPARTMENT],
        TRY_CONVERT(float, [DAYS TO CLOSE]) AS DaysToClose
    FROM dbo.Atharva311Data
    WHERE TRY_CONVERT(float, [DAYS TO CLOSE]) IS NOT NULL
)
SELECT DISTINCT
    [DEPARTMENT],
    COUNT(*)                                   OVER (PARTITION BY [DEPARTMENT])        AS N,
    AVG(DaysToClose)                           OVER (PARTITION BY [DEPARTMENT])        AS AvgDays,
    MIN(DaysToClose)                           OVER (PARTITION BY [DEPARTMENT])        AS MinDays,
    MAX(DaysToClose)                           OVER (PARTITION BY [DEPARTMENT])        AS MaxDays,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY DaysToClose)
        OVER (PARTITION BY [DEPARTMENT])                                             AS P50,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY DaysToClose)
        OVER (PARTITION BY [DEPARTMENT])                                             AS P90
FROM D
ORDER BY [DEPARTMENT];


--Q8--
WITH Base AS (
  SELECT
      YEAR([CREATION DATE]) AS [Year],
      [STATUS]              AS Status,
      COUNT(*)              AS Requests
  FROM dbo.Atharva311Data
  WHERE [CREATION DATE] >= '2018-01-01'
    AND [CREATION DATE] <  '2022-01-01'
  GROUP BY YEAR([CREATION DATE]), [STATUS]
),
Totals AS (
  SELECT [Year], SUM(Requests) AS YearTotal
  FROM Base
  GROUP BY [Year]
)
SELECT b.[Year], b.Status, b.Requests,
       CAST(100.0 * b.Requests / t.YearTotal AS decimal(5,2)) AS PctOfYear
FROM Base b
JOIN Totals t ON t.[Year] = b.[Year]
ORDER BY b.[Year], b.Status;

--Q9--
SELECT TOP (10)
    [CATEGORY1],
    COUNT(*)                                      AS Requests,
    AVG(TRY_CONVERT(float, [DAYS TO CLOSE]))      AS AvgDaysToClose
FROM dbo.Atharva311Data
WHERE [CATEGORY1] IS NOT NULL
  AND TRY_CONVERT(float, [DAYS TO CLOSE]) IS NOT NULL
GROUP BY [CATEGORY1]
ORDER BY AvgDaysToClose DESC;  


--Q10--
SELECT
    [DEPARTMENT],
    COUNT(*)                                     AS Requests,
    AVG(TRY_CONVERT(float, [DAYS TO CLOSE]))     AS AvgDaysToClose
FROM dbo.Atharva311Data
WHERE TRY_CONVERT(float, [DAYS TO CLOSE]) IS NOT NULL
GROUP BY [DEPARTMENT]
ORDER BY Requests DESC;