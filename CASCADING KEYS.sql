use tempdb
go

-- TABLE #1: COURSES TABLE
CREATE TABLE tblCourses
(
CourseName varchar(30) PRIMARY KEY,   
CourseDuration tinyint CHECK (CourseDuration = 120 or CourseDuration = 180),
CourseStatus BIT 			
)

INSERT INTO tblCourses VALUES ('COMPUTERS', 180, 1), ('CIVIL', 180, 1), ('ROBOTICS', 120, 1)
SELECT * FROM tblCourses


-- TABLE #2: STUDENTS TABLE
CREATE TABLE tblStudents
(
StdID int UNIQUE,	
StdName varchar(40) NOT NULL , 
StdGender CHAR(1) CHECK (StdGender = 'M' OR StdGender = 'F'),
StdAge tinyint CHECK (StdAge >= 18),
StdCourse varchar(30)	REFERENCES tblCourses(CourseName)	ON UPDATE CASCADE           ON DELETE CASCADE,
CONSTRAINT UQ_ID_NAME UNIQUE (StdID, StdName)		-- THIS IS COMPOSITE KEY : SUCH KEY THAT CONTAINS MORE THAN ONE COLUMN.
)

INSERT INTO tblStudents VALUES (1001, 'SAI', 'M', 29, 'COMPUTERS'), 
(1002, 'JOHN', 'M', 19, 'COMPUTERS'), 	 (1003, 'JEFF', 'M', 20, 'CIVIL'),
(1004, 'JOHNY', 'M', 21, 'COMPUTERS'),	(1005, 'JEFFREY', 'M', 21, 'CIVIL'), 
(1006, 'AMI', 'F', 20, 'COMPUTERS'),	(1007, 'AMIN', 'M', 22, 'CIVIL')


SELECT * FROM tblCourses
SELECT * FROM tblStudents


-- HOW TO TEST "ON UPDATE CASCADE" ?
UPDATE tblCourses SET CourseName = 'Comp Science' WHERE CourseName = 'COMPUTERS'
SELECT * FROM tblCourses
SELECT * FROM tblStudents


-- HOW TO TEST "ON DELETE CASCADE" ?
DELETE FROM tblCourses WHERE CourseName = 'Comp Science'
SELECT * FROM tblCourses
SELECT * FROM tblStudents



