

-- VERIFY THE TABLES AND RELATIONS USING "DATABASE DIAGRAMS"

------------------------  PHASE 2 REQUIREMENT :: QUERIES & SUB QUERIES --------------		
-- SEND ME YOUR SOLUTIONS (.SQL FILE) FOR BELOW QUERY REQUIREMENTS:

-- 1. CREATE FUNCTION TO GET ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?
-- 2. List all Banks and their Branches with total number of Accounts in each Branch
-- 3. List total number of Customers for each Branch
-- 4. Find all Customer Accounts that does not have any Transaction
-- 5. Rank the Customers for each Bank & Branch based on number of Transactions. 
--   Customer with maximum number of Transaction gets 1 Rank (Position)
-- 6. MONTHLY STATEMENT transactions for a given month for a given customer id
-- 7. LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS
-- 8. LIST OF ALL ZIP CODES WITH MISSING CUSTOMER ADDRESS
-- 9. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS & TYPES WITHOUT ANY TRANSACTIONS
-- 10. LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS





Use BankingDB

------------Verify Data in Account table----------------

Select * from Account.tblaccAccount
Select * from Account.tblaccAccountStatus
Select * from Account.tblaccAccountType

------------Verify Data in Bank table----------------

Select * from BankingDB.BANK.tbladdAddress
Select * from BankingDB.BANK.tblBank
Select * from BankingDB.BANK.tblbrBranch
Select * from BankingDB.BANK.tblbtBranchType
Select * from BankingDB.BANK.tblcstCustomer

------------Verify Data in Transaction table----------------

Select * from BankingDB.TRANSACTIONS.tbltranTransaction
Select * from BankingDB.TRANSACTIONS.tbltranTransactionType

--------------------------------------------------------------------------------------------------------------



-- QUESTION 1. CREATE FUNCTION TO GET ACCOUNT STATEMENT FOR A GIVEN CUSTOMER ?

--------------------------------ANSWER 1------------------------------------------

Create Function FN_Acc_Statement (@customerName Varchar(100))
Returns Table
As
Return(
Select b1.bankDetails as Bank_Name, b3.addCountry as Bank_Location,
  ( b2.cstFirstName +  '  ' + b2.cstLastName + '  ' + b2.CstMiddleName) as Customer_Name,
a2.accTypeDesc as Account_Type,a1.accBalance as Balance,  t1.tranDatetime as Transaction_Date, 
t1.tranDescription as Description, t1.tranTransactionAmount as Amount,
 t2.tranTypeDesc as Transaction_Type

from Bank.tblBank b1 
 join
BANK.tblcstCustomer b2 on b1.bankId = b2.cstAddId_fk 
join
BANK.tbladdAddress b3 on b2.cstAddId_fk  = b3.addId
join
Account.tblaccAccount a1  on  b3.addId =  a1.accTypeCode_fk
join
Account.tblaccAccountType a2 on a1.accTypeCode_fk = a2.accTypeId
join 
TRANSACTIONS.tbltranTransaction t1 on a2.accTypeId  = t1.tranCode_fk 
join
TRANSACTIONS.tbltranTransactionType t2 on t1.tranCode_fk  = t2.tranCodeID

where b2.cstFirstName =  @customerName  OR   b2.CstMiddleName  = @customerName  oR b2.cstLastName = @customerName

)


SELECT * FROM  FN_Acc_Statement ('Nathan')

-- QUESTION 2. List all Banks and their Branches with total number of Accounts in each Branch

-------------------------------ANSWER 2-------------------------------------

	Create View VW_List_All_Banks
	 As
	Select b1.bankDetails as Bank_Name, b2.brBranchName as Branch_Name,
	count( b3.cstId) as Count_Accounts 
		from Bank.tblBank b1 
	full join
	ACCOUNT.tblaccAccount a1 on b1.bankId = a1.accCustomerId_fk
	 full join
	BANK.tblbrBranch b2 on a1.accCustomerId_fk = b2.brBankId_fk
	 full join
	Bank.tblcstCustomer b3  on b1.bankId  = b3.cstId
	Group by b1.bankDetails, b2.brBranchName 

---Display View of Bank List-------------
Select * from VW_List_All_Banks

--Drop View if exists  VW_List_All_Banks


--QUESTION 3. List total number of Customers for each Branch
-------------------------------ANSWER 3-----------------

Select b1.brBranchName as Branch_Name,
	count( a1.accCustomerId_fk) as Total_Customer 
		from  ACCOUNT.tblaccAccount a1
	full join
	BANK.tblbrBranch b1 on a1.accCustomerId_fk = b1.brBankId_fk
	Group by b1.brBranchName 


--QUESTION 4. Find all Customer Accounts that does not have any Transaction

-------------------------------ANSWER 4-----------------

Select b.cstId,  b.cstFirstName as Customer_Accounts 
		from  BANK.tblcstCustomer b
	 join
	TRANSACTIONS.tbltranTransaction t on b.cstId = t.tranCode_fk where b.cstId != t.tranID
	Group by b.cstId, b.cstFirstName


--QUESTION 5. Rank the Customers for each Bank & Branch based on number of Transactions. 
--   Customer with maximum number of Transaction gets 1 Rank (Position)

-------------------------------ANSWER 5-----------------

	WITH countTransaction as
	(
	Select  ROW_NUMBER() over(order by tranID) as count_trans  from
		TRANSACTIONS.tbltranTransaction 
	)
	
	Select  b1.bankDetails as Bank_Name, b2.brBranchName as Branch_Name,
		ct.count_trans as Transaction_Count, rank() over( order by b1.bankDetails, b2.brBranchName) 
	   as rank_Counts 
			from   Bank.tblcstCustomer b3 right join 
			Bank.tblBank b1  on  b3.cstId =  b1.bankId right join
			BANK.tblbrBranch b2  on b1.bankId = b2.brBankId_fk, countTransaction ct		
		group by  
		b1.bankDetails , b2.brBranchName,ct.count_trans order by 
		ct.count_trans desc


--QUESTION  6. MONTHLY STATEMENT transactions for a given month for a given customer id

-------------------------------ANSWER 6-----------------

Create Function FN_Monthly_Statement ( @customerID int, @Month int)
Returns Table
As
Return
(
Select b2.cstId, DATENAME(month,t1.tranDatetime) as MonthName,
( b2.cstFirstName +  '  ' + b2.cstLastName + '  ' + b2.CstMiddleName) as Customer_Name,
 t1.tranDatetime as Dates, tranDescription as Description, t1.tranTransactionAmount as Amount

from Bank.tblBank b1 
  join
BANK.tblcstCustomer b2 on b1.bankId = b2.cstAddId_fk 
  join
BANK.tbladdAddress b3 on b2.cstAddId_fk  = b3.addId
  join
Account.tblaccAccount a1  on  b3.addId =  a1.accTypeCode_fk
  join
Account.tblaccAccountType a2 on a1.accTypeCode_fk = a2.accTypeId
  join 
TRANSACTIONS.tbltranTransaction t1 on a2.accTypeId  = t1.tranCode_fk 
where b2.cstId = @customerID  or t1.tranDatetime = @Month
 group  by  b2.cstId, t1.tranDescription ,t1.tranTransactionAmount, t1.tranDatetime,
 b2.cstFirstName , b2.cstLastName , b2.CstMiddleName 
)


---Report Monthly statement
SELECT * FROM  FN_Monthly_Statement ( 1000,7)

	--Drop function FN_Monthly_Statement

	
---QUESTION 7. LIST OF ALL CUSTOMERS WITH ACCOUNTS, NO TRANSACTIONS

-------------------------------ANSWER 7-----------------
	
	Create Procedure SP_Report_ALL_Customer
		As
		Begin
		Begin Try
		Begin Transaction
		Select b2.cstId, b2.cstFirstName as Customer_Name, t1.tranID
	From
	BANK.tblcstCustomer b2 
	 full join
	TRANSACTIONS.tbltranTransaction t1 on   b2.cstId =  t1.tranCode_fk 
	where t1.tranID IS NULL
 
	 UNION 
	 Select b2.cstId, b2.cstFirstName as Customer_Name, t1.tranID
	From
	BANK.tblcstCustomer b2 
	 full join
	TRANSACTIONS.tbltranTransaction t1 on   b2.cstAddId_fk =  t1.tranCode_fk 
	where t1.tranID IS NULL;
	Commit Transaction
	END TRY
	BEGIN CATCH 
	Print ' Nout Found '
	End CATCH
	 End	


	 	drop  Procedure SP_Report_ALL_Customer
----Display  Customer, no transaction
Exec  SP_Report_ALL_Customer
	

--QUESTION  8. LIST OF ALL ZIP CODES WITH MISSING CUSTOMER ADDRESS

-------------------------------ANSWER 8-----------------
	

		Select b2.addPostCode, b2.addId as AddressID
	From
	BANK.tbladdAddress b2  right join BANK.tblcstCustomer b1 on b2.addId = b1.cstId where 
	b2.addId IS NULL


 
 --QUESTION 9. LIST OF ALL CUSTOMERS WITH ACCOUNTS BASED ON ACCOUNT STATUS & TYPES WITHOUT ANY TRANSACTIONS

-------------------------------ANSWER 9-----------------

	Select b.cstId,a.accStatusDesc, t.tranID
	From
	BANK.tblcstCustomer b
	 full join
	 ACCOUNT.tblaccAccountStatus a on b.cstId =  a.accStatusId
	 full join
	TRANSACTIONS.tbltranTransaction t on   a.accStatusId =  t.tranID
	where t.tranID IS NULL 
	group by a.accStatusDesc,b.cstId, t.tranID

	
--QUESTION  10. LIST OF ALL BANKS BASED ON CUSTOMERS AND TRANSACTION AMOUNTS

-------------------------------ANSWER 10-----------------

Create View  FN_Report_Bank
As
Select b.bankDetails,b2.cstFirstName, t.tranTransactionAmount
	From
	BANK.tblBank b
	  join  BANK.tblcstCustomer b2 on b.bankId = b2.cstId
	 join
	TRANSACTIONS.tbltranTransaction t on   b2.cstId =  t.tranID 
	group by b.bankDetails,b2.cstFirstName, t.tranTransactionAmount

	---Display All Banks and Customer and Transaction Amount
	Select * from FN_Report_Bank



-------------------------------------------------------------




-----------------------BANK_WPORLD DATABASE--------------
-- HOW TO REPORT Total Sum of DEBITS & CREDITS for each Customer. 

CREATE VIEW VW_TRANSACTIONDETAILS 
AS
	SELECT  
	T.transAccountNumber_fk,A.accCustomerId_fk,TT.transTypeDesc, 
	ISNULL(sum(T.transactionAmount),0) AS [Total Transaction Amount]
	FROM 
	Transactions_Info.Transactions T
	INNER JOIN
	Transactions_Info.Transactions_Types TT
	ON
	T.transCode_fk = TT.transCodeID_pk
	LEFT OUTER JOIN
	Account_Info.Account  A 
	ON
	A.accNumber_pk = T.transAccountNumber_fk
	WHERE T.transAccountNumber_fk IS NOT NULL
	GROUP BY T.transAccountNumber_fk,A.accCustomerId_fk,TT.transTypeDesc
GO

SELECT * FROM VW_TRANSACTIONDETAILS

SELECT * FROM VW_TRANSACTIONDETAILS
PIVOT
( sum([Total Transaction Amount]) -- Column Alias Name works in Pivot 
  FOR  transTypeDesc IN (Deposit, Withdrawal)
) as PivotQuery
GO



