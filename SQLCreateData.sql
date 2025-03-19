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
@UserLogin NVARCHAR(50) = NULL,
@UserPassword NVARCHAR(50) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF @Position = 'Администратор'
   THROW 50000, 'INVALID_POSITION_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   INSERT INTO Employees (Name, Age, Gender, PhoneNumber, Email, Experience, Position, UserLogin, UserPassword) VALUES (@Name, @Age, @Gender, @PhoneNumber, @Email, @Experience, @Position, @UserLogin, HASHBYTES('SHA2_512', @UserPassword));
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
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор', 'Менеджер', 'Кассир'))
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
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор'))
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
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор'))
   INSERT INTO Suppliers (Name, PhoneNumber, Email, AccountNumber) VALUES (@Name, @PhoneNumber, @Email, @AccountNumber);
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateCustomerOrder
@CustomerID INT,
@EmployeeID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор', 'Менеджер', 'Кассир'))
   INSERT INTO CustomerOrders (CustomerID, EmployeeID, Date) VALUES (@CustomerID, @EmployeeID, GETDATE());
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
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор', 'Менеджер', 'Кассир'))
   INSERT INTO CustomerOrderItems (OrderID, ProductID, Amount, Price) VALUES (@OrderID, @ProductID, @Amount, (SELECT TOP 1 Price FROM Products WHERE ID = @ProductID));
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateCustomerReturnItem
@OrderItemID INT,
@Amount INT,
@EmployeeID INT,
@Reason VARCHAR(150) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор', 'Менеджер'))
   INSERT INTO CustomerReturnItems (OrderItemID, Amount, EmployeeID, Reason, Date) VALUES (@OrderItemID, @Amount, @EmployeeID, @Reason, GETDATE());
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE CreateSupplierOrder
@SupplierID INT,
@EmployeeID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор'))
   INSERT INTO SupplierOrders (SupplierID, EmployeeID, Date) VALUES (@SupplierID, @EmployeeID, GETDATE());
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
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор'))
   INSERT INTO SupplierOrderItems (OrderID, ProductID, Amount, Price) VALUES (@OrderID, @ProductID, @Amount, @Price);
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END;

GO

CREATE PROCEDURE CreateSupplierReturnItem
@OrderItemID INT,
@Amount INT,
@EmployeeID INT,
@Reason VARCHAR(150),
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор'))
   INSERT INTO SupplierReturnItems(OrderItemID, Amount, EmployeeID, Reason, Date) VALUES (@OrderItemID, @Amount, @EmployeeID, @Reason, GETDATE());
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END;
GO