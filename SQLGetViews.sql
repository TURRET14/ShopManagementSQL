USE ShopManagement;

GO

CREATE PROCEDURE GetCustomerOrdersGroupByCustomerView
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT CustomerID, CustomerName, OrderedCost, ReturnedCost, TotalCost, OrdersCount FROM CustomerOrdersGroupByCustomer;
END;

GO

CREATE PROCEDURE GetCustomerOrdersGroupByEmployeeView
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT EmployeeID, EmployeeName, OrderedCost, ReturnedCost, TotalCost, OrdersCount FROM CustomerOrdersGroupByEmployee;
END;

GO

CREATE PROCEDURE GetSupplierOrdersGroupBySupplierView
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT SupplierID, SupplierName, OrderedCost, ReturnedCost, TotalCost, OrdersCount FROM SupplierOrdersGroupBySupplier;
END;

GO

CREATE PROCEDURE GetSupplierOrdersGroupByEmployeeView
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) NOT IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
SELECT EmployeeID, EmployeeName, OrderedCost, ReturnedCost, TotalCost, OrdersCount FROM SupplierOrdersGroupByEmployee;
END;