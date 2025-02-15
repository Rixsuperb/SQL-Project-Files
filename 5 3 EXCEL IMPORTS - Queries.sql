
-- QUERY 1:	HOW TO VERIFY THE IMPORTED DATA ?
SELECT * FROM PRODS


-- QUERY 2:	HOW TO REPORT PRODUCTS WITH Red COLOR?
SELECT * FROM PRODS WHERE  COLOR = 'Red'


-- QUERY 3:
-- "ORDER BY" IS A KEYWORD USED TO ORDER / SORT THE DATA. 
SELECT * FROM PRODS WHERE  COLOR = 'Red' ORDER BY LISTPRICE ASC				-- LOW TO HIGH


-- QUERY 4:	
SELECT * FROM PRODS ORDER BY LISTPRICE DESC									-- HIGH TO LOW


-- QUERY 5:	
SELECT * FROM PRODS ORDER BY ProductKey										-- DEFAULT IS ASCENDING ORDER						 


-- QUERY 6:	HOW TO REPORT TOP 4 PRODUCTS BASED ON ID (KEY) ?
SELECT TOP 4 * FROM PRODS ORDER BY ProductKey								-- DEFAULT IS ASCENDING ORDER						 


-- QUERY 7:	HOW TO REPORT TOP 2 PRODUCTS BASED ON ID (KEY) ?
SELECT TOP 2 * FROM PRODS ORDER BY ProductKey										 					 


-- QUERY 8:	HOW TO REPORT ALL PRODUCTS EXCEPT FIRST 2 BASED ON ID (KEY)?
-- FORMAT:	SELECT <COLUMN-LIST> FROM <TABLE-NAME> ORDER BY <COLUMN-NAME> OFFSET n ROWS
SELECT * FROM PRODS ORDER BY ProductKey OFFSET 2 ROWS 



-- QUERY 9: HOW TO REPORT NUMBER OF ROWS IN A TABLE?
SELECT COUNT(*) FROM PRODS


-- QUERY 10: FROM ABOVE, COLUMN HEADER IS MISSING. WE USE ALIAS. MEANS, A TEMPORARY NAME TO THE COLUMN. 
-- "AS" KEYWORD IS USED TO SPECIFY ALIAS. THIS ALIAS IS A TEMPORARY NAME. VISIBLE ONLY FOR THE SELECT QUERY. 
SELECT COUNT(*) AS ROW_COUNT FROM PRODS

SELECT COUNT(*) AS RWCOUNT FROM PRODS


-- QUERY 11:	HOW TO REPORT MAXIMUM LIST PRICE?
SELECT MAX(ListPrice) FROM PRODS


-- QUERY 12:	HOW TO REPORT MAXIMUM LIST PRICE WITH COLUMN ALIAS?
SELECT MAX(ListPrice) AS MAX_PRICE FROM PRODS


-- QUERY 13:	HOW TO REPORT LIST OF PRODUCTS WITH MAXIMUM PRICE?
SELECT * FROM PRODS WHERE ListPrice = 3578.27


-- SUB QUERY:	A QUERY INSIDE ANOTHER QUERY
-- QUERY 14:	HOW TO REPORT LIST OF PRODUCTS WITH MAXIMUM PRICE?
SELECT * FROM PRODS WHERE ListPrice = (SELECT MAX(ListPrice) FROM PRODS)


-- SUB QUERY:	A QUERY INSIDE ANOTHER QUERY
-- QUERY 15:	HOW TO REPORT LIST OF PRODUCTS WITH MINIMUM PRICE?
SELECT * FROM PRODS WHERE ListPrice = (SELECT MIN(ListPrice) FROM PRODS)


