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