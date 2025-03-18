USE ShopManagement;
GO
CREATE PROCEDURE UpdateEmployee
@ID INT,
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
IF (NOT EXISTS(SELECT ID FROM Employees WHERE ID = @ID))
   THROW 50000, 'INVALID_ID_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   UPDATE Employees
   SET Name = @Name,
   Age = @Age,
   Gender = @Gender,
   PhoneNumber = @PhoneNumber,
   Email = @Email,
   Experience = @Experience,
   Position = @Position,
   UserLogin = @UserLogin,
   UserPassword = HASHBYTES('SHA2_512', @UserPassword)
   WHERE ID = @ID;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE UpdateCustomer
@ID INT,
@Name NVARCHAR(100),
@PhoneNumber NVARCHAR(15) = NULL,
@Email NVARCHAR(100) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (NOT EXISTS(SELECT ID FROM Customers WHERE ID = @ID))
   THROW 50000, 'INVALID_ID_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор', 'Менеджер'))
   UPDATE Customers
   SET Name = @Name,
   PhoneNumber = @PhoneNumber,
   Email = @Email
   WHERE ID = @ID;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE UpdateProduct
@ID INT,
@Name NVARCHAR(100),
@Price NUMERIC(10, 2) = 0,
@Amount INT = 0,
@Description NVARCHAR(100) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (NOT EXISTS(SELECT ID FROM Products WHERE ID = @ID))
   THROW 50000, 'INVALID_ID_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор', 'Менеджер'))
   UPDATE Products
   SET Name = @Name,
   Price = @Price,
   Amount = @Amount,
   Description = @Description
   WHERE ID = @ID;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE UpdateSupplier
@ID INT,
@Name NVARCHAR(100),
@PhoneNumber NVARCHAR(15) = NULL,
@Email NVARCHAR(100) = NULL,
@AccountNumber NVARCHAR(20) = NULL,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (NOT EXISTS(SELECT ID FROM Suppliers WHERE ID = @ID))
   THROW 50000, 'INVALID_ID_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('Администратор', 'Менеджер'))
   UPDATE Suppliers
   SET Name = @Name,
   PhoneNumber = @PhoneNumber,
   Email = @Email,
   AccountNumber = @AccountNumber
   WHERE ID = @ID;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END