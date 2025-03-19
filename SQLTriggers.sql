USE ShopManagement;
GO
CREATE TRIGGER TriggerOnInsertCustomerOrderItem ON CustomerOrderItems
INSTEAD OF INSERT
AS BEGIN
IF EXISTS(SELECT 1 FROM Inserted
   JOIN Products ON Products.ID = Inserted.ProductID
   GROUP BY Inserted.ProductID
   HAVING SUM(Inserted.Amount) > MIN(Products.Amount))
   THROW 50000, 'NOT_ENOUGH_PRODUCT', 255;
UPDATE Products
SET Amount = Products.Amount - InsertedGroupBy.AmountSum
FROM Products
JOIN (SELECT ProductID, SUM(Amount) AS AmountSum FROM Inserted GROUP BY ProductID) AS InsertedGroupBy
   ON InsertedGroupBy.ProductID = Products.ID;
INSERT INTO CustomerOrderItems (OrderID, ProductID, Amount, Price) (SELECT OrderID, ProductID, Amount, Price FROM Inserted);
END

GO

CREATE TRIGGER TriggerOnInsertCustomerReturnItem ON CustomerReturnItems
INSTEAD OF INSERT
AS BEGIN
IF EXISTS(SELECT 1 FROM Inserted
   JOIN (SELECT OrderItemID, SUM(Amount) AS AlreadyReturned FROM CustomerReturnItems GROUP BY OrderItemID) AS ReturnItems 
   ON ReturnItems.OrderItemID = Inserted.OrderItemID
   GROUP BY Inserted.OrderItemID
   HAVING ((SUM(Inserted.Amount) + MAX(AlreadyReturned)) > (SELECT Amount FROM CustomerOrderItems WHERE ID = Inserted.OrderItemID)))
   THROW 50000, 'AMOUNT_TOO_BIG', 255;
UPDATE Products
SET Amount = Products.Amount + ProductSum.AmountSum
FROM Products 
JOIN (SELECT CustomerOrderItems.ProductID, SUM(Inserted.Amount) AS AmountSum
   FROM Inserted JOIN CustomerOrderItems ON CustomerOrderItems.ID = Inserted.OrderItemID
   GROUP BY CustomerOrderItems.ProductID) AS ProductSum ON ProductSum.ProductID = Products.ID;
INSERT INTO CustomerReturnItems (OrderItemID, Amount, EmployeeID, Reason, Date) (SELECT OrderItemID, Amount, EmployeeID, Reason, Date FROM Inserted);
END

GO

CREATE TRIGGER TriggerOnInsertSupplierOrderItem ON SupplierOrderItems
INSTEAD OF INSERT
AS BEGIN
UPDATE Products
SET Amount = Products.Amount + InsertedGroupBy.AmountSum
FROM Products
JOIN (SELECT ProductID, SUM(Amount) AS AmountSum FROM Inserted GROUP BY ProductID) AS InsertedGroupBy
   ON InsertedGroupBy.ProductID = Products.ID;
INSERT INTO SupplierOrderItems (OrderID, ProductID, Amount, Price) (SELECT OrderID, ProductID, Amount, Price FROM Inserted);
END

GO

CREATE TRIGGER TriggerOnInsertSupplierReturnItem ON SupplierReturnItems
INSTEAD OF INSERT
AS BEGIN
IF EXISTS(SELECT 1 FROM Inserted
   JOIN Products ON Products.ID = (SELECT ProductID FROM SupplierOrderItems WHERE ID = Inserted.OrderItemID)
   GROUP BY Products.ID
   HAVING SUM(Inserted.Amount) > MIN(Products.Amount))
   THROW 50000, 'NOT_ENOUGH_PRODUCT', 255;
IF EXISTS(SELECT 1 FROM Inserted
   JOIN (SELECT OrderItemID, SUM(Amount) AS AlreadyReturned FROM SupplierReturnItems GROUP BY OrderItemID) AS ReturnItems 
   ON ReturnItems.OrderItemID = Inserted.OrderItemID
   GROUP BY Inserted.OrderItemID
   HAVING ((SUM(Inserted.Amount) + MAX(AlreadyReturned)) > (SELECT Amount FROM SupplierOrderItems WHERE ID = Inserted.OrderItemID)))
   THROW 50000, 'AMOUNT_TOO_BIG', 255;
UPDATE Products
SET Amount = Products.Amount - InsertedGroupBy.AmountSum
FROM Products
JOIN (SELECT ProductID, SUM(Inserted.Amount) AS AmountSum
   FROM Inserted JOIN SupplierOrderItems ON SupplierOrderItems.ID = Inserted.OrderItemID
   GROUP BY ProductID) AS InsertedGroupBy
   ON InsertedGroupBy.ProductID = Products.ID;
INSERT INTO SupplierReturnItems (OrderItemID, Amount, EmployeeID, Reason, Date) (SELECT OrderItemID, Amount, EmployeeID, Reason, Date FROM Inserted);
END

GO

CREATE TRIGGER TriggerOnDeleteCustomerOrderItem ON CustomerOrderItems
AFTER DELETE
AS BEGIN
UPDATE Products
SET Amount = Products.Amount + OrderProducts.AmountSum - OrderProducts.AmountReturnedSum
FROM Products
JOIN (SELECT ID, ProductID, SUM(Amount) AS AmountSum, SUM(AmountReturned) AS AmountReturnedSum FROM Deleted 
   JOIN (SELECT OrderItemID, SUM(Amount) AS AmountReturned FROM CustomerReturnItems GROUP BY OrderItemID) AS ReturnedGroupBy
   ON ReturnedGroupBy.OrderItemID = Deleted.ID GROUP BY ProductID) AS OrderProducts
   ON OrderProducts.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnDeleteCustomerReturnItem ON CustomerReturnItems
AFTER DELETE
AS BEGIN
IF EXISTS(SELECT 1 FROM Deleted
   JOIN Products ON Products.ID = (SELECT ProductID FROM CustomerOrderItems WHERE ID = Deleted.OrderItemID)
   GROUP BY Products.ID
   HAVING SUM(Deleted.Amount) > MIN(Products.Amount))
   THROW 50000, 'NOT_ENOUGH_PRODUCT', 255;
UPDATE Products
SET Amount = Products.Amount - DeletedGroupBy.AmountSum
FROM Products
JOIN (SELECT CustomerOrderItems.ProductID, SUM(Deleted.Amount) AS AmountSum FROM Deleted
   JOIN CustomerOrderItems ON CustomerOrderItems.ID = Deleted.OrderItemID
   GROUP BY CustomerOrderItems.ProductID) AS DeletedGroupBy
   ON DeletedGroupBy.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnDeleteSupplierOrderItem ON SupplierOrderItems
AFTER DELETE
AS BEGIN
IF EXISTS(SELECT 1 FROM Deleted
   JOIN Products ON Products.ID = Deleted.ProductID
   JOIN (SELECT OrderItemID, SUM(Amount) AS AmountReturned FROM SupplierReturnItems GROUP BY OrderItemID) AS ReturnedGroupBy ON ReturnedGroupBy.OrderItemID = Deleted.ID
   GROUP BY Products.ID
   HAVING (SUM(Deleted.Amount) - SUM(AmountReturned)) > MIN(Products.Amount))
   THROW 50000, 'NOT_ENOUGH_PRODUCT', 255;

UPDATE Products
SET Amount = Products.Amount - OrderProducts.AmountSum + OrderProducts.AmountReturnedSum
FROM Products
JOIN (SELECT ID, ProductID, SUM(Amount) AS AmountSum, SUM(AmountReturned) AS AmountReturnedSum FROM Deleted
   JOIN (SELECT OrderItemID, SUM(Amount) AS AmountReturned FROM SupplierReturnItems GROUP BY OrderItemID) AS ReturnedGroupBy
   ON ReturnedGroupBy.OrderItemID = Deleted.ID GROUP BY ProductID) AS OrderProducts
   ON OrderProducts.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnDeleteSupplierReturnItem ON SupplierReturnItems
AFTER DELETE
AS BEGIN
UPDATE Products
SET Amount = Products.Amount + DeletedGroupBy.AmountSum
FROM Products
JOIN (SELECT SupplierOrderItems.ProductID, SUM(Deleted.Amount) AS AmountSum FROM Deleted
   JOIN SupplierOrderItems ON SupplierOrderItems.ID = Deleted.OrderItemID
   GROUP BY SupplierOrderItems.ProductID) AS DeletedGroupBy
   ON DeletedGroupBy.ProductID = Products.ID;
END