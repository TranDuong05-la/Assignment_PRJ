
USE [master]
GO

DROP DATABASE IF EXISTS [PRJ301_Assignment]
GO

CREATE DATABASE [PRJ301_Assignment]
GO

USE [PRJ301_Assignment]
GO

CREATE TABLE [dbo].[tblUsers] (
    [userID] NVARCHAR(50) NOT NULL,          
    [fullName] NVARCHAR(100) NOT NULL,       
    [password] NVARCHAR(255) NOT NULL,        
    [roleID] NVARCHAR(20) NOT NULL,           
    [status] BIT NOT NULL DEFAULT 1,          
    CONSTRAINT [PK_tblUsers] PRIMARY KEY CLUSTERED ([userID] ASC)
)
GO

INSERT INTO [dbo].[tblUsers] (userID, fullName, password, roleID, status) VALUES
('admin01', N'Quản trị viên', 'admin123', 'admin', 1),
('buyer01', N'Nguyễn Văn A', 'buyer123', 'buyer', 1),
('buyer02', N'Lê Thị B', 'abc123', 'buyer', 1),
('buyer03', N'Hoàng Văn C', '123456', 'buyer', 0), 
('seller01', N'Shop ABC', 'seller123', 'seller', 1),
('seller02', N'Shop XYZ', 'xyz789', 'seller', 1),
('seller03', N'Cửa hàng khóa', 'lockedshop', 'seller', 0);
GO

