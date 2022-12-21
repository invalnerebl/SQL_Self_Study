------------------------------------
-- SCALAR FUNCTIONS
------------------------------------
DROP FUNCTION IF EXISTS dbo.UnitPricePlusOne
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

------------------------------------
-- INLINE TABLE FUNCTIONS
------------------------------------

DROP FUNCTION IF EXISTS dbo.OrderList
CREATE FUNCTION OrderList(@EmployeeNumber INT)
RETURNS TABLE AS RETURN
(
    SELECT *
	FROM Orders
	WHERE EmployeeID = @EmployeeNumber
)

-- SELECT OrderList(2) WRONG - WE CAN'T RETURN TABLE IN SELECT
SELECT *
FROM dbo.OrderList(2)

------------------------------------
-- MULTI-STATEMENT TABLE FUNCTIONS
------------------------------------

CREATE FUNCTION [dbo].[FunctionName]
(
    @param1 int,
    @param2 char(5)
)
RETURNS @returntable TABLE 
(
	[c1] int,
	[c2] char(5)
)
AS
BEGIN
    INSERT @returntable
    SELECT @param1, @param2
    RETURN 
END
