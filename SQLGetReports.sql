USE ShopManagement;

GO

CREATE PROCEDURE GetCustomerOrdersGroupByCustomer
@DateBegin DATETIMEOFFSET = '0001-01-01 00:00:00 +00:00',
@DateEnd DATETIMEOFFSET = '9999-01-01 00:00:00 +00:00',
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT Customers.ID AS CustomerID, Customers.Name AS CustomerName, ISNULL(SUM(CustomerOrderItems.Price * CustomerOrderItems.Amount), 0) AS OrderedCost, ISNULL(SUM(CustomerOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS ReturnedCost, ISNULL(SUM(CustomerOrderItems.Price * CustomerOrderItems.Amount), 0) - ISNULL(SUM(CustomerOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS TotalCost, COUNT(DISTINCT CustomerOrders.ID) AS OrdersCount FROM CustomerOrders
LEFT JOIN Customers ON Customers.ID = CustomerOrders.CustomerID
LEFT JOIN CustomerOrderItems ON CustomerOrderItems.OrderID = CustomerOrders.ID
LEFT JOIN (SELECT OrderItemID, SUM(Amount) AS ReturnedAmount FROM CustomerReturnItems GROUP BY OrderItemID) AS ReturnedItemsAmount ON ReturnedItemsAmount.OrderItemID = CustomerOrderItems.ID
WHERE Date BETWEEN @DateBegin AND @DateEnd
GROUP BY Customers.ID, Customers.Name;
END;

GO

CREATE PROCEDURE GetCustomerOrdersGroupByEmployee
@DateBegin DATETIMEOFFSET = '0001-01-01 00:00:00 +00:00',
@DateEnd DATETIMEOFFSET = '9999-01-01 00:00:00 +00:00',
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT Employees.ID AS EmployeeID, Employees.Name AS EmployeeName, ISNULL(SUM(CustomerOrderItems.Price * CustomerOrderItems.Amount), 0) AS OrderedCost, ISNULL(SUM(CustomerOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS ReturnedCost, ISNULL(SUM(CustomerOrderItems.Price * CustomerOrderItems.Amount), 0) - ISNULL(SUM(CustomerOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS TotalCost, COUNT(DISTINCT CustomerOrders.ID) AS OrdersCount FROM CustomerOrders
LEFT JOIN Employees ON Employees.ID = CustomerOrders.EmployeeID
LEFT JOIN CustomerOrderItems ON CustomerOrderItems.OrderID = CustomerOrders.ID
LEFT JOIN (SELECT OrderItemID, SUM(Amount) AS ReturnedAmount FROM CustomerReturnItems GROUP BY OrderItemID) AS ReturnedItemsAmount ON ReturnedItemsAmount.OrderItemID = CustomerOrderItems.ID
WHERE Date BETWEEN @DateBegin AND @DateEnd
GROUP BY Employees.ID, Employees.Name;
END;

GO

CREATE PROCEDURE GetSupplierOrdersGroupBySupplier
@DateBegin DATETIMEOFFSET = '0001-01-01 00:00:00 +00:00',
@DateEnd DATETIMEOFFSET = '9999-01-01 00:00:00 +00:00',
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT Suppliers.ID AS SupplierID, Suppliers.Name AS SupplierName, ISNULL(SUM(SupplierOrderItems.Price * SupplierOrderItems.Amount), 0) AS OrderedCost, ISNULL(SUM(SupplierOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS ReturnedCost, ISNULL(SUM(SupplierOrderItems.Price * SupplierOrderItems.Amount), 0) - ISNULL(SUM(SupplierOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS TotalCost, COUNT(DISTINCT SupplierOrders.ID) AS OrdersCount FROM SupplierOrders
LEFT JOIN Suppliers ON Suppliers.ID = SupplierOrders.SupplierID
LEFT JOIN SupplierOrderItems ON SupplierOrderItems.OrderID = SupplierOrders.ID
LEFT JOIN (SELECT OrderItemID, SUM(Amount) AS ReturnedAmount FROM SupplierReturnItems GROUP BY OrderItemID) AS ReturnedItemsAmount ON ReturnedItemsAmount.OrderItemID = SupplierOrderItems.ID
WHERE Date BETWEEN @DateBegin AND @DateEnd
GROUP BY Suppliers.ID, Suppliers.Name;
END;

GO

CREATE PROCEDURE GetSupplierOrdersGroupByEmployee
@DateBegin DATETIMEOFFSET = '0001-01-01 00:00:00 +00:00',
@DateEnd DATETIMEOFFSET = '9999-01-01 00:00:00 +00:00',
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT Employees.ID AS EmployeeID, Employees.Name AS EmployeeName, ISNULL(SUM(SupplierOrderItems.Price * SupplierOrderItems.Amount), 0) AS OrderedCost, ISNULL(SUM(SupplierOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS ReturnedCost, ISNULL(SUM(SupplierOrderItems.Price * SupplierOrderItems.Amount), 0) - ISNULL(SUM(SupplierOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS TotalCost, COUNT(DISTINCT SupplierOrders.ID) AS OrdersCount FROM SupplierOrders
LEFT JOIN Employees ON Employees.ID = SupplierOrders.EmployeeID
LEFT JOIN SupplierOrderItems ON SupplierOrderItems.OrderID = SupplierOrders.ID
LEFT JOIN (SELECT OrderItemID, SUM(Amount) AS ReturnedAmount FROM SupplierReturnItems GROUP BY OrderItemID) AS ReturnedItemsAmount ON ReturnedItemsAmount.OrderItemID = SupplierOrderItems.ID
WHERE Date BETWEEN @DateBegin AND @DateEnd
GROUP BY Employees.ID, Employees.Name;
END;