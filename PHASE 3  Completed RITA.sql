

	-----------PHASE 3  OF THE BANKING PROJECT FOR SQL SERVER T-SQL DEVELOPERS--------------------

	--REQUIREMENT:
		--HOW TO INSERT DATA INTO ABOVE TABLES WITH BELOW CONDITIONS :
		--	* CONDITIONAL & DYNAMIC
		--	* AUTOMATED TRANSACTION BEHAVIOUR USING TRIGGERS		
	-----------------------------------------------


	USE BANK_WORLD_DB

--***********************************ANSWER 1 *************************************************************************************************
	---------- Banks AND Branches AS SINGLE TRANSACTION
	----CREATE VIEW WITH JOIN IN IT (JOIN OF TWO TABLE TABLE)

	CREATE VIEW  VW_BankandBranch_Report
	As
	Select  bs.Bank_Details, ba.brAddressID_fk, ba.brBankID_fk ,ba.brBranchTypeID_fk,
	ba.brBranchName,ba.brBranchPhone1,ba.brBranchPhone2, ba.brBranchFax, ba.brBranchemail  
	from Bank_Info.Banks bs
	JOIN
	Bank_Info.Branches ba 
	On
	bs.BankID_pk = ba.brBranchID_pk

	---------
	Select * from VW_BankandBranch_Report


	----------TRIGGER------------
	--CREATE UPDATAVIEW THAT WILL ALSO ENABLE LOGICAL  DATA DISTRBUTION

	CREATE TRIGGER BankTrigger1 
	ON VW_BankandBranch_Report
	INSTEAD OF INSERT
	AS
	BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @BankDetails VARCHAR(100),  @brAddressID_fk BIGINT,@brBankID_fk BIGINT,@brBranchTypeID_fk BIGINT,
	@brBranchName VARCHAR(100),@brBranchPhone1 VARCHAR(20),
	@brBranchPhone2 VARCHAR(20),@brBranchFax VARCHAR(20),@brBranchemail VARCHAR(50)

	---map the variable to apporpriate columns
	SELECT @BankDetails = Bank_Details FROM INSERTED
	SELECT @brAddressID_fk = brAddressID_fk FROM INSERTED
	SELECT @brBankID_fk = brBankID_fk FROM INSERTED
	SELECT @brBranchTypeID_fk =brBranchTypeID_fk FROM INSERTED
	SELECT @brBranchName = brBranchName FROM INSERTED
	SELECT @brBranchPhone1 = brBranchPhone1 FROM INSERTED
	SELECT @brBranchPhone2 = brBranchPhone2    FROM INSERTED
	SELECT @brBranchFax =  brBranchFax FROM INSERTED
	SELECT @brBranchemail = brBranchemail FROM INSERTED


		 --insert the variables into columns, column list  used as well, 
		INSERT INTO Bank_Info.Banks(Bank_Details)
				VALUES
				(@BankDetails)
		INSERT INTO BANK_Info.Branches(brAddressID_fk,brBankID_fk,brBranchTypeID_fk,brBranchName,brBranchPhone1,brBranchPhone2,brBranchFax,brBranchemail) 
				VALUES 
		(@brAddressID_fk,@brBankID_fk ,@brBranchTypeID_fk, @brBranchName,@brBranchPhone1, @brBranchPhone2,@brBranchFax,@brBranchemail)

		--save transaction
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	END CATCH 
	END	

	--------------------------------------
	-----USE PROCEDURE TO INSERT DATA FOR FLEXIBLILITY

	CREATE  PROCEDURE SP_BankandBranch_Report (@BankDetails VARCHAR(100), @brAddressID_fk BIGINT,
	@brBankID_fk BIGINT,@brBranchTypeID_fk BIGINT,
	@brBranchName VARCHAR(100),@brBranchPhone1 VARCHAR(20),
	@brBranchPhone2 VARCHAR(20),@brBranchFax VARCHAR(20),@brBranchemail VARCHAR(50))
	AS
	BEGIN
	IF @BankDetails = 'Deutsche Bank Filiale'
	  INSERT INTO VW_BankandBranch_Report  VALUES  (@BankDetails, @brAddressID_fk,@brBankID_fk ,@brBranchTypeID_fk, 
					@brBranchName,@brBranchPhone1, @brBranchPhone2,@brBranchFax,@brBranchemail)

	ELSE
	PRINT 'SOMETHING WENT WRONG: COLUMN NOT FOUND'
	END

	-------------------
	---------EXEC PROCEDURE-------------
	EXEC SP_BankandBranch_Report  'Deutsche Bank Filiale', 305,305,235,'Kinplat Branch', '+49 1098 30090' ,' ','4560 7890', 'inboundcontact@kinp.de'
	
		-------VERIFY TABLE------------
			Select * from Bank_Info.Banks
			Select * from Bank_Info.Branches
 





--************************************ANSWER 2 *********************************************************************************************************
	---------- Customer AND Branches AND Acount Type  AS SINGLE TRANSACTION

	
	----------MARK BRANCH TYPE AND BRANCH TYPE AS READ ONLY

		ALTER TABLE Bank_Info.BranchTypes  WITH NOCHECK ADD CONSTRAINT chk_read_only CHECK( 1 = 0 )
	
		----------MARK BRANCH TYPE AND ACCOUNT TYPE AS READ ONLY

		ALTER TABLE Account_Info.Account_Types  WITH NOCHECK ADD CONSTRAINT chk_read_only CHECK( 1 = 0 )



	---- ---CREATE VIEW  WITH JOIN IN IT (JOIN OF THREE TABLE TABLE) 

	CREATE VIEW  VW_BankandCustomer_Report
	As
	Select customerAddressID_fk,customerBranchID_fk,customerFirstName,customerLastName,
			customerMiddleName,customerDOB, customerSince,customerPhone1,customerPhone2,customerFax,customerGender,
			customerEmail,
			branchTypeCode, branchTypeDesc,
			 accTypeCode,accTypeDesc
	from Bank_Info.Customers c
	JOIN
	Bank_Info.BranchTypes b
	On
	c.customerBranchID_fk = b.BranchTypeID_pk 
	JOIN
	Account_Info.Account_Types a 
	On 
	a.accTypeId_pk = b.BranchTypeID_pk



	---------
	Select * from VW_BankandCustomer_Report

---------------------TRIGGER-------------------------
	--CREATE UPDATAVIEW THAT WILL ALSO ENABLE LOGICAL  DATA DISTRBUTION
	CREATE TRIGGER BankTrigger2 
	ON VW_BankandCustomer_Report
	INSTEAD OF INSERT
	AS
	BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @customerAddressID_fk BIGINT,@customerBranchID_fk BIGINT,@customerFirstName	 VARCHAR(50),@customerLastName VARCHAR(50),
			@customerMiddleName	 VARCHAR(50),@customerDOB	DATE, @customerSince	DATETIME, @customerPhone1 VARCHAR(20),
			@customerPhone2	 VARCHAR(20),@customerFax VARCHAR(20),@customerGender	  VARCHAR(10), @customerEmail VARCHAR(50),
			@branchTypeCode	VARCHAR(20),@branchTypeDesc	VARCHAR(100),
			@accTypeCode VARCHAR(10),@accTypeDesc VARCHAR(100)
		
	---map the variable to apporpriate columns
	SELECT @customerAddressID_fk = customerAddressID_fk FROM INSERTED
	SELECT @customerBranchID_fk = customerBranchID_fk FROM INSERTED
	SELECT @customerFirstName = customerFirstName  FROM INSERTED
	SELECT @customerLastName  = customerLastName FROM INSERTED
	SELECT @customerMiddleName = customerMiddleName FROM INSERTED
	SELECT @customerDOB = customerDOB FROM INSERTED
	SELECT @customerSince = customerSince    FROM INSERTED
	SELECT @customerPhone1 =  customerPhone1 FROM INSERTED
	SELECT @customerPhone2 = customerPhone2 FROM INSERTED
	SELECT @customerFax = customerFax FROM INSERTED
	SELECT @customerGender = customerGender    FROM INSERTED
	SELECT @customerEmail =  customerEmail FROM INSERTED

	SELECT @branchTypeCode = branchTypeCode FROM INSERTED
	SELECT @branchTypeDesc = branchTypeDesc    FROM INSERTED

	SELECT @accTypeCode = customerPhone2 FROM INSERTED
	SELECT @accTypeDesc = customerPhone2 FROM INSERTED

		 --insert the variables into columns, column list  used as well, 
		INSERT INTO BANK_Info.Customers (customerAddressID_fk,customerBranchID_fk,customerFirstName,customerLastName,customerMiddleName,
		customerDOB,customerSince,customerPhone1,customerPhone2,customerFax	,customerGender, customerEmail)
		VALUES 
		( @customerAddressID_fk,@customerBranchID_fk,@customerFirstName	,@customerLastName,
			@customerMiddleName,@customerDOB, @customerSince, @customerPhone1,
			@customerPhone2,@customerFax,@customerGender, @customerEmail)
		
			INSERT INTO BANK_INFO.BranchTypes (branchTypeCode,branchTypeDesc) 
			VALUES
			(@branchTypeCode,@branchTypeDesc)

				INSERT INTO Account_Info.Account_Types (accTypeCode,accTypeDesc)
				VALUES
				(@accTypeCode,@accTypeDesc)

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	END CATCH 
	END	

	--------------------------------------
	-----CREATE PROCEDURE FOR INSERTION

	CREATE  PROCEDURE SP_BankandCustomer_Report (
	 @customerAddressID_fk BIGINT,@customerBranchID_fk BIGINT,@customerFirstName	 VARCHAR(50),@customerLastName VARCHAR(50),
			@customerMiddleName	 VARCHAR(50),@customerDOB	DATE, @customerSince	DATETIME, @customerPhone1 VARCHAR(20),
			@customerPhone2	 VARCHAR(20),@customerFax VARCHAR(20),@customerGender	  VARCHAR(10), @customerEmail VARCHAR(50),
			@branchTypeCode	VARCHAR(20),@branchTypeDesc	VARCHAR(100),
			@accTypeCode VARCHAR(10),@accTypeDesc VARCHAR(100))
	AS
	BEGIN
	IF( @branchTypeDesc LIKE 'Large Urban' AND  @accTypeDesc LIKE 'Saving' AND  @customerDOB <= '2020-Jan-01')

	  INSERT INTO VW_BankandCustomer_Report  VALUES  (
		@customerAddressID_fk,@customerBranchID_fk,@customerFirstName,@customerLastName,
			@customerMiddleName,@customerDOB, @customerSince, @customerPhone1,
			@customerPhone2,@customerFax,@customerGender, @customerEmail,
					@branchTypeCode,@branchTypeDesc,
					@accTypeCode,@accTypeDesc )

	ELSE
	PRINT 'SOMETHING WENT WRONG: COLUMN NOT FOUND'
	END
	-------------------
	---------EXEC PROCEDURE------------------
	EXEC SP_BankandCustomer_Report  
		NULL,265,'Van','Vicker','Varry','2003-Aug-25','2015','+44 8243 337623','','','Male','vaeke@yahoo.com',
		'LU','Large Urban','SAV','Saving'
	
		---VERIFY TABLE-------------
		Select * from Bank_Info.Customers
		Select * from Bank_Info.BranchTypes
		Select * from Account_Info.Account_Types



--***********************************************ANSWER 3 *********************************************************************************
		-----------Address AND Account  AS SINGLE TRANSACTION

	
	---- ---CREATE VIEW  WITH JOIN IN IT (JOIN OF THREE TABLE TABLE) 

		CREATE VIEW  VW_AddressandAccount_Report
		As
		Select addLine1, addLine2 ,Town_City,Zip_Postcode,State_Province,Country, 
			accStatusCode_fk,accTypeCode_fk,accCustomerId_fk, accBalance   
	from
	Bank_Info.Addresses s
	JOIN
	Account_Info.Account a on s.AddressID_pk = a.accCustomerId_fk

	---------
	Select * from VW_AddressandAccount_Report


	----------------------TRIGGER-------------------------
	--CREATE UPDATAVIEW THAT WILL ALSO ENABLE LOGICAL  DATA DISTRBUTION

	CREATE TRIGGER BankTrigger3 
	ON VW_AddressandAccount_Report
	INSTEAD OF INSERT
	AS
	BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	DECLARE  @addLine1  Varchar(100),@addLine2 Varchar(100) ,@Town_City  Varchar(100), @Zip_Postcode Varchar(100),
		 @State_Province Varchar(100) ,@Country Varchar(100)   
	DECLARE @accStatusCode_fk BIGINT, @accTypeCode_fk BIGINT,@accCustomerId_fk BIGINT,@accBalance DECIMAL(23,2)

	---map the variable to apporpriate columns
	SELECT @addLine1 = addLine1 FROM INSERTED
	SELECT @addLine2 = addLine2 FROM INSERTED
	SELECT @Town_City = Town_City FROM INSERTED
	SELECT @Zip_Postcode = Zip_Postcode FROM INSERTED
	SELECT @State_Province = State_Province FROM INSERTED
	SELECT @Country = Country FROM INSERTED
	SELECT @accStatusCode_fk = accStatusCode_fk    FROM INSERTED
	SELECT @accTypeCode_fk =  accTypeCode_fk FROM INSERTED
	SELECT @accCustomerId_fk = accCustomerId_fk FROM INSERTED
	SELECT @accBalance = accBalance FROM INSERTED


		 --INSERT VARIABLES INTO THE TABLE
		INSERT INTO Bank_Info.Addresses(addLine1, addLine2 ,Town_City,Zip_Postcode,State_Province,Country)
				VALUES
				( @addLine1,@addLine2,@Town_City, @Zip_Postcode,@State_Province,@Country )

			INSERT INTO Account_Info.Account (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) 
				VALUES 
				(@accStatusCode_fk, @accTypeCode_fk,@accCustomerId_fk,@accBalance)

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	END CATCH 
	END	


	--------------------------------------
	-----CREATE PROCEDURE TO INSERT DATA FOR FLEXIBLILITY

	CREATE  PROCEDURE SP_AddressandAccount_Report (
		 @addLine1  Varchar(100),@addLine2 Varchar(100) ,@Town_City  Varchar(100), @Zip_Postcode Varchar(100),
		 @State_Province Varchar(100) ,@Country Varchar(100),   
		 @accStatusCode_fk BIGINT, @accTypeCode_fk BIGINT,@accCustomerId_fk BIGINT,@accBalance DECIMAL(23,2))
		 AS
	BEGIN
		IF @Country = 'Sweden'
	  INSERT INTO  VW_AddressandAccount_Report VALUES
		(@addLine1,@addLine2,@Town_City, @Zip_Postcode,@State_Province,@Country,
		 @accStatusCode_fk, @accTypeCode_fk,@accCustomerId_fk,@accBalance)

	ELSE
	PRINT 'SOMETHING WENT WRONG: COLUMN NOT FOUND'
	END

	-----------EXECUTE PROCEDURE-------------
	EXECUTE SP_AddressandAccount_Report
			'15 Downhill Road',' ','Stockholm','ST05600','New HilTown','Sweden',
			225,235,235,45900

			------VERIFY TABLE-------------
				Select * from Bank_Info.Addresses
					Select * from Account_Info.Account




--***********************************************ANSWER 4 *********************************************************************************

	CREATE VIEW  VW_Transactions_Report
		As
		Select  transAccountNumber_fk,transCode_fk,
			transactionAmount,transMerchant,transDescription,transTypeDesc
			from 
			Transactions_Info.Transactions_Types ty		
			JOIN
		Transactions_Info.Transactions t on ty.transCodeID_pk = t.transCode_fk
	---------
	Select * from VW_Transactions_Report



	----------------------TRIGGER-------------------------
	--CREATE UPDATAVIEW THAT WILL ALSO ENABLE LOGICAL  DATA DISTRBUTION

	CREATE TRIGGER BankTrigger4 
	ON VW_Transactions_Report
	INSTEAD OF INSERT 
	AS
	BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @transAccountNumber_fk BIGINT,@transCode_fk BIGINT,@transactionAmount Decimal(25,2),
			@transMerchant VARCHAR(70),@transDescription VARCHAR(120)
	DECLARE @transTypeDesc VARCHAR(50)

	---map the variable to apporpriate columns
	--SELECT @transCode = transCode FROM INSERTED
	SELECT @transAccountNumber_fk = transAccountNumber_fk FROM INSERTED
	SELECT @transCode_fk = transCode_fk FROM INSERTED
	SELECT @transactionAmount = transactionAmount FROM INSERTED
	SELECT @transMerchant = transMerchant FROM INSERTED
	SELECT @transDescription = transDescription    FROM INSERTED
	SELECT @transTypeDesc = transTypeDesc FROM INSERTED


		 --INSERT THE VARIABLES INTO THE TABLE
		INSERT INTO Transactions_Info.Transactions(transAccountNumber_fk,transCode_fk,transactionAmount,transMerchant,transDescription) 
			VALUES
				(@transAccountNumber_fk,@transCode_fk,@transactionAmount,
			@transMerchant,@transDescription)

					INSERT INTO Transactions_Info.Transactions_Types(transTypeDesc) 
					VALUES ( @transTypeDesc)

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	END CATCH 
	END	


	--------------------------------------
	-----CREATE PROCEDURE TO INSERT DATA FOR FLEXIBLILITY

	CREATE  PROCEDURE SP_Transactions_Report (
			@transAccountNumber_fk BIGINT,@transCode_fk BIGINT,@transactionAmount Decimal(25,2),
			@transMerchant VARCHAR(70),@transDescription VARCHAR(120),
			@transTypeDesc VARCHAR(50))
			AS
	BEGIN
		 IF NOT EXISTS (SELECT 'Deposit','Withdrawal' FROM VW_Transactions_Report WHERE transTypeDesc = @transTypeDesc)
		BEGIN
			-- Insert new row
			INSERT INTO VW_Transactions_Report VALUES
				(@transAccountNumber_fk,@transCode_fk,@transactionAmount,
			@transMerchant,@transDescription,@transTypeDesc)
       
		END
	END

	-----------EXECUTE PROCEDURE--------------

	EXECUTE SP_Transactions_Report
			40048991200,225,78000,'Discover','Self Deposit','Deposit'

			------VERIFY TABLE---------------
		SELECT * from Transactions_Info.Transactions
		SELECT * from Transactions_Info.Transactions_Types





--**************************************************ANSWER 5 *********************************************************************************
		--MARK AS ACCOUNT STATUE READONLY 
				create trigger trAccountStatue
		 on Account_Info.Account_Statue
		 for insert, update, delete
		as
		rollback transaction
		go

		---------------CREATE VIEW -------------
	CREATE VIEW  VW_CustomerSaving_Report
		As
		Select  transAccountNumber_fk,transCode_fk,
			transactionAmount,transMerchant,transDescription,accStatusCode,
	accStatusDesc
	
			from 
		Account_Info.Account_Statue			JOIN
		Transactions_Info.Transactions t on accStatusId_pk = t.transCode_fk
	---------
	Select * from VW_CustomerSaving_Report


	----------------------TRIGGER-------------------------
	--CREATE UPDATAVIEW THAT WILL ALSO ENABLE LOGICAL  DATA DISTRBUTION

	CREATE TRIGGER BankTrigger5 
	ON VW_CustomerSaving_Report
	INSTEAD OF INSERT 
	AS
	BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @transAccountNumber_fk BIGINT,@transCode_fk BIGINT,@transactionAmount Decimal(25,2),
			@transMerchant VARCHAR(70),@transDescription VARCHAR(120)
	DECLARE @accStatusCode VARCHAR(50),@accStatusDesc VARCHAR(50)

	---map the variable to apporpriate columns
	--SELECT @transCode = transCode FROM INSERTED
	SELECT @transAccountNumber_fk = transAccountNumber_fk FROM INSERTED
	SELECT @transCode_fk = transCode_fk FROM INSERTED
	SELECT @transactionAmount = transactionAmount FROM INSERTED
	SELECT @transMerchant = transMerchant FROM INSERTED
	SELECT @transDescription = transDescription    FROM INSERTED
	SELECT @accStatusCode = accStatusCode FROM INSERTED
	SELECT @accStatusDesc = accStatusDesc FROM INSERTED


		 --INSERT THE VARIABLES INTO THE TABLE
		INSERT INTO Transactions_Info.Transactions(transAccountNumber_fk,transCode_fk,transactionAmount,transMerchant,transDescription) 
			VALUES
				(@transAccountNumber_fk,@transCode_fk,@transactionAmount,
			@transMerchant,@transDescription)

					INSERT INTO Account_Info.Account_Statue(accStatusCode, accStatusDesc) 
					VALUES ( @accStatusCode, @accStatusDesc)

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	END CATCH 
	END	


	--------------------------------------
	-----CREATE PROCEDURE TO INSERT DATA FOR FLEXIBLILITY

	CREATE  PROCEDURE SP_CustomerSaving_Report (
			@transAccountNumber_fk BIGINT,@transCode_fk BIGINT,@transactionAmount Decimal(25,2),
			@transMerchant VARCHAR(70),@transDescription VARCHAR(120), @accStatusCode VARCHAR(50),@accStatusDesc VARCHAR(50))
			AS
	BEGIN
			-- Insert new row
			INSERT INTO VW_CustomerSaving_Report VALUES
				(@transAccountNumber_fk,@transCode_fk,@transactionAmount,
			@transMerchant,@transDescription,@accStatusCode, @accStatusDesc)
       
		END


	-----------EXECUTE PROCEDURE--------------

	EXECUTE SP_CustomerSaving_Report
			NULL,225,78000,'Discover','Self Deposit','Deposit',NULL

			------VERIFY TABLE---------------
		SELECT * from Transactions_Info.Transactions
		SELECT * from Account_Info.Account_Statue


