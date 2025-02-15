/*
-- Phase 2: Write TSQL Queries for below requirements:

-- 1. CREATE FUNCTION TO GET ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?

-- 2. LIST ALL BANKS AND THEIR BRANCHES WITH TOTAL NUMBER OF ACCOUNTS IN EACH BRANCH

-- 3. LIST TOTAL NUMBER OF CUSTOMERS FOR EACH BRANCH

-- 4. FIND ALL CUSTOMER ACCOUNTS THAT DOES NOT HAVE ANY TRANSACTION

-- 5. RANK THE CUSTOMERS FOR EACH BANK & BRANCH BASED ON NUMBER OF TRANSACTIONS. 
--   CUSTOMER WITH MAXIMUM NUMBER OF TRANSACTION GETS 1 RANK (POSITION)	 & SO ON.. 

-- 6. REPORT TRANSACTION STATEMENTS FOR A GIVEN MONTH AND FOR A GIVEN CUSTOMER ID

-- 7. LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS
-- 8. LIST OF ALL ZIP CODES WITH MISSING CUSTOMER ADDRESS
-- 9. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS & TYPES WITHOUT ANY TRANSACTIONS
-- 10. LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS

*/

USE BankingDB
GO


-- 1. CREATE FUNCTION TO REPORT ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?
CREATE FUNCTION FN_ACC_STATEMENT ( @CSTID BIGINT )
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM ACCOUNT.tblaccAccount		-- JOIN OF MULTIPLE TABLES ACCROSS MULTIPLE SCHEMAS, BASED ON RELATION
	INNER JOIN
	bank.tblcstCustomer
	on accCustomerId_fk=cstId 
	WHERE 
	cstId=@CSTID
)
 
 GO
SELECT * FROM FN_ACC_STATEMENT(1001)


-- FOR DETAILED STATEMENT:
SELECT * FROM FN_ACC_STATEMENT(1001)   AS F
JOIN 
[TRANSACTIONS].[tbltranTransaction]	   AS T
ON
F.accNumber = T.tranAccountNumber_fk



SELECT F.cstId, F.cstFirstName + '  ' + F.CstMiddleName +  '  ' + F.cstLastName AS FULLNAME,
F.cstGender, F.accNumber, T.tranCode, T.tranDatetime, T.tranTransactionAmount, T.RunningBalance
FROM FN_ACC_STATEMENT(1001)   AS F
JOIN 
[TRANSACTIONS].[tbltranTransaction]	   AS T
ON
F.accNumber = T.tranAccountNumber_fk


	   	  

--  2. List all Banks and their Branches with total number of Accounts in each Branch
select bankId, bankDetails, brBranchTypeCode_fk,
count(accNumber) as total_account
from 
bank.tblBank
right outer join
bank.tblbrBranch
on bankId=brBankId_fk 
right outer join
bank.tblcstCustomer
on brID=cstBranchId_fk 
right outer join
account.tblaccAccount
on accCustomerId_fk=cstId  
group by brBranchTypeCode_fk, bankId, bankDetails




-- 3. List total number of Customers for each Branch
select 
brid, brBranchName, count(cstid) as total_cust from
bank.tblbrBranch 
LEFT OUTER join		-- INCLUDES ALL SUCH BRANCHES WITH CUSTOMERS AND WITHOUT CUSTOMERS AS WELL
bank.tblcstCustomer 
on
brID=cstBranchid_fk
group by brid, brBranchName






-- 4. Find all Customer Accounts that does not have any Transaction
-- Means, we need to identify missing data
-- For this, we can use OUTER JOIN
SELECT * FROM bank.tblcstCustomer AS C 
LEFT OUTER JOIN
ACCOUNT.tblaccAccount AS A
on A.accCustomerId_fk=C.cstId 
LEFT OUTER JOIN 
transactions.tbltranTransaction  AS T
on A.accNumber=T.tranAccountNumber_fk
where T.tranID is null


SELECT C.cstId, C.cstFirstName + '   ' + C.cstLastName AS CUST_NAME, 
A.accNumber, A.accTypeCode_fk, T.RunningBalance, 
convert(int, isnull(T.tranTransactionAmount, 0)) AS TransactionAmount
FROM bank.tblcstCustomer AS C 
left outer JOIN
ACCOUNT.tblaccAccount AS A
on A.accCustomerId_fk=C.cstId 
LEFT OUTER JOIN transactions.tbltranTransaction  AS T
on A.accNumber=T.tranAccountNumber_fk
where tranID is null


SELECT C.cstId, C.cstFirstName + '   ' + C.cstLastName AS CUST_NAME, 
A.accNumber, A.accTypeCode_fk, CONVERT(INT, ISNULL(T.RunningBalance, 0)) AS RunningBal, 
convert(int, isnull(T.tranTransactionAmount, 0)) AS TransactionAmount
FROM bank.tblcstCustomer AS C 
left outer JOIN
ACCOUNT.tblaccAccount AS A
on A.accCustomerId_fk=C.cstId 
LEFT OUTER JOIN transactions.tbltranTransaction  AS T
on A.accNumber=T.tranAccountNumber_fk
where tranID is null


-- coalesce


--5. Rank the Customers for each Bank & Branch based on number of Transactions. 
--   Customers with maximum number of Transactions gets 1 Rank (Position)

SELECT 	* FROM TRANSACTIONS.tbltranTransaction AS T
LEFT OUTER JOIN
ACCOUNT.tblaccAccount AS A
ON
T.tranAccountNumber_fk = A.accNumber
LEFT OUTER JOIN
BANK.tblcstCustomer AS C
ON C.cstId = accCustomerId_fk
LEFT OUTER JOIN
BANK.tblbrBranch AS BR
ON BR.brID = C.cstBranchId_fk
LEFT OUTER JOIN
BANK.tblBank AS B
ON B.bankId = BR.brBankId_fk   
GO


-- ACTUAL SOLUTION V1:
SELECT 
C.cstId, C.cstFirstName +' '+ C.cstLastName as CustName, 
B.BankDetails, BR.brBranchName, count(T.tranID) AS No_of_Transactions 
FROM TRANSACTIONS.tbltranTransaction AS T
LEFT OUTER JOIN
ACCOUNT.tblaccAccount AS A
ON
T.tranAccountNumber_fk = A.accNumber
LEFT OUTER JOIN
BANK.tblcstCustomer AS C
ON C.cstId = accCustomerId_fk
LEFT OUTER JOIN
BANK.tblbrBranch AS BR
ON BR.brID = C.cstBranchId_fk
LEFT OUTER JOIN
BANK.tblBank AS B
ON B.bankId = BR.brBankId_fk
GROUP BY C.cstId,C.cstFirstName + ' ' +  C.cstLastName,B.bankDetails, BR.brBranchName
ORDER BY No_of_Transactions	 DESC


-- ACTUAL SOLUTION V2:
SELECT 
C.cstId, C.cstFirstName +' '+ C.cstLastName as CustName, 
B.BankDetails, BR.brBranchName, count(T.tranID) AS No_of_Transactions, 
DENSE_RANK() OVER(ORDER BY count(T.tranID) DESC) AS Position
FROM TRANSACTIONS.tbltranTransaction AS T
LEFT OUTER JOIN
ACCOUNT.tblaccAccount AS A
ON
T.tranAccountNumber_fk = A.accNumber
LEFT OUTER JOIN
BANK.tblcstCustomer AS C
ON C.cstId = accCustomerId_fk
LEFT OUTER JOIN
BANK.tblbrBranch AS BR
ON BR.brID = C.cstBranchId_fk
LEFT OUTER JOIN
BANK.tblBank AS B
ON B.bankId = BR.brBankId_fk
GROUP BY C.cstId,C.cstFirstName + ' ' +  C.cstLastName,B.bankDetails, BR.brBranchName


-- ACTUAL SOLUTION V3:
SELECT 
ROW_NUMBER() OVER (ORDER BY  cstId) AS SerialNumber,
C.cstId, C.cstFirstName +' '+ C.cstLastName as CustName, 
B.BankDetails, BR.brBranchName, count(T.tranID) AS No_of_Transactions, 
DENSE_RANK() OVER(ORDER BY count(T.tranID) DESC) AS Position
FROM TRANSACTIONS.tbltranTransaction AS T
LEFT OUTER JOIN
ACCOUNT.tblaccAccount AS A
ON
T.tranAccountNumber_fk = A.accNumber
LEFT OUTER JOIN
BANK.tblcstCustomer AS C
ON C.cstId = accCustomerId_fk
LEFT OUTER JOIN
BANK.tblbrBranch AS BR
ON BR.brID = C.cstBranchId_fk
LEFT OUTER JOIN
BANK.tblBank AS B
ON B.bankId = BR.brBankId_fk
GROUP BY C.cstId,C.cstFirstName + ' ' +  C.cstLastName,B.bankDetails, BR.brBranchName



-- 6. REPORT TRANSACTION STATEMENTS FOR A GIVEN MONTH AND FOR A GIVEN CUSTOMER ID
CREATE PROCEDURE spReportTxnDetails (@customerid int, @month varchar(10))
AS
SELECT T.* FROM BANK.tblcstCustomer AS C
INNER JOIN							-- HERE, WE REPORT MATCHING DATA
ACCOUNT.tblaccAccount AS A
ON accCustomerId_fk=cstId
LEFT OUTER JOIN						-- HERE, WE REPORT MATCHING AND MISSING DATA
TRANSACTIONS.tbltranTransaction AS T
ON A.accNumber=T.tranAccountNumber_fk  
WHERE
C.cstId = @customerid  AND 	DATEPART(MONTH, T.tranDatetime) = 	@month


EXEC   spReportTxnDetails  1000,  'September'



-- 7. LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS
SELECT C.* FROM BANK.tblcstCustomer AS C
INNER JOIN							-- HERE, WE REPORT MATCHING DATA
ACCOUNT.tblaccAccount
ON accCustomerId_fk=cstId
LEFT OUTER JOIN						-- HERE, WE REPORT MATCHING AND MISSING DATA
TRANSACTIONS.tbltranTransaction
ON accNumber=tranAccountNumber_fk
WHERE tranAccountNumber_fk IS NULL	-- HERE, WE FILTER FOR ONLY MISSING DATA



-- 8. LIST OF ALL ZIP CODES WITH MISSING CUSTOMER ADDRESS
SELECT A.addPostCode FROM BANK.tblcstCustomer AS C
RIGHT OUTER JOIN Bank.tbladdAddress  AS A 
ON 
A.addId = C.cstAddId_fk 


-- 9. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS & TYPES WITHOUT ANY TRANSACTIONS
SELECT 
C.cstId, C.cstFirstName, C.cstLastName, 
A.accNumber, ACS.accStatusDesc,ACT.accTypeDesc,
ISNULL(CONVERT(VARCHAR,T.tranAccountNumber_fk),'No Transactions') AS 'TRANSACTION ACC NUMBER'
FROM ACCOUNT.tblaccAccount AS A
LEFT OUTER JOIN
TRANSACTIONS.tbltranTransaction AS T
ON
A.accNumber = T.tranAccountNumber_fk
INNER JOIN
BANK.tblcstCustomer AS C
ON A.accCustomerId_fk = C.cstId
INNER JOIN
ACCOUNT.tblaccAccountStatus AS ACS
ON  A.accStatusCode_fk = ACS.accStatusId
INNER JOIN
ACCOUNT.tblaccAccountType AS ACT
ON A.accTypeCode_fk = ACT.accTypeId
WHERE T.tranID IS NULL
GO

-- 10. LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS
SELECT 
cstId, cstFirstName, cstLastName,bankDetails, brBranchName, accNumber, 
ISNULL(CONVERT(VARCHAR,tranTransactionAmount),'No Transactions') AS "Transaction Amount"
FROM bank.tblBank 
LEFT OUTER  JOIN
bank.tblbrBranch
on bankId=brBankId_fk
LEFT JOIN
bank.tblcstCustomer 
ON brID=cstBranchId_fk 
LEFT JOIN
account.tblaccAccount
on accCustomerId_fk=cstId
LEFT OUTER JOIN
TRANSACTIONS.tbltranTransaction
ON accNumber=tranAccountNumber_fk
WHERE cstId IS NOT NULL AND accNumber IS NOT NULL
ORDER BY cstId, tranTransactionAmount



 
 
-- HOW TO REPORT Total Sum of DEBITS & CREDITS for each Customer. 
CREATE VIEW VW_TRANSACTIONDETAILS 
AS
	SELECT  
	T.tranAccountNumber_fk,A.accCustomerId_fk,TT.tranTypeDesc, 
	ISNULL(sum(T.tranTransactionAmount),0) AS [Total Transaction Amount]
	FROM TRANSACTIONS.tbltranTransaction AS T
	INNER JOIN
	TRANSACTIONS.tbltranTransactionType AS TT
	ON
	T.tranCode_fk = TT.tranCodeID
	LEFT OUTER JOIN
	ACCOUNT.tblaccAccount AS A
	ON
	A.accNumber = T.tranAccountNumber_fk
	WHERE T.tranAccountNumber_fk IS NOT NULL
	GROUP BY T.tranAccountNumber_fk,A.accCustomerId_fk,TT.tranTypeDesc
GO


SELECT * FROM VW_TRANSACTIONDETAILS


SELECT * FROM VW_TRANSACTIONDETAILS
PIVOT
( sum([Total Transaction Amount]) -- Column Alias Name works in Pivot 
  FOR  tranTypeDesc IN (Deposit, Withdrawal)
) as PivotQuery
GO

   
/*
PHASE 3  OF THE BANKING PROJECT FOR SQL SERVER T-SQL DEVELOPERS:	 
				HOW TO INSERT DATA INTO ABOVE TABLES WITH BELOW CONDITIONS :
								* CONDITIONAL & DYNAMIC
								* AUTOMATED TRANSACTION BEHAVIOUR USING TRIGGERS		

				FOR THIS PHASE 3, PLEASE PRACTICE VIEWS, TRIGGERS, TRANSACTIONS WITH PROCEDURES
					WE CANNOT INSERT DATA INTO A VIEW IF THE VIEW IS BUILT ON MULTIPLE BASE TABLES.
					SOLUTION :  DEFINE A TRIGER ON THE VIEW
								THEN DEFINE AN SP TO INSERT DATA INTO THE VIEW USING TRIGGER
								
		IDENTIFY READ ONLY TABLES. TREAT THEM AS MASTER TABLES. DO NOT MANUPULATE THE DATA INSIDE THOSE TABLES.  EX: ACCOUNT_TYPE
		FOR REMAINING TABLES:  IDENTIFY THE DEPENDANCIES AND INSERT DATA INTO ALL SUCH DEPENDANT TABLES IN A SINGLE TRANSACTION.
	
		YOU SHALL PLAN YOUR SOLUTION FIRST, MAIL ME.  I SHALL VALIDATE AND THEN YOU SHALL IMPLEMENT IT.
*/																																	
		



	











