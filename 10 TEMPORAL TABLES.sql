/*
TEMPORAL TABLES: 
	A MECHANISM TO CREATE ADDITIONAL HISTORY TRACKING TABLES.
	BASED ON EXISTING ROW UPDATES & DELETES ON THE BASE TABLE.

MEANS:
	WHENEVER WE PERFORM ANY UPDATE / DELETE TO THE BASE TABLE
	SUCH OPERATIONS ARE AUTO AUDITTED TO ADDITIONAL TABLE CALLED  : "TEMPORAL TABLE"
	THIS TEMPORAL TABLE IS AUTO CREATED DURING THE BASE TABLE CREATION ITSELF. 

	THIS TEMPORAL TABLE IS USED FOR :
		1. TRACKING HISTORICAL DATA, CAN ALSO BE USED FOR ACCIDENTAL DATA RECOVERY  BY DBAs
		2. INCREMENTAL DATA LOADS (ETL IN DWH DB DESIGN) BY BI DEVELOPERS

	TEMPORAL TABLES ARE NEW FEATURE FROM SQL SERVER 2016.
*/


create table Employee
(
Emp_ID int PRIMARY KEY CLUSTERED,			-- MANDATORY
Emp_name varchar(15),
Emp_desc varchar(100),
[ValidFrom] datetime2 (2) GENERATED ALWAYS AS ROW START,		-- TO AUDIT ROW INSERTION DATE
[ValidTo] datetime2 (2) GENERATED ALWAYS AS ROW END ,			-- TO AUDIT ROW UPDATE / DELETE DATE
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)						-- THIS IS A COMPUTED COLUMN					
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));	-- THIS HISTORY TABLE IS AUTO CREATED


select * from Employee
SELECT * FROM EmployeeHistory


insert into Employee(Emp_ID,Emp_name,Emp_desc) values ( 1001,'Steve Ley' ,'Program Manager , 5+ Exp, Excellent Communication Skills')
insert into Employee(Emp_ID,Emp_name,Emp_desc) values ( 1002,'Jonathan' ,'Executive Manager , 10+ Exp, Excellent Domain Skills')
insert into Employee(Emp_ID,Emp_name,Emp_desc) values ( 1003,'Jonathan Little' ,'Executive Manager , 10+ Exp, Excellent Domain Skills')
insert into Employee(Emp_ID,Emp_name,Emp_desc) values ( 1004, 'Little' ,'Executive Manager , 10+ Exp, Excellent Domain Skills')
insert into Employee(Emp_ID,Emp_name,Emp_desc) values ( 1005,'Jona' ,'Executive Manager , 10+ Exp, Excellent Domain Skills')
insert into Employee(Emp_ID,Emp_name,Emp_desc) values ( 1006,'Jonathan L' ,'Executive Manager , 10+ Exp, Excellent Domain Skills')
insert into Employee(Emp_ID,Emp_name,Emp_desc) values ( 1007,'GEORE' ,'Executive Manager , 10+ Exp, Excellent Domain Skills')
insert into Employee(Emp_ID,Emp_name,Emp_desc) values ( 1008,'JEFF' ,'Executive Manager , 10+ Exp, Excellent Domain Skills')


select * from Employee							-- 8 ROWS
SELECT * FROM EmployeeHistory					-- 0 ROWS


UPDATE Employee	SET EMP_NAME = 'NAME NEW' WHERE EMP_ID = 1001


select * from Employee						-- 8 ROWS
SELECT * FROM EmployeeHistory				-- 1 ROWS

DELETE FROM Employee WHERE EMP_ID = 1008     -- 1 ROW IS REMOVED

select * from Employee						-- 7 ROWS
SELECT * FROM EmployeeHistory				-- 2 ROWS
