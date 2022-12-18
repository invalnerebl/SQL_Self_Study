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