USE ShopManagement;
GO
CREATE FUNCTION SignIn(@Login NVARCHAR(50), @Password NVARCHAR(50))
RETURNS NVARCHAR(50)
BEGIN
RETURN (SELECT TOP 1 Position FROM Employees WHERE UserLogin = @Login AND UserPassword = HASHBYTES('SHA2_512', @Password));
END

GO

CREATE PROCEDURE CreateEmployee
@Name NVARCHAR(100),
@Age INT = NULL,
@Gender NCHAR = NULL,
@PhoneNumber NVARCHAR(15) = NULL,
@Email NVARCHAR(100) = NULL,
@Experience INT = NULL,
@Position NVARCHAR(50) = NULL,
@Salary INT = NULL,
@UserLogin NVARCHAR(50) = NULL,
@UserPassword NVARCHAR(50) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF @Position = 'SYSTEM_ADMIN'
   THROW 50000, 'INVALID_POSITION_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'SYSTEM_ADMIN')
   INSERT INTO Employees (Name, Age, Gender, PhoneNumber, Email, Experience, Position, Salary, UserLogin, UserPassword) VALUES (@Name, @Age, @Gender, @PhoneNumber, @Email, @Experience, @Position, @Salary, @UserLogin, HASHBYTES('SHA2_512', @UserPassword));
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateCustomer
@Name NVARCHAR(100),
@PhoneNumber NVARCHAR(15) = NULL,
@Email NVARCHAR(100) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   INSERT INTO Customers (Name, PhoneNumber, Email) VALUES (@Name, @PhoneNumber, @Email);
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateProduct
@Name NVARCHAR(100),
@Price NUMERIC(10, 2) = 0,
@Amount INT = 0,
@Description NVARCHAR(100) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   INSERT INTO Products (Name, Price, Amount, Description) VALUES (@Name, @Price, @Amount, @Description);
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateSupplier
@Name NVARCHAR(100),
@PhoneNumber NVARCHAR(15) = NULL,
@Email NVARCHAR(100) = NULL,
@AccountNumber NVARCHAR(20) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   INSERT INTO Suppliers (Name, PhoneNumber, Email, AccountNumber) VALUES (@Name, @PhoneNumber, @Email, @AccountNumber);
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateCustomerOrder
@CustomerID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   INSERT INTO CustomerOrders (CustomerID, EmployeeID, Date) VALUES (@CustomerID, (SELECT ID FROM Employees WHERE UserLogin = @AdminLogin), SYSDATETIMEOFFSET());
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateCustomerOrderItem
@OrderID INT,
@ProductID INT,
@Amount INT = 1,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER', 'SHOP_CASHIER'))
   BEGIN
   SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
   BEGIN TRANSACTION;
   INSERT INTO CustomerOrderItems (OrderID, ProductID, Amount, Price) VALUES (@OrderID, @ProductID, @Amount, (SELECT TOP 1 Price FROM Products WHERE ID = @ProductID));
   COMMIT;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateCustomerReturnItem
@OrderItemID INT,
@Amount INT,
@Reason VARCHAR(150) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF @Amount < 1
   THROW 50000, 'INVALID_DATA_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN', 'SHOP_MANAGER'))
   BEGIN
   SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
   BEGIN TRANSACTION;
   INSERT INTO CustomerReturnItems (OrderItemID, Amount, EmployeeID, Reason, Date) VALUES (@OrderItemID, @Amount, (SELECT ID FROM Employees WHERE UserLogin = @AdminLogin), @Reason, SYSDATETIMEOFFSET());
   COMMIT;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateSupplierOrder
@SupplierID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   INSERT INTO SupplierOrders (SupplierID, EmployeeID, Date) VALUES (@SupplierID, (SELECT ID FROM Employees WHERE UserLogin = @AdminLogin), SYSDATETIMEOFFSET());
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END;

GO

CREATE PROCEDURE CreateSupplierOrderItem
@OrderID INT,
@ProductID INT,
@Amount INT = 1,
@Price NUMERIC(10, 2) = 0,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   BEGIN
   SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
   BEGIN TRANSACTION;
   INSERT INTO SupplierOrderItems (OrderID, ProductID, Amount, Price) VALUES (@OrderID, @ProductID, @Amount, @Price);
   COMMIT;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END;

GO

CREATE PROCEDURE CreateSupplierReturnItem
@OrderItemID INT,
@Amount INT,
@Reason VARCHAR(150),
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF @Amount < 1
   THROW 50000, 'INVALID_DATA_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   BEGIN
   SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
   BEGIN TRANSACTION;
   INSERT INTO SupplierReturnItems(OrderItemID, Amount, EmployeeID, Reason, Date) VALUES (@OrderItemID, @Amount, (SELECT ID FROM Employees WHERE UserLogin = @AdminLogin), @Reason, SYSDATETIMEOFFSET());
   COMMIT;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END;
GO