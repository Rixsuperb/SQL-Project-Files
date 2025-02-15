

--*********PHASE 1 ************

	---CREATE DATABASE
	CREATE DATABASE BANK_WORLD_DB
	---Connect Database
	Use BANK_WORLD_DB

	--Create 3 Schema to group and manage the tables

	CREATE SCHEMA Bank_Info
	GO
	CREATE SCHEMA  Account_Info
	CREATE SCHEMA  Transactions_Info


---***********Create tables  for Bank  Schema*************


	---CREATE TABLE BANKS

	CREATE TABLE BANK_Info.Banks (
		BankID_pk INT IDENTITY(225,10) PRIMARY KEY,
		Bank_Details VARCHAR(100)
	)

	---INSERT INTO  TABLE BANKS

	Insert Into BANK_Info.Banks Values ( 'Danske Bank'),
										( 'Starling  Bank'),
										( 'Barclays  PLC'),
										( 'Shawbrook  Bank Limited'),
										( 'TSB Money UK PLC'),
										( 'Standard Chartered Filial Sverige'),
										( 'Standard Chartered PLC'),
										( 'State Bank of UK '),
										( 'Deutsche Bank Filiale'),
										( 'BNP Paribas SA Finland Branch'),
										( 'Swedbank Bank Stockholm'),
										( 'Deutsche Bank, Frankfurt'),
										( 'BayernLB, Munich')
	
	--VERIFY TABLE
	Select * from BANK_Info.Banks

	-------CREATE TABLE  ADDRESSES


	CREATE TABLE BANK_Info.Addresses(
	 AddressID_pk BIGINT IDENTITY(225,10),
	 addLine1  Varchar(100)  NOT NULL,
	 addLine2 Varchar(100) ,
	 Town_City  Varchar(100),
	 Zip_Postcode Varchar(100)  NOT NULL,
	 State_Province Varchar(100) ,
	 Country Varchar(100)   
	)

---ADD PRIMARY KEY TO ADDDRESSID
	Alter Table BANK_Info.Addresses Add Constraint PK_Address_ID Primary Key (AddressID_pk)

	---INSERT INTO TABLE ADDRESS
	Insert Into BANK_Info.Addresses Values 
	(  '12 Main land heli' ,'12a MainLand H' ,   'London' ,'LON34' , 'GreenH','United Kingdom' ),
	(  '78 Currys Estate' ,NULL,  'Stockholm' ,'ST4500' , 'Little  Space Provc',Null),
	(  '45 AryMarvis plat' , '45b Marvis plat', 'Manchester' ,'MT8004' , 'Gasgow Mar','United Kingdom' ),
	(  '3 Deutjolid Avenue' ,NULL,  'Munich' ,'26M78' , 'MudDeutshe stat','Germany' ),
	(  '46 Main land heli' ,NULL ,   'London' ,'LON34' , 'GreenH','United Kingdom' ),
	(  '12 Offenbase Cele' ,'12ab Offenbase' ,   'FrankFurt' ,'50034' , 'StuProvice','Germany' ),
	(  '100 Welsh: Caerdydd' ,'12a MainLand H' ,   'Manchester' ,'MA20034' , 'Cardiff9','United Kingdom' ),
	(  'A222 Stuwester' ,'A22 Valley wester' ,   'Stockholm' ,'STU400' , 'StockGarden','Sweden' ),
	(  'A120 Brimstock' ,NULL ,   'Stockholm' ,'BRIMSTU400' , 'Stockhouse','Sweden' ),
	(  '125 shefield Mans' ,'56 Seftland Acade' ,   'Manchester' ,'LON34' , 'GreenH','United Kingdom' ),
	(  'F45 Edinburche Heaven' ,NULL,  'Munich' ,'MU5690' , 'MudDeutshe stat','Germany' ),
	(  '12 Laghall Switch ','12ab Lagsall' ,   'FrankFurt' ,'FT0034' , 'FTUProvice','Germany' ),
	(  '125 Cardiff9 Job' ,'5 Job Manner' ,   'London' ,'LOC00' , 'Cliff House',NULL)


	--VERIFY TABLE
	Select * from BANK_Info.Addresses

	
	-------CREATE TABLE  BRANCHTYPES

	CREATE TABLE BANK_INFO.BranchTypes
	(	
		BranchTypeID_pk	BIGINT IDENTITY(225,10) PRIMARY KEY,
		branchTypeCode	VARCHAR(20) ,
		branchTypeDesc	VARCHAR(100)

	) 
	-----INSERT INTO TABLE BRANCHTYPE
	INSERT INTO BANK_INFO.BranchTypes (branchTypeCode,branchTypeDesc) VALUES ('LU','Large Urban')
	INSERT INTO BANK_INFO.BranchTypes(branchTypeCode,branchTypeDesc) VALUES ('SR','Small Rural')
	INSERT INTO BANK_INFO.BranchTypes (branchTypeCode,branchTypeDesc) VALUES ('HO','Head Office')

	--VERIFY TABLE
	Select * from BANK_Info.BranchTypes


	-------CREATE TABLE  BRANCHES

	CREATE TABLE BANK_Info.Branches(
	brBranchID_pk BIGINT  IDENTITY(225,10) PRIMARY KEY,
	brAddressID_fk BIGINT FOREIGN KEY REFERENCES BANK_Info.Addresses( AddressID_pk),
	brBankID_fk INT FOREIGN KEY REFERENCES BANK_Info.Banks(BankID_pk),
	brBranchTypeID_fk	BIGINT references BANK_Info.BranchTypes (BranchTypeID_pk),
	brBranchName		VARCHAR(100),
	brBranchPhone1		VARCHAR(20),
	brBranchPhone2		VARCHAR(20),
	brBranchFax			VARCHAR(20),
	brBranchemail		VARCHAR(50)
	)


	--INSERT INT0 TABLE BRANCHES
	INSERT INTO BANK_Info.Branches(brAddressID_fk,brBankID_fk,brBranchTypeID_fk,brBranchName,brBranchPhone1,brBranchPhone2,brBranchFax,brBranchemail) 
	Values
	(225,225,225,'Banclore Hills','+44 1803 771100','+44 8251 249247','56 890.000','inboundcontact@bcl.uk'),
	(235,225,235,'Manchester Blue','+44 3567 678989','+44 8201 249847','8640 6777','inboundcontact@mans.uk'),
	(245,235,225,'Swedish Neadon','+46 1800 771100','+46 7851 249247','987 000','inboundcontact@swh.se'),
	(255,255,245,'SunBranches','+49 990 771100','+49 826 249247','8760 098', 'inboundcontact@sub.de'),
	(265,265,245,'Banclore Hills','+44 1803 771100','+44 8251 249247','8765 9222', 'inboundcontact@bcl.uk'),
	(275,225,235,'Downtown Franfurt ','+49 1233 77110','+49 9800 24924','8700 9222','inboundcontact@dff.de'),
	(285,285,245,'Complex Head','+44 6663 771190','+44 643 249247','8700 9200','inboundcontact@coh.uk'),
	(295,295,235,'MonsterB Varo','+46 0980 001100','+46 500 249247','9000 9200','inboundcontact@mob.se')


	--VERIFY TABLE
	Select * from BANK_Info.Branches



	--CREATE TABLE CUSTOMER 
	CREATE TABLE BANK_Info.Customers
	(	
		customerID_pk	   BIGINT  IDENTITY (225,10) PRIMARY KEY,
		customerAddressID_fk BIGINT FOREIGN KEY REFERENCES BANK_Info.Addresses( AddressID_pk),
		customerBranchID_fk	 BIGINT,
		customerFirstName	 VARCHAR(50),
		customerLastName	     VARCHAR(50),
		customerMiddleName	 VARCHAR(50),
		customerDOB	         DATE,
		customerSince	     DATETIME,
		customerPhone1	     VARCHAR(20),
		customerPhone2	     VARCHAR(20),
		customerFax	         VARCHAR(20),
		customerGender	     VARCHAR(10),
		customerEmail	     VARCHAR(50)
	)


	---ADD FORIEGN KEY customerBranchID_fk
	Alter table BANK_Info.Customers Add Constraint FK_branchID Foreign Key (customerBranchID_fk) References BANK_Info.Branches(brBranchID_pk)

	---INSERT INTO CUSTOMERS
	INSERT INTO BANK_Info.Customers (customerAddressID_fk,customerBranchID_fk,customerFirstName,customerLastName,customerMiddleName,
	customerDOB,customerSince,customerPhone1,customerPhone2,customerFax	,customerGender, customerEmail)
	VALUES 
	(225,245,'Marvel','Tarpe','Tim','1986-Dec-25','2000','+44 824 247623','','','Male','marle@gmail.com'),
	(235,295,'Julie','Tare','','1993-Jan-27',' 2005','+46 098 247623','','','Female','ju768@yahoo.com'),
	(315,245,'Marvel','','Martha','1990-Aug-19','2005','+44 824 8765','+44 7659 7700','1000 100','Female','marmar@gmail.com'),
	(255,255,'Kelvin','Kelu','Katte','2000-Aug-02','2020','+49 824 900623','+49 67 87770','8000 4444','Male','kevin67@gmail.com'),
	(265,225,'Cynthia','','Sam','2000-July-04','2000','+44 820 247623','','','Female','cyoo@gmail.com'),
	(275,255,'Devis ','Xaius','Dolo','1900-Oct-19','2000','+49 824 0090','+49 0965 7700','1050 100','Male','devxaur@yahoo.com'),
	(225,285,'Stanley','','Sammy','2020-July-23','2020','+44 666 8765','+44 7659 6554','7800 9000','Male','sanstan@gmail.com'),
	(325,275,'Vincie','Dawn','Vamda','1990-Aug-12','2001','+49 600 8899','','','Male','vidawn23@gmail.com'),
	(255,285,'Favour','Irony','man','1993-Oct-16','2000','+44 988 8765','+44 7879 7700','5500 1009','Female','fav2000@yahoo.com'),
	(255,295,'Edmary',' ','Coliesman','2005-July-29','2005','+46 100 2765','','5200 3009','Female','edcoli@yahoo.com')


	--VERIFY TABLE
	Select * from BANK_Info.Customers



	---***********Create tables  for Account Schema*************

	--CREATE TABLE ACCOUNT_TYPE

	CREATE TABLE Account_Info.Account_Types
	( 
	accTypeId_pk BIGINT IDENTITY (225,10)  Primary Key,
	accTypeCode VARCHAR(10),
	accTypeDesc VARCHAR(100)
	)

	--INSERT INTO TABLE ACCOUNT_TYPE
	INSERT INTO Account_Info.Account_Types VALUES ('CHK','Checking')
	INSERT INTO Account_Info.Account_Types VALUES ('SAV','Saving')
	INSERT INTO Account_Info.Account_Types VALUES ('CUR','Current')
	INSERT INTO Account_Info.Account_Types VALUES ('LN','Loan')


	--VERIFY ACCOUNT_TYPE
	Select * from Account_Info.Account_Types 


		--CREATE TABLE ACCOUNT_STATUE

	CREATE TABLE Account_Info.Account_Statue
	( 
	accStatusId_pk BIGINT IDENTITY (225,10)  Primary Key ,
	accStatusCode VARCHAR(50) Default ('Dormant'),
	accStatusDesc VARCHAR(50) Default ('Dormant')
	)

		--INSERT INTO TABLE ACCOUNT_TYPE

	INSERT INTO Account_Info.Account_Statue VALUES ('A','Active')
	INSERT INTO Account_Info.Account_Statue VALUES ('C','Closed')

	--VERIFY TABLE
	Select * from Account_Info.Account_Statue

	
	---	--CREATE TABLE ACCOUNT

		CREATE TABLE Account_Info.Account
		( 
		accNumber_pk BIGINT IDENTITY (40048990900,30) PRIMARY KEY,
		accStatusCode_fk BIGINT FOREIGN KEY  REFERENCES  Account_Info.Account_Statue (accStatusId_pk),
		accTypeCode_fk BIGINT   FOREIGN KEY  REFERENCES Account_Info.Account_Types (accTypeId_pk),
		accCustomerId_fk BIGINT  REFERENCES BANK_Info.Customers (customerID_pk),
		accBalance DECIMAL(23,2)
		) 


		--INSERT INTO TABLE ACCOUNT

	INSERT INTO Account_Info.Account (accStatusCode_fk,accTypeCode_fk,accCustomerId_fk,accBalance) 
		VALUES 
		(225,235,225,10500),
		(235,235,235,200000.9897),
		(225,245,245,9500.456),
		(225,225,255,90127250.00),
		(235,255,225,5100),
		(225,235,255,10500),
		(235,235,285,200000.9897),
		(225,245,295,9500.456),
		(225,225,315,90127250.00),
		(235,255,305,5100)

		---VERIFY TABLE
	Select * from Account_Info.Account



		---***********Create tables  for Transactions Schema*************

		--- CREATE TABLE TRANSACTIONS_TYPES

		Create Table Transactions_Info.Transactions_Types(
		transCodeID_pk BIGINT IDENTITY (225,10) Primary Key,
		transTypeDesc VARCHAR(50)
		)



				--INSERT INTO TABLE TRANSACTIONS_TYPES
		INSERT INTO Transactions_Info.Transactions_Types(transTypeDesc) VALUES ('Deposit')
		INSERT INTO Transactions_Info.Transactions_Types(transTypeDesc) VALUES ('Withdrawal')

		--VERIFY TABLE
		Select * from Transactions_Info.Transactions_Types


		--- CREATE TABLE TRANSACTIONS

		CREATE TABLE Transactions_Info.Transactions
		( 
		transID_pk BIGINT IDENTITY (225,10) Primary Key,
		transCode VARCHAR(50),
		transAccountNumber_fk BIGINT  REFERENCES Account_Info.Account(accNumber_pk),
		transCode_fk BIGINT REFERENCES Transactions_Info.Transactions_Types(transCodeID_pk),
		transDatetime DateTime Default GetDate(),
		transactionAmount Decimal(25,2),
		transMerchant VARCHAR(70),
		transDescription VARCHAR(120) Default NULL,
		RemainedBalance DECIMAL(24,00) Default NULL 
		
		) 

		--ADD UNIQUE NUMBERS FOR transCode
		ALTER TABLE Transactions_Info.Transactions ADD CONSTRAINT New_transCode  Default NEWID() FOR transCode

		---INSERT INTO TRANSACTIONS
		INSERT INTO Transactions_Info.Transactions(transAccountNumber_fk,transCode_fk,transactionAmount,transMerchant,transDescription) 
		VALUES
		(40048990900,225,350.56,'Self',' Deposit'),
		(40048990930,235,2000,'PayPal','Withdrawal'),
		(40048990930,225,13670.45,'','Cheque #5001'),
		 (40048990960,225,3500,'Self',' Deposit'),
		 (40048990990,235,3000,'Self','Withdrawal'),
		(40048990960,225,200000,'Discover','Withdrawal'),
		(40048990960,225,20500.45,'Self','Self Deposit'),
		 (40048991080,235,120000,'Paypal','Withdrawal'),
		 (40048991110,225,7500.45,'Self','Self Deposit'),
		(40048991140,235,25000,'Discover','Withdrawal')

		--VERIFY TABLE
		Select * from Transactions_Info.Transactions

	--VERIFY ALL TABLE	
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

----------------------------------------------------------------------------------------------------------











	--------------------OTHERS-----------------------------------------------
	use AmazonDatabase

	drop table Account_Info.Account_Types
	drop table Account_Info.Account_Statue
	drop table Account_Info.Account
	---------------------------------
	drop table Bank_Info.Banks
	drop table Bank_Info.Addresses
	drop table Bank_Info.Branches
	drop table Bank_Info.BranchTypes
	drop table Bank_Info.Customers
	-------------------------------------
	drop table Transactions_Info.Transactions_Types
	drop table Transactions_Info.Transactions
	----------------------
	CHATGPT
	CREATE PROCEDURE SP_BankandBranch_Report 
(
    @BankID BIGINT,  
    @BankDetails VARCHAR(100), 
    @brAddressID_fk BIGINT,
    @brBankID_fk BIGINT,
    @brBranchTypeID_fk BIGINT,
    @brBranchName VARCHAR(100),
    @brBranchPhone1 VARCHAR(20),
    @brBranchPhone2 VARCHAR(20),
    @brBranchFax VARCHAR(20),
    @brBranchemail VARCHAR(50)
)
AS
BEGIN
    -- Check if the row already exists based on the unique identifier
    IF EXISTS (SELECT 1 FROM VW_BankandBranch_Report WHERE brAddressID_fk = @brAddressID_fk)
    BEGIN
        -- Update existing row
        UPDATE VW_BankandBranch_Report
        SET
            brBankID_fk = @brBankID_fk,
            brBranchTypeID_fk = @brBranchTypeID_fk,
            brBranchName = @brBranchName,
            brBranchPhone1 = @brBranchPhone1,
            brBranchPhone2 = @brBranchPhone2,
            brBranchFax = @brBranchFax,
            brBranchemail = @brBranchemail
        WHERE brAddressID_fk = @brAddressID_fk;
    END
    ELSE
    BEGIN
        -- Insert new row
        INSERT INTO VW_BankandBranch_Report (
            brAddressID_fk,
            brBankID_fk,
            brBranchTypeID_fk,
            brBranchName,
            brBranchPhone1,
            brBranchPhone2,
            brBranchFax,
            brBranchemail
        )
        VALUES (
            @brAddressID_fk,
            @brBankID_fk,
            @brBranchTypeID_fk,
            @brBranchName,
            @brBranchPhone1,
            @brBranchPhone2,
            @brBranchFax,
            @brBranchemail
        );
    END
END;
------------------------------------

DECLARE  @addLine1  Varchar(100),@addLine2 Varchar(100) ,@Town_City  Varchar(100), @Zip_Postcode Varchar(100),
		 @State_Province Varchar(100) ,@Country Varchar(100)   
	DECLARE @accStatusCode_fk BIGINT, @accTypeCode_fk BIGINT,@accCustomerId_fk BIGINT,@accBalance DECIMAL(23,2)

	---map the variable to apporpriate columns
	SELECT *,'' FROM my_table


	--------------------------------

	CREATE  PROCEDURE SP_Transactions_Report (
			@transAccountNumber_fk BIGINT,@transCode_fk BIGINT,@transactionAmount Decimal(25,2),
			@transMerchant VARCHAR(70),@transDescription VARCHAR(120),
			@transTypeDesc VARCHAR(50))
			AS
	BEGIN
		 IF NOT EXISTS (SELECT 'Depsoit' FROM VW_Transactions_Report WHERE transTypeDesc = @transTypeDesc)
		BEGIN
			-- Update existing row
			UPDATE VW_Transactions_Report
			SET
		 transDescription  = @transDescription
		 where transTypeDesc = @transTypeDesc 

		END
		ELSE
		BEGIN
			-- Insert new row
			INSERT INTO VW_Transactions_Report VALUES
				(@transAccountNumber_fk,@transCode_fk,@transactionAmount,
			@transMerchant,@transDescription,@transTypeDesc)
       
		END
	END

