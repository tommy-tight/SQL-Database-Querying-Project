-- SQL LAB 2

-- Question 1 
-- The Marketing Department is preparing an email promotion that will 
-- be sent to all customers who opted in. 
-- Provide them with a list of first names, last names and email addresses 
-- for eligible customers.
SELECT		FirstName, LastName, EmailAddress
FROM		Person.Person P
INNER JOIN	Person.EmailAddress EA
ON			EA.BusinessEntityID = P.BusinessEntityID
WHERE		EmailPromotion = 1


-- QUESTION 2 
-- AdventureWorks suffered a security breach on December 31, 2007. Produce a list of 
-- current employees who have not changed their passwork since the 
-- breach. Include first/last names, password change dates, 
-- and email addresses.
SELECT		FirstName, LastName, P.ModifiedDate, EmailAddress
FROM		Person.EmailAddress EA
INNER JOIN	PERSON.Person P
ON			P.BusinessEntityID = EA.BusinessEntityID
INNER JOIN	Person.Password PA
ON			PA.BusinessEntityID = P.BusinessEntityID
INNER JOIN	HumanResources.Employee e
ON			E.BusinessEntityID = P.BusinessEntityID
WHERE		P.ModifiedDate <= '2008-01-01' AND E.CurrentFlag = 1



-- QUESTION 3
-- The plant supervisro asked for a report showing all products that have fallen below 25% 
-- of their safety stock levels. Produce a report showing 
-- the quantity needed, product name and location for all such products. 
-- Sort it by location alphabetically and then in descending order of quantity needed. 
SELECT		(SafetyStockLevel - Quantity) AS 'QUANTITY NEEDED', L.Name, PI.LocationID
FROM		Production.Location L
INNER JOIN	Production.ProductInventory PI
ON			L.LocationID = PI.LocationID
INNER JOIN	Production.Product 
ON			Product.ProductID = PI.ProductID
WHERE		Quantity < 0.25 * SafetyStockLevel
ORDER BY	LocationID, [QUANTITY NEEDED] DESC


-- QUESTION 4
-- What are the store names and mailing addresses of all stores selling our products with thier 
-- main office in the city of Bothell. Return Store Name, AddressLine 1, AddressLine 2, City, 
-- StateProvinceCode, Postal Code.
SELECT		S.Name, AddressLine1, AddressLine2, City, StateProvinceCode, PostalCode
FROM		Sales.Store S
INNER JOIN	Person.BusinessEntity BE
ON			S.BusinessEntityID = BE.BusinessEntityID
INNER JOIN	Person.BusinessEntityAddress BEA
ON			BE.BusinessEntityID = BEA.BusinessEntityID
INNER JOIN	Person.AddressType AT
ON			BEA.AddressTypeID = AT.AddressTypeID
INNER JOIN	Person.Address A
ON			BEA.AddressID = A.AddressID
INNER JOIN	Person.StateProvince SP
ON			A.StateProvinceID = SP.StateProvinceID
WHERE		AT.Name = 'MAIN OFFICE' AND City = 'BOTHELL'


-- QUESTION 5
-- The HR Department would like a list of all employees who currently work in the 
-- marketing department and were hired before 2002 or after 2004. Include their names, 
-- job titles, birthdates, marital status, and hire date.
SELECT		FirstName, LastName, JobTitle, BirthDate, MaritalStatus, HireDate
FROM		Person.Person P
INNER JOIN	HumanResources.Employee E
ON			E.BusinessEntityID = P.BusinessEntityID	
INNER JOIN	HumanResources.EmployeeDepartmentHistory EDH
ON			EDH.BusinessEntityID = E.BusinessEntityID
INNER JOIN	HumanResources.Department D
ON			EDH.DepartmentID = D.DepartmentID
WHERE		CurrentFlag = 1 AND D.Name = 'MARKETING' AND (DATEPART(YY, HireDate) < 2002 OR DATEPART(YY, HireDate) > 2004)

-- QUESTION 6
-- Some clothing items were mislabeled and management will need to inform customers. Prepare a list of 
-- affected customers and their phone numbers, product names and order dates. This isue applies to all 
-- orders for shorts placed online after July 8, 2008. 

SELECT		FirstName, LastName, PhoneNumber, PROD.Name, OrderDate
FROM		Sales.SalesOrderHeader SOH
INNER JOIN	Sales.Customer C
ON			SOH.CustomerID = C.CustomerID
INNER JOIN	Person.Person P
ON			C.PersonID = P.BusinessEntityID
INNER JOIN	Person.PersonPhone PP
ON			P.BusinessEntityID = PP.BusinessEntityID
INNER JOIN	Sales.SalesOrderDetail SOD 
ON			SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN	Production.Product PROD
ON			PROD.ProductID = SOD.ProductID
WHERE		PROD.Name LIKE '%SHORTS%' AND OnlineOrderFlag = 1 AND OrderDate > '2008-07-08'


--QUESTION 7
-- Create a report showing the number of employees currently assigned to each shift by department. Return
-- department name, shift name, and number of employees. 
SELECT		D.Name AS 'DEPARTMENT NAME', S.Name AS 'SHIFT NAME', COUNT(*) AS 'NUMBER OF EMPLOYEES'
FROM		HumanResources.EmployeeDepartmentHistory EDH
INNER JOIN	HumanResources.Shift S
ON			EDH.ShiftID = S.ShiftID
INNER JOIN	HumanResources.Department D
ON			EDH.DepartmentID = D.DepartmentID
WHERE		EndDate IS NULL
GROUP BY	S.Name, D.Name


-- QUESTION 8
-- Create a report showing the last time each current employee experienced a pay increase or decrease. 
-- Sort the report by last name and then by first name. 
SELECT		P.FirstName, P.LastName, MAX(RateChangeDate) AS 'LAST PAY CHANGE'
FROM		Person.Person P
INNER JOIN	HumanResources.Employee E
ON			P.BusinessEntityID = E.BusinessEntityID
INNER JOIN	HumanResources.EmployeePayHistory EPH
ON			E.BusinessEntityID = EPH.BusinessEntityID
WHERE		E.CurrentFlag = 1
GROUP BY	FirstName, LastName
ORDER BY	P.LastName, P.FirstName


-- QUESTION 9
-- Create a report showing the names and number of work orders for all products that have haad more
-- than 1100 work orders. 
SELECT		Name, COUNT(WorkOrderID) AS 'NUMBER OF WORK ORDERS'
FROM		Production.Product P
INNER JOIN	Production.WorkOrder WO
ON			P.ProductID = WO.ProductID
GROUP BY	NAME
HAVING		COUNT(*) > 1100
ORDER BY	Name
