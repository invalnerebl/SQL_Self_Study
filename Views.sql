DROP VIEW IF EXISTS TheWorstEmployees
GO

CREATE VIEW TheWorstEmployees
AS
SELECT TOP 5 PERCENT E.LastName, E.FirstName, COUNT(O.OrderID) AS NumberOfOrders
FROM Orders O JOIN Employees E ON O.EmployeeID = E.EmployeeID
GROUP BY E.LastName, E.FirstName
ORDER BY COUNT(O.OrderID) ASC;
GO

SELECT * FROM TheWorstEmployees