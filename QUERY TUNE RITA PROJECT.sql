
USE [PRODUCT DATABASE]

--Step 1: Refer to Installation Notes----------------------------
--The given data base been properly set up and configured in your SQL environment. 
-- create and load the database, it is accessible

 Select * from dbo.TIME_DATA
 Select * from dbo.PRODUCTS_DATA
  Select * from dbo.CUSTOMERS_DATA
   Select * from dbo.SALES_DATA

 ---Step 2: Refer to Basic SQL Queries------------------------------
-- such as SELECT, JOIN, WHERE, and filtering.

SELECT A.FirstName, S.SalesOrderNumber,SalesAmount FROM  dbo.CUSTOMERS_DATA A JOIN dbo.SALES_DATA S  ON A.CustomerKey = S.CustomerKey

----regular customer
SELECT A.CustomerKey, count (SalesOrderNumber) as [countOrder] ,SalesAmount FROM 
dbo.CUSTOMERS_DATA A JOIN dbo.SALES_DATA S  ON A.CustomerKey = S.CustomerKey GROUP BY 
A.CustomerKey, SalesAmount Having count (SalesOrderNumber) > 1

---new customer
SELECT A.CustomerKey, count (SalesOrderNumber) as [countOrder] ,SalesAmount FROM 
dbo.CUSTOMERS_DATA A JOIN dbo.SALES_DATA S  ON A.CustomerKey = S.CustomerKey GROUP BY 
A.CustomerKey, SalesAmount Having count (SalesOrderNumber) = 1

---Step 3: Understand Database Architecture-------------------------
---FILES IN DATABASE
Select type_desc,name,physical_name from SYS.database_files 
-------
Select * from INFORMATION_SCHEMA.TABLES
---
SP_HELP
-------
Select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo'


--Step 4: Identify Relations and Constraints-----------------------------------------
--- Identify the relationships between tables 
SP_HELPINDEX 'dbo.TIME_DATA '
-----object IN DATABASE
Select name,type_desc   from SYS.objects 
----constraint
Select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
Select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS


--Step 5: Define Join Query-------------------------------------------
-- A query to join the PRODUCTS_DATA and SALES_DATA tables based on a common column (PRODUCTKEY).

SELECT * FROM [dbo].[PRODUCTS_DATA] (ReadPast) as P  INNER JOIN
[dbo].[SALES_DATA] (Readpast) as S ON P.ProductKey = S.ProductKey



----------------------QUESTION I---------------------------------------
---1. LOCATION OF DATABASE ?
SP_HELPFILE

----------------------QUESTION 2---------------------------------------
--2. SIZE OF EACH TABLE ?
EXEC SP_MSforeachtable @command1 = " EXEC SP_SPACEUSED  '?'"
----
EXEC SP_SPACEUSED

----------------------QUESTION 3---------------------------------------
--3. WHICH TABLE HAS MORE ROWS ?
Select top 1 t.name as TableName, p.rows as RowCounts from  SYS.TABLES t  JOIN SYS.partitions p
ON t.object_id = p.object_id 
GROUP BY t.name,p.rows ORDER BY p.rows desc
--------------
Select t.name as TableName , p.rows as ROwNumber from SYS.TABLES t  JOIN SYS.partitions p
ON t.object_id = p.object_id where p.index_id IN (0,1)
GROUP BY t.name,p.rows 
ORDER BY p.rows desc

----------------------QUESTION 4---------------------------------------
---4. HOW MANY POSSIBLE EXTENTS PER EACH TABLE?
-- To calculate the number of extents used by each table
SELECT 
    t.NAME AS TableName,
    (SUM(a.total_pages) / 8) AS ExtentsUsed
FROM 
    sys.tables t
INNER JOIN 
    sys.indexes i ON t.object_id = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
GROUP BY 
    t.NAME
ORDER BY 
    ExtentsUsed DESC;

	----------------------QUESTION 5---------------------------------------
	--5. VERIFY TDS PACKETS FOR ABOVE QUERY?
	 Select * from dbo.TIME_DATA
	--Right Click Include Live Query Staistics

		----------------------QUESTION 6---------------------------------------
		--6. VERIFY TABLE SCAN FOR ABOVE QUERY?
		SELECT * FROM [dbo].[PRODUCTS_DATA] (ReadPast) as P  INNER JOIN
[dbo].[SALES_DATA] (Readpast) as S ON P.ProductKey = S.ProductKey
		--Right click on the "Include Actual Execution Plan
		--"Table Scan" in the plan, it indicates that SQL Server is scanning the entire table to retrieve the data.

		---------------------QUESTION 7---------------------------------------
		--7. VERIFY INDEX SCAN FOR ABOVE QUERY?
		--Interpret the Execution Plan:Look for an operator labeled "Index Scan" in the execution plan.
		--This indicates that SQL Server scanned the index rather than the entire table.

				---------------------QUESTION 8---------------------------------------
				---HOW TO REPORT LIST OF ALL TABLES IN THE DATABASE?

				---------------------QUESTION  8---------------------------------------
				---8. VERIFY INDEX SEEK FOR ABOVE QUERY?
				-- efficiently retrieves rows using the index.
				--Ensure Index Exists:
			--Execute the Query with Execution Plan:

			---------------------QUESTION  9---------------------------------------
			-- 9. HOW TO REPORT LIST OF ALL TABLES IN THE DATABASE?

			Select * from INFORMATION_SCHEMA.TABLES

			---------------------QUESTION  10---------------------------------------
			--10. HOW TO REPORT LIST OF ALL TABLES THAT BELONG TO DEFAULT SCHEMA OF THE DATABASE?

			Select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'dbo'


			---------------------QUESTION  11---------------------------------------
			--11. HOW TO REPORT LIST OF ALL INDEXES IN THE DATABASE?
       SP_HELPINDEX 'dbo.TIME_DATA '
	   SP_HELPINDEX 'dbo.SALES_DATA '

	   			---------------------QUESTION  12---------------------------------------
		--12. HOW TO REPORT LIST OF ALL SCHEMAS IN THE DATABASE?
		Select * from INFORMATION_SCHEMA.TABLES


