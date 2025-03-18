USE ShopManagement;
GO
CREATE PROCEDURE DeleteEmployee
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM Employees WHERE ID = @ID)
      DELETE FROM Employees
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteCustomer
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM Customers WHERE ID = @ID)
      DELETE FROM Customers
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteProduct
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM Products WHERE ID = @ID)
      DELETE FROM Products
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteSupplier
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM Suppliers WHERE ID = @ID)
      DELETE FROM Suppliers
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteCustomerOrder
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM CustomerOrders WHERE ID = @ID)
      DELETE FROM CustomerOrders
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteCustomerOrderDetail
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM CustomerOrderDetails WHERE ID = @ID)
      DELETE FROM CustomerOrderDetails
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteCustomerReturn
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM CustomerReturns WHERE ID = @ID)
      DELETE FROM CustomerReturns
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteSupplierOrder
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM SupplierOrders WHERE ID = @ID)
      DELETE FROM SupplierOrders
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteSupplierOrderDetail
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM SupplierOrderDetails WHERE ID = @ID)
      DELETE FROM SupplierOrderDetails
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteSupplierReturn
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM SupplierReturns WHERE ID = @ID)
      DELETE FROM SupplierReturns
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO