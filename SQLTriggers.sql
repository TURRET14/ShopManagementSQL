USE ShopManagement;
GO
CREATE TRIGGER TriggerOnInsertCustomerOrderDetail ON CustomerOrderDetails
AFTER INSERT
AS BEGIN
IF EXISTS(SELECT 1 FROM Inserted
   JOIN Products ON Products.ID = Inserted.ProductID
   GROUP BY Inserted.ProductID
   HAVING SUM(Inserted.Amount) > MIN(Products.Amount))
   THROW 50000, 'NOT_ENOUGH_PRODUCT', 255;
UPDATE Products
SET Amount = Products.Amount - InsertedGroupBy.AmountSum
FROM Products
JOIN (SELECT ProductID, SUM(Amount) AS AmountSum FROM Inserted GROUP BY ProductID) AS InsertedGroupBy ON InsertedGroupBy.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnInsertCustomerReturn ON CustomerReturns
AFTER INSERT
AS BEGIN
IF EXISTS(SELECT 1 FROM Inserted 
   JOIN CustomerOrderDetails ON CustomerOrderDetails.ID = Inserted.CustomerOrderDetailID 
   GROUP BY Inserted.CustomerOrderDetailID
   HAVING SUM(Inserted.Amount) + MAX(CustomerOrderDetails.ReturnedAmount) > MIN(CustomerOrderDetails.Amount))
   THROW 50000, 'AMOUNT_TOO_BIG', 255;
UPDATE CustomerOrderDetails
SET ReturnedAmount = CustomerOrderDetails.ReturnedAmount + InsertedGroupBy.AmountSum
FROM CustomerOrderDetails
JOIN (SELECT CustomerOrderDetailID, SUM(Amount) AS AmountSum FROM Inserted GROUP BY CustomerOrderDetailID) AS InsertedGroupBy ON InsertedGroupBy.CustomerOrderDetailID = CustomerOrderDetails.ID;
UPDATE Products
SET Amount = Products.Amount + ProductSum.AmountSum
FROM Products 
JOIN (SELECT CustomerOrderDetails.ProductID, SUM(Inserted.Amount) AS AmountSum
   FROM Inserted JOIN CustomerOrderDetails ON CustomerOrderDetails.ID = Inserted.CustomerOrderDetailID
   GROUP BY CustomerOrderDetails.ProductID) AS ProductSum ON ProductSum.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnInsertSupplierOrderDetail ON SupplierOrderDetails
AFTER INSERT
AS BEGIN
UPDATE Products
SET Amount = Products.Amount + InsertedGroupBy.AmountSum
FROM Products
JOIN (SELECT ProductID, SUM(Amount) AS AmountSum FROM Inserted GROUP BY ProductID) AS InsertedGroupBy ON InsertedGroupBy.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnInsertSupplierReturn ON SupplierReturns
AFTER INSERT
AS BEGIN
IF EXISTS(SELECT 1 FROM Inserted
   JOIN Products ON Products.ID = (SELECT ProductID FROM SupplierOrderDetails WHERE ID = Inserted.SupplierOrderDetailID)
   GROUP BY Products.ID
   HAVING SUM(Inserted.Amount) > MIN(Products.Amount))
   THROW 50000, 'NOT_ENOUGH_PRODUCT', 255;
IF EXISTS(SELECT 1 FROM Inserted 
   JOIN SupplierOrderDetails ON SupplierOrderDetails.ID = Inserted.SupplierOrderDetailID 
   GROUP BY SupplierOrderDetails.ID
   HAVING SUM(Inserted.Amount) + MAX(SupplierOrderDetails.ReturnedAmount) > MIN(SupplierOrderDetails.Amount))
   THROW 50000, 'AMOUNT_TOO_BIG', 255;
UPDATE SupplierOrderDetails
SET ReturnedAmount = SupplierOrderDetails.ReturnedAmount + InsertedGroupBy.AmountSum 
FROM SupplierOrderDetails
JOIN (SELECT SupplierOrderDetailID, SUM(Amount) AS AmountSum FROM Inserted GROUP BY SupplierOrderDetailID) AS InsertedGroupBy ON InsertedGroupBy.SupplierOrderDetailID = SupplierOrderDetails.ID;
UPDATE Products
SET Amount = Products.Amount - InsertedGroupBy.AmountSum
FROM Products
JOIN (SELECT ProductID, SUM(Inserted.Amount) AS AmountSum
   FROM Inserted JOIN SupplierOrderDetails ON SupplierOrderDetails.ID = Inserted.SupplierOrderDetailID
   GROUP BY ProductID) AS InsertedGroupBy
   ON InsertedGroupBy.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnDeleteCustomerOrderDetail ON CustomerOrderDetails
AFTER DELETE
AS BEGIN
UPDATE Products
SET Amount = Products.Amount + DeletedGroupBy.AmountSum - DeletedGroupBy.ReturnedSum
FROM Products
JOIN (SELECT ProductID, SUM(Amount) AS AmountSum, SUM(ReturnedAmount) AS ReturnedSum FROM Deleted GROUP BY ProductID) AS DeletedGroupBy ON DeletedGroupBy.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnDeleteCustomerReturn ON CustomerReturns
AFTER DELETE
AS BEGIN
IF EXISTS(SELECT 1 FROM Deleted
   JOIN Products ON Products.ID = (SELECT ProductID FROM CustomerOrderDetails WHERE ID = Deleted.CustomerOrderDetailID)
   GROUP BY Products.ID
   HAVING SUM(Deleted.Amount) > MIN(Products.Amount))
   THROW 50000, 'NOT_ENOUGH_PRODUCT', 255;
UPDATE CustomerOrderDetails
SET ReturnedAmount = CustomerOrderDetails.ReturnedAmount - DeletedGroupBy.AmountSum
FROM CustomerOrderDetails
JOIN (SELECT CustomerOrderDetailID, SUM(Amount) AS AmountSum FROM Deleted GROUP BY CustomerOrderDetailID) AS DeletedGroupBy ON DeletedGroupBy.CustomerOrderDetailID = CustomerOrderDetails.ID;
UPDATE Products
SET Amount = Products.Amount - DeletedGroupBy.AmountSum
FROM Products
JOIN (SELECT CustomerOrderDetails.ProductID, SUM(Deleted.Amount) AS AmountSum FROM Deleted
   JOIN CustomerOrderDetails ON CustomerOrderDetails.ID = Deleted.CustomerOrderDetailID
   GROUP BY CustomerOrderDetails.ProductID) AS DeletedGroupBy
   ON DeletedGroupBy.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnDeleteSupplierOrderDetail ON SupplierOrderDetails
AFTER DELETE
AS BEGIN
IF EXISTS(SELECT 1 FROM Deleted
   JOIN Products ON Products.ID = Deleted.ProductID
   GROUP BY Products.ID
   HAVING SUM(Deleted.Amount) > MIN(Products.Amount))
   THROW 50000, 'NOT_ENOUGH_PRODUCT', 255;
UPDATE Products
SET Amount = Products.Amount - DeletedGroupBy.AmountSum + DeletedGroupBy.ReturnedSum
FROM Products
JOIN (SELECT ProductID, SUM(Amount) AS AmountSum, SUM(ReturnedAmount) AS ReturnedSum FROM Deleted GROUP BY ProductID) AS DeletedGroupBy
ON DeletedGroupBy.ProductID = Products.ID;
END

GO

CREATE TRIGGER TriggerOnDeleteSupplierReturn ON SupplierReturns
AFTER DELETE
AS BEGIN
UPDATE SupplierOrderDetails
SET ReturnedAmount = SupplierOrderDetails.ReturnedAmount - DeletedGroupBy.AmountSum
FROM SupplierOrderDetails
JOIN (SELECT SupplierOrderDetailID, SUM(Amount) AS AmountSum FROM Deleted GROUP BY SupplierOrderDetailID) AS DeletedGroupBy
ON DeletedGroupBy.SupplierOrderDetailID = SupplierOrderDetails.ID;
UPDATE Products
SET Amount = Products.Amount + DeletedGroupBy.AmountSum
FROM Products
JOIN (SELECT SupplierOrderDetails.ProductID, SUM(Deleted.Amount) AS AmountSum FROM Deleted
   JOIN SupplierOrderDetails ON SupplierOrderDetails.ID = Deleted.SupplierOrderDetailID
   GROUP BY SupplierOrderDetails.ProductID) AS DeletedGroupBy
   ON DeletedGroupBy.ProductID = Products.ID;
END