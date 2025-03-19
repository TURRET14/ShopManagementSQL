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

CREATE PROCEDURE DeleteCustomerOrderItem
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM CustomerOrderItems WHERE ID = @ID)
      DELETE FROM CustomerOrderItems
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteCustomerReturnItem
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM CustomerReturnItems WHERE ID = @ID)
      DELETE FROM CustomerReturnItems
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

CREATE PROCEDURE DeleteSupplierOrderItem
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM SupplierOrderItems WHERE ID = @ID)
      DELETE FROM SupplierOrderItems
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO

CREATE PROCEDURE DeleteSupplierReturnItem
@ID INT,
@AdminLogin NVARCHAR(50),
@AdminPassword NVARCHAR(50)
AS BEGIN
IF (Dbo.SignIn(@AdminLogin, @AdminPassword) = 'Администратор')
   BEGIN
   IF EXISTS(SELECT ID FROM SupplierReturnItems WHERE ID = @ID)
      DELETE FROM SupplierReturnItems
      WHERE ID = @ID;
   ELSE
      THROW 50000, 'INVALID_ID', 255;
   END;
ELSE
   THROW 50000, 'AUTHORIZATION_ERROR', 255;
END

GO