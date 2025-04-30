USE ShopManagement;

GO

CREATE VIEW CustomerOrdersGroupByCustomer AS
SELECT Customers.ID AS CustomerID, Customers.Name AS CustomerName, ISNULL(SUM(CustomerOrderItems.Price * CustomerOrderItems.Amount), 0) AS OrderedCost, ISNULL(SUM(CustomerOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS ReturnedCost, ISNULL(SUM(CustomerOrderItems.Price * CustomerOrderItems.Amount), 0) - ISNULL(SUM(CustomerOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS TotalCost, COUNT(DISTINCT CustomerOrders.ID) AS OrdersCount  FROM CustomerOrders
LEFT JOIN Customers ON Customers.ID = CustomerOrders.CustomerID
LEFT JOIN CustomerOrderItems ON CustomerOrderItems.OrderID = CustomerOrders.ID
LEFT JOIN (SELECT OrderItemID, SUM(Amount) AS ReturnedAmount FROM CustomerReturnItems GROUP BY OrderItemID) AS ReturnedItemsAmount ON ReturnedItemsAmount.OrderItemID = CustomerOrderItems.ID
GROUP BY Customers.ID, Customers.Name;

GO

CREATE VIEW CustomerOrdersGroupByEmployee AS
SELECT Employees.ID AS EmployeeID, Employees.Name AS EmployeeName, ISNULL(SUM(CustomerOrderItems.Price * CustomerOrderItems.Amount), 0) AS OrderedCost, ISNULL(SUM(CustomerOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS ReturnedCost, ISNULL(SUM(CustomerOrderItems.Price * CustomerOrderItems.Amount), 0) - ISNULL(SUM(CustomerOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS TotalCost, COUNT(DISTINCT CustomerOrders.ID) AS OrdersCount FROM CustomerOrders
LEFT JOIN Employees ON Employees.ID = CustomerOrders.EmployeeID
LEFT JOIN CustomerOrderItems ON CustomerOrderItems.OrderID = CustomerOrders.ID
LEFT JOIN (SELECT OrderItemID, SUM(Amount) AS ReturnedAmount FROM CustomerReturnItems GROUP BY OrderItemID) AS ReturnedItemsAmount ON ReturnedItemsAmount.OrderItemID = CustomerOrderItems.ID
GROUP BY Employees.ID, Employees.Name;

GO

CREATE VIEW SupplierOrdersGroupBySupplier AS
SELECT Suppliers.ID AS SupplierID, Suppliers.Name AS SupplierName, ISNULL(SUM(SupplierOrderItems.Price * SupplierOrderItems.Amount), 0) AS OrderedCost, ISNULL(SUM(SupplierOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS ReturnedCost, ISNULL(SUM(SupplierOrderItems.Price * SupplierOrderItems.Amount), 0) - ISNULL(SUM(SupplierOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS TotalCost, COUNT(DISTINCT SupplierOrders.ID) AS OrdersCount  FROM SupplierOrders
LEFT JOIN Suppliers ON Suppliers.ID = SupplierOrders.SupplierID
LEFT JOIN SupplierOrderItems ON SupplierOrderItems.OrderID = SupplierOrders.ID
LEFT JOIN (SELECT OrderItemID, SUM(Amount) AS ReturnedAmount FROM SupplierReturnItems GROUP BY OrderItemID) AS ReturnedItemsAmount ON ReturnedItemsAmount.OrderItemID = SupplierOrderItems.ID
GROUP BY Suppliers.ID, Suppliers.Name;
GO

CREATE VIEW SupplierOrdersGroupByEmployee AS
SELECT Employees.ID AS EmployeeID, Employees.Name AS EmployeeName, ISNULL(SUM(SupplierOrderItems.Price * SupplierOrderItems.Amount), 0) AS OrderedCost, ISNULL(SUM(SupplierOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS ReturnedCost, ISNULL(SUM(SupplierOrderItems.Price * SupplierOrderItems.Amount), 0) - ISNULL(SUM(SupplierOrderItems.Price * ReturnedItemsAmount.ReturnedAmount), 0) AS TotalCost, COUNT(DISTINCT SupplierOrders.ID) AS OrdersCount FROM SupplierOrders
LEFT JOIN Employees ON Employees.ID = SupplierOrders.EmployeeID
LEFT JOIN SupplierOrderItems ON SupplierOrderItems.OrderID = SupplierOrders.ID
LEFT JOIN (SELECT OrderItemID, SUM(Amount) AS ReturnedAmount FROM SupplierReturnItems GROUP BY OrderItemID) AS ReturnedItemsAmount ON ReturnedItemsAmount.OrderItemID = SupplierOrderItems.ID
GROUP BY Employees.ID, Employees.Name;