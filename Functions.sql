------------------------------------
-- SCALAR FUNCTIONS
------------------------------------
DROP FUNCTION IF EXISTS dbo.UnitPricePlusOne
GO

CREATE FUNCTION UnitPricePlusOne
(
    @Amount MONEY
)
RETURNS MONEY
AS
BEGIN

    RETURN @Amount + 1

END
GO

SELECT
	UnitPrice
   ,dbo.UnitPricePlusOne(UnitPrice)
FROM Products

DECLARE @myValue MONEY
EXEC @myValue = dbo.UnitPricePlusOne @Amount = 1
SELECT @myValue
GO 

DROP FUNCTION IF EXISTS dbo.NumberOfOrders
GO

CREATE FUNCTION NumberOfOrders(@EmployeeNumber INT)
RETURNS INT
AS 
BEGIN
	DECLARE @NumberOfOrders INT
	SELECT @NumberOfOrders = COUNT(*)
	FROM Orders
	WHERE EmployeeID = @EmployeeNumber
	RETURN @NumberOfOrders
END
GO

SELECT DISTINCT EmployeeID, dbo.NumberOfOrders(EmployeeID) AS OrdNum
FROM Orders
GO

------------------------------------
-- INLINE TABLE FUNCTIONS
------------------------------------

DROP FUNCTION IF EXISTS dbo.OrderList
GO

CREATE FUNCTION OrderList(@EmployeeNumber INT)
RETURNS TABLE AS RETURN
(
    SELECT *
	FROM Orders
	WHERE EmployeeID = @EmployeeNumber
)
GO

-- SELECT OrderList(2) WRONG - WE CAN'T RETURN TABLE IN SELECT
SELECT *
FROM dbo.OrderList(2)
GO

------------------------------------
-- MULTI-STATEMENT TABLE FUNCTIONS
------------------------------------
DROP FUNCTION IF EXISTS GetOrderStatus
GO
CREATE FUNCTION GetOrderStatus(@OrderDate DATETIME)
RETURNS @OrderByYear TABLE 
(
	EmployeeID INT,
	Status VARCHAR(30),
	StatusCount INT
)
AS
BEGIN
	WITH OrderStatus
	AS
    (SELECT OrderID, EmployeeID, CASE
									WHEN ShippedDate > RequiredDate THEN 'Delayed'
									WHEN (ShippedDate < RequiredDate) AND DATEDIFF(DAY, ShippedDate, RequiredDate) > 14 THEN 'Too early'
									ELSE 'Timely'
								END AS 'Status'

	FROM Orders
	WHERE YEAR(OrderDate) = YEAR(@OrderDate)
	)
	INSERT INTO @OrderByYear
	SELECT EmployeeID
		,  Status
		,  Count(*)
	FROM OrderStatus
	GROUP BY EmployeeID
		,	 Status 
	RETURN
END
GO

SELECT *
FROM dbo.GetOrderStatus('1997-12-12')