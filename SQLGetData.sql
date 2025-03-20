USE ShopManagement;
GO
CREATE PROCEDURE GetEmployees
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT Name, Age, Gender, PhoneNumber, Email, Experience, Position, UserLogin, UserPassword FROM Employees;
END

GO

CREATE PROCEDURE GetCustomers
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT Name, PhoneNumber, Email FROM Customers;
END

GO

CREATE PROCEDURE GetProducts
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT Name, Price, Amount, Description FROM Products;
END

GO

CREATE PROCEDURE GetSuppliers
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT Name, PhoneNumber, Email, AccountNumber FROM Suppliers;
END

GO

CREATE PROCEDURE GetCustomerOrders
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT CustomerID, EmployeeID, Date FROM CustomerOrders;
END

GO

CREATE PROCEDURE GetCustomerOrderItems
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT OrderID, ProductID, Amount, Price FROM CustomerOrderItems;
END

GO

CREATE PROCEDURE GetCustomerReturns
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT OrderItemID, Amount, EmployeeID, Reason, Date FROM CustomerReturnItems;
END

GO

CREATE PROCEDURE GetSupplierOrders
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT SupplierID, EmployeeID, Date FROM SupplierOrders;
END

GO

CREATE PROCEDURE GetSupplierOrderItems
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT OrderID, ProductID, Amount, Price FROM SupplierOrderItems;
END

GO

CREATE PROCEDURE GetSupplierReturnItems
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT OrderItemID, Amount, Reason, EmployeeID, Date FROM SupplierReturnItems;
END