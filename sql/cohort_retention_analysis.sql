-- cleaning adat
SELECT TOP (1000) [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [Cohort_Retention_Analysis].[dbo].[retail_info]

-- total rows 541909
 select count(*) from retail_info;
 
 -- null customer id  135080
 SELECT  [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [Cohort_Retention_Analysis].[dbo].[retail_info]
  where CustomerID is null;


WITH retail_info AS (
    SELECT  
          [InvoiceNo],
          [StockCode],
          [Description],
          [Quantity],
          [InvoiceDate],
          [UnitPrice],
          [CustomerID],
          [Country]
    FROM [Cohort_Retention_Analysis].[dbo].[retail_info]
    WHERE CustomerID IS NOT NULL
),

Quantity_unitprice AS (
    SELECT * 
    FROM retail_info 
    WHERE Quantity > 0 
      AND UnitPrice > 0
),

duplicate_check AS (
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY InvoiceNo, StockCode, Quantity,CustomerID,UnitPrice
        ORDER BY InvoiceDate
    ) AS dup_flag
    FROM Quantity_unitprice
)
-- 392689 clean data 

SELECT *
into #Online_Retail_main
FROM duplicate_check
WHERE dup_flag = 1;
 
-- Clean data 
-- Beging cohort Analysis
select * from  #Online_Retail_main;

-- Unique Identier (customerid)
-- Inital start date(First Invoice date)
-- Revenue data
DROP TABLE IF EXISTS #Cohort;
select 
    CustomerID,
    min(InvoiceDate) as first_purchase_date,
    DATEFROMPARTS (year(min(InvoiceDate)),month(min(InvoiceDate)),1) as cohort_date
    into #Cohort
from  #Online_Retail_main
group by CustomerID;

select * from  #Cohort

-- create cohort index

SELECT
    m.*,
    c.cohort_date,
    DATEDIFF(MONTH, c.cohort_date, m.InvoiceDate) + 1 AS cohort_index
    INTO #cohort_retention
FROM #Online_Retail_main AS m
LEFT JOIN #Cohort AS c
    ON m.CustomerID = c.CustomerID;

--pivot data to see the cohort table 
DROP TABLE IF EXISTS #cohort_pivot;
SELECT *
into #cohort_pivot
FROM (
    SELECT DISTINCT
        CustomerID,
        cohort_date,
        cohort_index
    FROM #cohort_retention
) AS tabl
PIVOT (
    COUNT(CustomerID)
    FOR cohort_index IN
    ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13])
) AS pivot_table
ORDER BY cohort_date;

-- Calculate customer retention percentage for each cohort month.
-- ROUND(..., 2) limits values to 2 decimal places,
-- and CAST(... AS DECIMAL(5,2)) ensures clean percentage formatting
-- for reporting and Tableau visualization.

SELECT
    cohort_date,

    CAST(ROUND(100.0 * [1]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_1,
    CAST(ROUND(100.0 * [2]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_2,
    CAST(ROUND(100.0 * [3]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_3,
    CAST(ROUND(100.0 * [4]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_4,
    CAST(ROUND(100.0 * [5]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_5,
    CAST(ROUND(100.0 * [6]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_6,
    CAST(ROUND(100.0 * [7]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_7,
    CAST(ROUND(100.0 * [8]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_8,
    CAST(ROUND(100.0 * [9]  / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_9,
    CAST(ROUND(100.0 * [10] / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_10,
    CAST(ROUND(100.0 * [11] / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_11,
    CAST(ROUND(100.0 * [12] / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_12,
    CAST(ROUND(100.0 * [13] / NULLIF([1], 0), 2) AS DECIMAL(5,2)) AS retention_13

FROM #cohort_pivot

ORDER BY cohort_date;




