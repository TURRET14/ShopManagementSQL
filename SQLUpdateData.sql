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
@Salary INT = NULL,
@UserLogin NVARCHAR(50),
@UserPassword NVARCHAR(50),
@ChangePassword BIT = 0,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (@Position = 'SYSTEM_ADMIN' AND @ID != ISNULL((SELECT ID FROM Employees WHERE UserLogin = @AdminLogin), -1))
   THROW 50000, 'INVALID_POSITION_ERROR', 255;
IF (NOT EXISTS(SELECT ID FROM Employees WHERE ID = @ID))
   THROW 50000, 'INVALID_ID_ERROR', 255;
IF (EXISTS(SELECT TOP 1 ID FROM Employees WHERE UserLogin = @UserLogin AND ID != @ID))
   THROW 50000, 'ALREADY_TAKEN_LOGIN_ERROR', 255;
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'SYSTEM_ADMIN')
   BEGIN
   IF (@ChangePassword = 0 OR @ChangePassword IS NULL)
      UPDATE Employees
      SET Name = @Name,
      Age = @Age,
      Gender = @Gender,
      PhoneNumber = @PhoneNumber,
      Email = @Email,
      Experience = @Experience,
      Position = @Position,
      Salary = @Salary,
      UserLogin = @UserLogin
      WHERE ID = @ID;
   
   ELSE
      UPDATE Employees
      SET Name = @Name,
      Age = @Age,
      Gender = @Gender,
      PhoneNumber = @PhoneNumber,
      Email = @Email,
      Experience = @Experience,
      Position = @Position,
      Salary = @Salary,
      UserLogin = @UserLogin,
      UserPassword = HASHBYTES('SHA2_512', @UserPassword)
      WHERE ID = @ID;
   END;
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
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
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
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
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
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) IN ('SYSTEM_ADMIN', 'SHOP_ADMIN'))
   UPDATE Suppliers
   SET Name = @Name,
   PhoneNumber = @PhoneNumber,
   Email = @Email,
   AccountNumber = @AccountNumber
   WHERE ID = @ID;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END