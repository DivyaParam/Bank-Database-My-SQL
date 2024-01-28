/* Banking Transactions */

Create database BankDiv;
Go 

use BankDiv;
Go

--Creating table named UserLogins
CREATE TABLE UserLogins
(
		UserLoginID SMALLINT NOT NULL IDENTITY(1,1),
		UserLogin VARCHAR (50) NOT NULL,
		UserPassword VARCHAR(20) NOT NULL,
		CONSTRAINT pk_UL_UserLoginID PRIMARY KEY(UserLoginID)
);
Go

--Creating a table named UserSecurityQuestions
CREATE TABLE UserSecurityQuestions
(
		UserSecurityQuestionID TINYINT NOT NULL IDENTITY(1,1),
		UserSecurityQuestion VARCHAR(50) NOT NULL,
		CONSTRAINT pk_USQ_UserSecurityQuestionID PRIMARY KEY(UserSecurityQuestionID)
);
Go

--Creating a table named AccountType
CREATE TABLE AccountType
(
		AccountTypeID TINYINT NOT NULL IDENTITY(1,1),
		AccountTypeDescription VARCHAR(30) NOT NULL,
		CONSTRAINT pk_AT_AccountTypeID PRIMARY KEY(AccountTypeID)
);
Go

--Creating a table named SavingsInterestRates
CREATE TABLE SavingsInterestRates
(
		InterestSavingsRatesID TINYINT NOT NULL IDENTITY(1,1),
		InterestRatesValue NUMERIC(9,2) NOT NULL,
		InterestRatesDescription VARCHAR(20) NOT NULL,
		CONSTRAINT pk_SIR_InterestSavingsRatesID PRIMARY KEY(InterestSavingsRatesID)
);
Go

--Creating a table named AccountStatusType
CREATE TABLE AccountStstusType
(
		AccountStatusTypeID TINYINT NOT NULL IDENTITY(1,1),
		AccountStstusTypeDescription VARCHAR (30) NOT NULL,
		CONSTRAINT pk_AST_AccountStstusTypeID PRIMARY KEY (AccountStatusTypeID)
		
);
Go
--Creating a table named FailedTransactionErrorType

CREATE TABLE FailedTransactionErrorType
(
		FailedTransactionErrorTypeID TINYINT NOT NULL IDENTITY(1,1),
		FailedTransactionErrorTypeDescription VARCHAR(50) NOT NULL,
		CONSTRAINT pk_FTET_FailedTransactionErrorTypeID PRIMARY KEY(FailedTransactionErrorTypeID)
);
Go

--Creating a table named LoginErrorLog
CREATE TABLE LoginErrorLog
(
		ErrorLogID INT NOT NULL IDENTITY(1,1),
		ErrorTime DATETIME NOT NULL,
		FailedTransactionXML XML,
		CONSTRAINT pk_LEL_ErrorLogID PRIMARY KEY(ErrorLogID)
);
Go

--Creating a table named Employee
CREATE TABLE Employee
(
		EmployeeID INT NOT NULL IDENTITY(1,1),
		EmployeeFirstName VARCHAR(25) NOT NULL,
		EmployeeMiddleInitial Char(1),
		EmployeeLastName VARCHAR(25),
		EmployeeisManager BIT,
		CONSTRAINT pk_E_EmployeeID PRIMARY KEY(EmployeeID)
);
Go

--Creating a table named TransactionType
CREATE TABLE TransactionType
(
		TransactionTypeID TINYINT NOT NULL IDENTITY(1,1),
		TransactionTypeName CHAR(10) NOT NULL,
		TransactionTypeDescription VARCHAR(50),
		TransactionFeeAmount SMALLMONEY,
		CONSTRAINT pk_TT_TransactionTypeID PRIMARY KEY(TransactionTypeID)
);
Go

--Creating a table named FailedTransactionLog
CREATE TABLE FailedTransactionLog
(
		FailedTransactionLogID INT NOT NULL IDENTITY(1,1),
		FailedTransactionErrorTypeID TINYINT NOT NULL,
);
Go

DROP TABLE FailedTransactionLog;
Go

-- RE creating the table FailedTransactionLog
CREATE TABLE FailedTransactionLog
(
		FailedTransactionID INT NOT NULL IDENTITY(1,1),
		FailedTransactionErrorTypeID TINYINT NOT NULL,
		FailedTransactionErrorTime DATETIME,
		FailedTransactionErrorXML XML,
		CONSTRAINT pk_FTL_FailedTransactionLogID PRIMARY KEY(FailedTransactionID),
		CONSTRAINT fk_FTET_FailedTransactionErrorTypeID FOREIGN KEY(FailedTransactionErrorTypeID) REFERENCES FailedTransactionErrorType(FailedTransactionErrorTypeID)
);
Go

--Creating a table named UserSecurityAnswers
CREATE TABLE UserSecurityAnswers
(
		UserLoginID SMALLINT NOT NULL IDENTITY(1,1),
		UserSecurityAnswers VARCHAR(25) NOT NULL,
		UserSecurityQuestionID TINYINT NOT NULL,
		CONSTRAINT pk_USA_UserLoginID PRIMARY KEY(UserLoginID),
		CONSTRAINT fk_UL_UserLoginID FOREIGN KEY (UserLoginID) REFERENCES UserLogins(UserLoginID),
		CONSTRAINT fk_USQ_UserSecurityQuestionID FOREIGN KEY(UserSecurityQuestionID) REFERENCES UserSecurityQuestions(UserSecurityQuestionID)
);
Go

--Creating a table named Account
CREATE TABLE Account
(
		AccountID INT NOT NULL IDENTITY(1,1),
		CurrentBalance INT NOT NULL,
		AccountTypeID TINYINT NOT NULL REFERENCES AccountType(AccountTypeID),
		AccountStatusTypeID TINYINT NOT NULL,
		InterestSavingsRatesID TINYINT NOT NULL,
		CONSTRAINT pk_A_AccountID PRIMARY KEY(AccountID),
		CONSTRAINT fk_AST_AccountStatusTypeID FOREIGN KEY (AccountStatusTypeID) REFERENCES AccountStstusType (AccountStatusTypeID),
		CONSTRAINT fk_SIR_InterestSavingsRatesID FOREIGN KEY(InterestSavingsRatesID) REFERENCES SavingsInterestRates (InterestSavingsRatesID)
);
Go

--Creating a table named LoginAccount
CREATE TABLE LoginAccount
(
		UserLoginID SMALLINT NOT NULL,
		AccountID INT NOT NULL,
		CONSTRAINT fk_UL_UserLogins FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLOginID),
		CONSTRAINT fk_A_Account FOREIGN KEY(AccountID) REFERENCES Account (AccountID)
);
Go

--Creating a table named Customer
CREATE TABLE Customer
(
	CustomerID INT NOT NULL IDENTITY(1,1),
	AccountID INT NOT NULL,
	CustomerAddress1 VARCHAR(30) NOT NULL,
	CustomerAddress2  VARCHAR(30),
	CustomerFirstName  VARCHAR(30) NOT NULL,
	CustomerMiddleInitial CHAR(1),
	CustomerLastName  VARCHAR(30) NOT NULL,
	City  VARCHAR(20) NOT NULL,
	State CHAR(2) NOT NULL,
	ZipCode CHAR(10) NOT NULL,
	EmailAddress CHAR(40) NOT NULL,
	HomePhone VARCHAR(10) NOT NULL,
	CellPhone VARCHAR(10) NOT NULL,
	WorkPhone VARCHAR(10) NOT NULL,
	SSN VARCHAR(9),
	UserLoginID SMALLINT NOT NULL,
	CONSTRAINT pk_C_CustomerID PRIMARY KEY(CustomerID),
	CONSTRAINT fk_A_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_UL_C_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)  
);
Go

--Creating a table named CustomerAccount
CREATE TABLE CustomerAccount
(
	AccountID INT NOT NULL ,
	CustomerID INT NOT NULL,
	CONSTRAINT fk_A_CA_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_C_CA_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);
GO

--Creating a table TransactionLog

CREATE TABLE TransactionLog
(
	TransactionID INT NOT NULL IDENTITY(1,1),
	TransactionDate DATETIME NOT NULL,
	TransactionTypeID TINYINT NOT NULL,
	TransactionAmount Money NOT NULL,
	NewBalance Money NOT NULL,
	AccountID INT NOT NULL,
	CustomerID INT NOT NULL,
	EmployeeID INT NOT NULL,
	UserLoginID SMALLINT NOT NULL,
	CONSTRAINT pk_TL_TransactionID PRIMARY KEY(TransactionID),
	CONSTRAINT fk_TT_TL_TransactionTypeID FOREIGN KEY(TransactionTypeID) REFERENCES TransactionType(TransactionTypeID),
	CONSTRAINT fk_A_TL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_C_TL_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
	CONSTRAINT fk_E_TL_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
	CONSTRAINT fk_UL_TL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)    
);
GO

--Creating a table OverDraftLog

CREATE TABLE OverDraftLog
(
	AccountID INT NOT NULL IDENTITY(1,1),
	OverDraftDate DATETIME NOT NULL,
	OverDraftAmount Money NOT NULL,
	OverDraftTransactionXML XML NOT NULL,
	CONSTRAINT Pk_ODL_AccountID PRIMARY KEY(AccountID),
	CONSTRAINT fk_A_ODL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);
GO

--Inserting rows in each table

insert into UserLogins values('User1', 'Pass1');
insert into UserLogins values('User2', 'Pass2');
insert into UserLogins values('User3', 'Pass3');
insert into UserLogins values('User4', 'Pass4');
insert into UserLogins values('User5', 'Pass5');
GO


insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite food?');
GO

Insert into AccountType values('Savings');
Insert into AccountType values('Checking');
GO

--Inserting values into the SavingsInterestRates table
insert into SavingsInterestRates values(0.5, 'Low');
insert into SavingsInterestRates values(2, 'Medium');
insert into SavingsInterestRates values(3, 'High');
insert into SavingsInterestRates values(4, 'Very high');
insert into SavingsInterestRates values(5, 'Super high');
GO

select * from AccountStstusType;
insert into AccountStstusType values('Closed');
insert into AccountStstusType values('Active');
insert into AccountStstusType values('Dormant');
insert into AccountStstusType values('Passive');
insert into AccountStstusType values('Active');
GO

insert into FailedTransactionErrorType values('Withdraw limit reached');
insert into FailedTransactionErrorType values('Daily limit reached');
insert into FailedTransactionErrorType values('No tenough balance');
insert into FailedTransactionErrorType values('Invalid denomination');
insert into FailedTransactionErrorType values('ATM machine down');
GO

insert into LoginErrorLog values(CAST('2015/6/4 07:30:56' AS DATETIME), 'Bad Connection');
insert into LoginErrorLog values(CAST('2018/6/9 12:34:57' AS DATETIME), 'Invalid User');
insert into LoginErrorLog values(CAST('2016/4/5 02:14:00' AS DATETIME), 'Wrong Password');
insert into LoginErrorLog values(CAST('2014/7/5 05:56:59' AS DATETIME), 'Server issue');
insert into LoginErrorLog values(CAST('2009/10/12 08:34:15' AS DATETIME), 'Datacenter down');
GO

insert into Employee values('E3', 'K', 'E3', '0');
insert into Employee values('E5', 'B', 'E5', '1');
insert into Employee values('E7', 'P', 'E7', '0');
insert into Employee values('E9', 'R', 'E9', '1');
insert into Employee values('E11', 'K', 'E11', '1');
GO

insert into TransactionType values('Balance', 'See money', '0');
insert into TransactionType values('Transfer', 'Send money', '450');
insert into TransactionType values('Receive', 'Get money', '300');
insert into TransactionType values('Paid', 'Paid to John', '45000');
insert into TransactionType values('Statement', 'Checked monthly transaction', '0');
GO

insert into FailedTransactionLog values(1, CAST('2015/6/4 07:30:56' AS DATETIME), 'First');
insert into FailedTransactionLog values(2, CAST('2018/6/9 12:34:57' AS DATETIME), 'Second');
insert into FailedTransactionLog values(3, CAST('2016/4/5 02:14:00' AS DATETIME), 'Third');
insert into FailedTransactionLog values(4, CAST('2014/7/5 05:56:59' AS DATETIME), 'Fourth');
insert into FailedTransactionLog values(5, CAST('2009/10/12 08:34:15' AS DATETIME), 'Fifth');
GO

insert into UserSecurityAnswers values('Apples', 1);
insert into UserSecurityAnswers values('Spiderman', 2);
insert into UserSecurityAnswers values('School1', 3);
insert into UserSecurityAnswers values('Ram', 4);
insert into UserSecurityAnswers values('Toyota', 5);
GO

insert into Account values(15000.7, 1, 1, 1);
insert into Account values(25000.5, 2, 2, 2);
insert into Account values(17000.2, 1, 1, 1);
insert into Account values(45000, 2, 2, 2);
insert into Account values(2320, 2, 2, 2);
GO

insert into LoginAccount values(1, 1);
insert into LoginAccount values(2, 2);
insert into LoginAccount values(3, 3);
insert into LoginAccount values(4, 4);
insert into LoginAccount values(5, 5);
GO

insert into Customer values(1, 'Address1', 'Address2', 'Customer1', 'U', 'CLastname1', 'Ottawa', 'ON', '3A5z9z', 'user5@user.com', '141655555', '453554464', '3462325', 'A12345', 1);
insert into Customer values(2, 'Address1', 'Address2', 'Customer2', 'K', 'CLastname2', 'Hamilton', 'ON', 'fe3453', 'user6@user.com', '141655555', '567435345', '6332423', 'D34353', 2);
insert into Customer values(3, 'Address1', 'Address2', 'Customer3', 'P', 'CLastname3', 'Vacouver', 'BC', 'fdf45', 'user7@user.com', '141655555', '681316226', '9202521', 'J56361', 3);
insert into Customer values(4, 'Address1', 'Address2', 'Customer4', 'B', 'CLastname4', 'London', 'ON', '23ffbfs', 'user8@user.com', '141655555', '795197107', '8674252', 'I78369', 4);
insert into Customer values(5, 'Address1', 'Address2', 'Customer5', 'K', 'CLastname5', 'Calgary', 'AB', 'hg4536', 'user9@user.com', '141655555', '909077988', '9209371', 'K10377', 5);
GO

insert into CustomerAccount values(1, 1);
insert into CustomerAccount values(2, 2);
insert into CustomerAccount values(3, 3);
insert into CustomerAccount values(4, 4);
insert into CustomerAccount values(5, 5);
GO

insert into TransactionLog values('2015/6/4 07:30:56', 1,15000.7, 7869878, 1, 1, 1, 1);
insert into TransactionLog values('2018/6/9 12:34:57', 2,435435, 675687, 2, 2, 2, 2);
insert into TransactionLog values('2016/4/5 02:14:00', 3,855869.3, 34512356, 3, 3, 3, 3);
insert into TransactionLog values('2014/7/5 05:56:59', 4,1276303.6, 4643234, 4, 4, 4, 4);
insert into TransactionLog values('2009/10/12 08:34:15', 5,1696737.9, 325344, 5, 5, 5, 5);
GO

insert into OverDraftLog values('2015/6/4 07:30:56', 0, 'Clear');
insert into OverDraftLog values('2018/6/9 12:34:57', 5, 'Pending');
insert into OverDraftLog values('2016/4/5 02:14:00', 10, 'Clear');
insert into OverDraftLog values('2014/7/5 05:56:59', 15, 'Pending');
insert into OverDraftLog values('2009/10/12 08:34:15', 20, 'Clear');
Go

--Writing a transaction to pull all the customers with a checking account from ON province

CREATE VIEW VW_Customer_ON AS
SELECT DISTINCT c.* FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN AccountType at
ON a.AccountTypeID = at.AccountTypeID
WHERE at.AccountTypeDescription = 'Checking' and c.State = 'ON';
GO

SELECT * FROM VW_Customer_ON;
GO

--Creating a view to pull all the customers with a total account balance(Including the Interest) above 5000

CREATE VIEW VW_Account_Balance AS
SELECT c.CustomerFirstName, SUM(a.CurrentBalance) AS Ac_Balance, SUM(a.CurrentBalance + (a.CurrentBalance * s.InterestSavingsRatesID)/100) AS Total_Ac_Balance 
FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN SavingsInterestRates s
ON a.InterestSavingsRatesID = s.InterestSavingsRatesID 
GROUP BY c.CustomerFirstName
HAVING SUM(a.CurrentBalance + (a.CurrentBalance * s.InterestRatesValue)/100) > 5000;
GO

SELECT * FROM VW_Account_Balance
GO

--Creating a view to get the counts of checkings and savings account specific to each customer

CREATE VIEW VW_Customer_ACC 
AS
SELECT c.CustomerFirstName, at.AccountTypeDescription, COUNT(*) AS Total_AC_Types FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN AccountType at
ON a.AccountTypeID = at.AccountTypeID
GROUP BY c.CustomerFirstName, at.AccountTypeDescription;
GO

SELECT * FROM VW_Customer_ACC
GO

--Creating a view to get the login and password specific to a user

CREATE VIEW VW_Account_UL 
AS
SELECT DISTINCT ul.UserLogin, ul.UserPassword
FROM UserLogins ul
JOIN LoginAccount la
ON ul.UserLoginID = la.UserLoginID
WHERE la.AccountID = '1'
GO

SELECT * FROM VW_Account_UL
GO

--Creating a view to get all customer overdraft amount

CREATE VIEW VW_Customer_OD 
AS
SELECT DISTINCT c.CustomerFirstName, o.OverDraftAmount
FROM OverDraftLog o
JOIN Customer c
ON o.AccountID = c.AccountID;
GO

SELECT * FROM VW_Customer_OD
GO

--Creating a stored procedure to add User as prefix

CREATE PROCEDURE sp_Update_Login
AS
UPDATE UserLogins
SET UserLogin = Concat('User_', UserLogin);
GO
EXEC sp_Update_Login;
GO

EXEC sp_Update_Login
GO

--Creating a stored procedure that accepts AccountID as a parameter and returns customer's full name

CREATE PROCEDURE sp_Customer_Details @AccountID INT
AS
SELECT c.CustomerFirstName + ' ' + c.CustomerMIddleInitial + ' ' + c.CustomerLastName AS Customer_Full_Name
FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
WHERE a.AccountID = @AccountID;
GO

EXEC sp_Customer_Details 2;
GO

--Creating a stored procedure that returns error logs inserted in the last 24 hours

CREATE PROCEDURE sp_Errors_24
AS
SELECT * FROM LoginErrorLog
WHERE  ErrorTime BETWEEN DATEADD(hh, -24, GETDATE()) AND GETDATE();
GO

EXEC sp_Errors_24
GO

--Creating a stored procedure that takes deposit as a parameter and updates CurrentBalanace value for that particular account
CREATE PROCEDURE sp_Update_cBalance_After_Deposit @AccountID INT, @Deposit INT
AS
UPDATE Account
SET CurrentBalance = CurrentBalance + @Deposit
where AccountID = @AccountID;
GO

EXEC sp_Update_cBalance_After_Deposit 3, 300;
GO

--Creating a stored procedure that takes in a withdrawal amount as a parameter and updates the CurrentBalance value for that specific account

CREATE PROCEDURE sp_Update_cBalance_After_Withdraw @AccountID INT, @Withdraw INT
AS
UPDATE Account
SET CurrentBalance = CurrentBalance - @Withdraw
WHERE AccountID = @AccountID;
GO

EXEC sp_Update_cBalance_After_Withdraw 3,300;
GO

--Creating a stored procedure to remove all security questions attached to a user login

CREATE PROCEDURE sp_Delete_Question @UserLoginID SMALLINT
AS
DELETE UserSecurityQuestions
FROM UserSecurityQuestions uq
JOIN UserSecurityAnswers ua
ON ua.UserSecurityQuestionID = uq.UserSecurityQuestionID
JOIN UserLogins ul
ON ua.UserLoginID = ul.UserLoginID
WHERE ul.UserLoginID = @UserLoginID;
GO

EXEC sp_Delete_Question 5;
GO

--Creating a stored procedure to delete all error logs created in the last hour
CREATE PROCEDURE sp_Delete_Errors
AS
delete FROM LoginErrorLog
WHERE  ErrorTime BETWEEN DATEADD(hh, -1, GETDATE()) AND GETDATE();
GO

EXEC sp_Delete_Errors;
GO

--Creating a stored procedure to remove the SSN column from the customer table
CREATE PROCEDURE sp_Remove_Column
AS
ALTER TABLE CUSTOMER
DROP COLUMN CustomerAddress1;
GO

EXEC sp_Remove_Column;
GO