			--PHASE 2
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
	USE BANK_WORLD_DB
	----VERIFY TABLE------------
		 Select * from Account_Info.Account_Types
		Select * from Account_Info.Account_Statue
		Select * from Account_Info.Account
		---------------------------------
		Select * from Bank_Info.Banks
		Select * from Bank_Info.Addresses
		Select * from Bank_Info.Branches
		Select * from Bank_Info.BranchTypes
		Select * from Bank_Info.Customers
		-------------------------------------
		SELECT * from Transactions_Info.Transactions_Types
		SELECT * from Transactions_Info.Transactions

		---------------------------------
		-- QUESTION 1. CREATE FUNCTION TO GET ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?

	--------------------------------ANSWER 1------------------------------------------


		-- 1. CREATE FUNCTION TO REPORT ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?
	CREATE FUNCTION FN_ACCOUNT_STATEMENT ( @CustomerID BIGINT )
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT * FROM Account_Info.Account a	-- JOIN OF MULTIPLE TABLES ACCROSS MULTIPLE SCHEMAS, BASED ON RELATION
		INNER JOIN
		Bank_Info.Customers c
		ON  a.accCustomerId_fk = c.CustomerID_pk
		WHERE 
		c.CustomerID_pk = @CustomerID
	)
	 SELECT * FROM FN_ACCOUNT_STATEMENT(235)
	----ADD TRASACTION DETAIL AS WELL A
	 SELECT fn.customerID_pk, fn.customerFirstName + ' ' + fn.customerMiddleName + ' ' + fn.customerLastName as FULLNAME,
	 ts.transID_pk,ts.transAccountNumber_fk,ts.transactionAmount,ts.transMerchant, ts.transDescription
	 FROM
	 FN_ACCOUNT_STATEMENT(235) AS fn
	JOIN 
	Transactions_Info.Transactions ts
	ON 
	fn.accNumber_pk = ts.transAccountNumber_fk



	--QUESTION 2. List all Banks and their Branches with total number of Accounts in each Branch

	-------------------------------ANSWER 2-------------------------------------



	Create View VW_List_All_Banks
		 As
		Select BankID_pk, Bank_Details as Bank_Name, brBranchTypeID_fk,
		count( accNumber_pk) as Count_Accounts 
			from
		Bank_Info.Banks 
		right join
		Bank_Info.Branches   on BankID_pk = brBankID_fk
		 right join 
		Bank_Info.Customers     on brBankID_fk = customerBranchID_fk
		 right join
		Account_Info.Account   on customerBranchID_fk  = accCustomerId_fk
		Group by  BankID_pk, Bank_Details, brBranchTypeID_fk


		Select * from VW_List_All_Banks


		--QUESTION 3. List total number of Customers for each Branch
	-------------------------------ANSWER 3-----------------

	Select brBranchID_pk, brBranchName, count(customerID_pk) as Total_Customer
	from
	Bank_Info.Branches  
	LEFT  join		
	Bank_Info.Customers
	ON
	brBranchID_pk =customerBranchID_fk
	group by brBranchID_pk, brBranchName



	--QUESTION 4. Find all Customer Accounts that does not have any Transaction

	-------------------------------ANSWER 4-----------------


	SELECT customerID_pk, customerFirstName + ' ' + customerMiddleName + ' ' + customerLastName as FULLNAME,
	accNumber_pk, a.accTypeCode_fk,
	convert(int, isnull(t.transactionAmount, 0)) AS Transaction_Count
	FROM 
	Bank_Info.Customers c 
	left JOIN
	Account_Info.Account a
	on 
	a.accCustomerId_fk=  c.CustomerID_pk
	LEFT JOIN 
	Transactions_Info.Transactions t
	on 
	a.accNumber_pk = t.transAccountNumber_fk
	where transID_pk is null


	--QUESTION 5. Rank the Customers for each Bank & Branch based on number of Transactions. 
	--   Customer with maximum number of Transaction gets 1 Rank (Position)

		-------------------------------ANSWER 5-----------------
		CREATE VIEW FN_RANK_CUSTOMER
		AS
		SELECT 
	ROW_NUMBER() OVER (ORDER BY  customerID_pk) AS uniqueNumber,
	c.customerID_pk,c.customerFirstName,ba.Bank_Details, br.brBranchName, count(t.transID_pk) AS No_of_Transactions, 
	DENSE_RANK() OVER(ORDER BY count(t.transID_pk) DESC) AS Ranking
	FROM 	Transactions_Info.Transactions t
	LEFT OUTER JOIN
		Account_Info.Account a
	ON
	t.transAccountNumber_fk = a.accNumber_pk
	LEFT OUTER JOIN
		Bank_Info.Customers c 
	ON c.customerID_pk = a.accCustomerId_fk
	LEFT OUTER JOIN
		Bank_Info.Branches br
	ON brBranchID_pk =customerBranchID_fk
	LEFT OUTER JOIN
	Bank_Info.Banks  ba
	ON ba.BankID_pk = br.brBankID_fk
	GROUP BY c.customerID_pk,c.customerFirstName,ba.Bank_Details, br.brBranchName

	Select * from FN_RANK_CUSTOMER


	--QUESTION  6. MONTHLY STATEMENT transactions for a given month for a given customer id

	-------------------------------ANSWER 6-----------------

	CREATE PROCEDURE SP_Monthly_Statement (@customerid int, @month varchar(10))
	AS
	SELECT T.* FROM 
	Bank_Info.Customers  AS C
	INNER JOIN							

		Account_Info.Account  AS A
	ON 
	A.accCustomerId_fk= C.customerID_pk
	LEFT OUTER JOIN						
	Transactions_Info.Transactions T
	ON A.accNumber_pk =  T.transAccountNumber_fk  
	WHERE
	C.customerID_pk = @customerid  AND 	DATEPART(MONTH, T.transDatetime) = 	@month


	EXEC   SP_Monthly_Statement  245, 8




	---QUESTION 7. LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS

	-------------------------------ANSWER 7-----------------
		CREATE VIEW FN_CUST_NO_TRANSACTION
		AS
		SELECT C.* FROM 
		Bank_Info.Customers  AS C
	INNER JOIN							
		Account_Info.Account  AS A
		ON
	A.accCustomerId_fk= C.customerID_pk
	LEFT OUTER JOIN						
	Transactions_Info.Transactions T
	ON A.accNumber_pk =  T.transAccountNumber_fk  
	WHERE transAccountNumber_fk IS NULL

	--VERIFY VIEW
	SELECT * FROM FN_CUST_NO_TRANSACTION





	--QUESTION  8. LIST OF ALL ZIP CODES WITH MISSING CUSTOMER ADDRESS

	-------------------------------ANSWER 8-----------------
	
		SELECT A.Zip_Postcode FROM
		Bank_Info.Customers AS C
	RIGHT OUTER JOIN Bank_Info.Addresses  AS A 
	ON 
	A.AddressID_pk = C.customerAddressID_fk 




	--QUESTION 9. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS & TYPES WITHOUT ANY TRANSACTIONS

	-------------------------------ANSWER 9-----------------

	SELECT 
	C.customerID_pk, C.customerFirstName , C.customerLastName, 
	A.accNumber_pk, ACS.accStatusDesc,ACT.accTypeDesc,
	ISNULL(CONVERT(varchar(49),T.transAccountNumber_fk),'NO TRANSACTION') AS 'TRANSACTION_Count'
	FROM 
	Account_Info.Account  AS A
	LEFT  JOIN
	Transactions_Info.Transactions  AS T
	ON
	A.accNumber_pk = T.transAccountNumber_fk
	JOIN
	Bank_Info.Customers AS C
	ON
	A.accCustomerId_fk = C.customerID_pk
	JOIN
	Account_Info.Account_Statue AS ACS
	ON  A.accStatusCode_fk = ACS.accStatusId_pk
	JOIN
	Account_Info.Account_Types AS ACT
	ON A.accTypeCode_fk = ACT.accTypeId_pk
	WHERE T.transID_pk IS NULL
	GO




	--QUESTION  10. LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS

	-------------------------------ANSWER 10-----------------

	SELECT 
	customerID_pk, customerFirstName , customerLastName,bank_Details, brBranchName, accNumber_pk, 
	ISNULL(CONVERT(VARCHAR,transactionAmount),'No Transactions') AS "Transaction Amount"
	FROM 	
	Bank_Info.Banks  
	LEFT OUTER  JOIN
	Bank_Info.Branches   
	ON BankID_pk = brBankID_fk
	LEFT JOIN
	Bank_Info.Customers 
	ON brBankID_fk = customerID_pk   
	LEFT JOIN
	Account_Info.Account  
	ON 	
	accCustomerId_fk = customerID_pk
	LEFT OUTER JOIN
	Transactions_Info.Transactions T
	ON accNumber_pk =  transAccountNumber_fk  
	WHERE customerID_pk IS NOT NULL AND accNumber_pk IS NOT NULL
	ORDER BY customerID_pk, transactionAmount





	--- I USE EXCEL TO TEST THE VIEWS, I SENT TO SCREENSHOT AS WELL
