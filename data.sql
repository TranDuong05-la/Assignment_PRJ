USE master
GO
DROP DATABASE IF EXISTS PRJ301_Assignment
GO
CREATE DATABASE PRJ301_Assignment
GO
USE PRJ301_Assignment
GO

-- USERS TABLE
CREATE TABLE tblUsers (
    userID NVARCHAR(50) PRIMARY KEY,
    fullName NVARCHAR(100) NOT NULL,
    password NVARCHAR(255) NOT NULL,
    roleID NVARCHAR(20) NOT NULL,
    status BIT NOT NULL DEFAULT 1
)
GO

INSERT INTO tblUsers VALUES
('admin01', N'Quản trị viên', 'admin123', 'admin', 1),
('buyer01', N'Nguyễn Văn A', 'buyer123', 'buyer', 1),
('buyer02', N'Lê Thị B', 'abc123', 'buyer', 1),
('buyer03', N'Hoàng Văn C', '123456', 'buyer', 0),
('seller01', N'Shop ABC', 'seller123', 'seller', 1),
('seller02', N'Shop XYZ', 'xyz789', 'seller', 1),
('seller03', N'Cửa hàng khóa', 'lockedshop', 'seller', 0)
GO

-- ADDRESSES TABLE
CREATE TABLE tblAddresses (
    addressID INT IDENTITY(1,1) PRIMARY KEY,
    userID NVARCHAR(50) NOT NULL,
    recipientName NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    addressDetail NVARCHAR(255) NOT NULL,
    district NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    isDefault BIT DEFAULT 0,
    FOREIGN KEY (userID) REFERENCES tblUsers(userID) ON DELETE CASCADE
)
GO

INSERT INTO tblAddresses (userID, recipientName, phone, addressDetail, district, city, isDefault) VALUES
('admin01',  N'Quản trị viên',      '0900000001', N'1 Tràng Tiền',        N'Hoàn Kiếm',    N'Hà Nội',     1),
('buyer01',  N'Nguyễn Văn A',       '0912345678', N'123 Lê Lợi',          N'Ba Đình',      N'Hà Nội',     1),
('buyer01',  N'Nguyễn Văn A',       '0912345678', N'456 Trần Hưng Đạo',   N'Hoàn Kiếm',    N'Hà Nội',     0),
('buyer02',  N'Lê Thị B',           '0934567890', N'789 Nguyễn Huệ',      N'Quận 1',       N'TP.HCM',     1),
('buyer03',  N'Hoàng Văn C',        '0978123456', N'12 Lý Thường Kiệt',   N'Hải Châu',     N'Đà Nẵng',    1),
('seller01', N'Shop ABC',           '0988111222', N'88 Nguyễn Trãi',      N'Thanh Xuân',   N'Hà Nội',     1),
('seller02', N'Shop XYZ',           '0909988776', N'99 Lê Văn Sỹ',        N'Phú Nhuận',    N'TP.HCM',     1),
('seller03', N'Cửa hàng khóa',      '0966778899', N'77 Trần Phú',         N'Hồng Bàng',    N'Hải Phòng',  1)
GO

-- CATEGORY TABLE
CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
)
GO

INSERT INTO Category (CategoryName) VALUES 
(N'Tiểu thuyết'),
(N'Kinh tế'),
(N'Kỹ năng sống'),
(N'Truyện tranh')
GO

-- BOOK TABLE
CREATE TABLE Book (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT FOREIGN KEY REFERENCES Category(CategoryID),
    BookTitle NVARCHAR(255),
    Author NVARCHAR(100),
    Publisher NVARCHAR(100),
    Price DECIMAL(10,2),
    Image NVARCHAR(255),
    Description NVARCHAR(MAX),
    PublishYear INT
)
GO

INSERT INTO Book (CategoryID, BookTitle, Author, Publisher, Price, Image, Description, PublishYear) VALUES
(3, N'Đắc Nhân Tâm', N'Dale Carnegie', N'NXB Tổng hợp', 90000, N'img1.jpg', N'Sách kỹ năng sống nổi tiếng nhất thế giới.', 2019),
(2, N'Cha Giàu Cha Nghèo', N'Robert Kiyosaki', N'NXB Trẻ', 110000, N'img2.jpg', N'Cách suy nghĩ về tiền bạc và đầu tư.', 2020),
(1, N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh', N'Nguyễn Nhật Ánh', N'NXB Trẻ', 85000, N'img3.jpg', N'Tiểu thuyết tuổi thơ trong trẻo.', 2015),
(4, N'One Piece - Tập 1', N'Eichiro Oda', N'NXB Kim Đồng', 20000, N'img4.jpg', N'Chuyến phiêu lưu của Luffy và băng hải tặc.', 2018)
GO

-- INVENTORY TABLE
CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT FOREIGN KEY REFERENCES Book(BookID),
    Quantity INT,
    LastUpdate DATETIME DEFAULT GETDATE()
)
GO

INSERT INTO Inventory (BookID, Quantity) VALUES
(1, 20),
(2, 15),
(3, 10),
(4, 50)
GO

-- REVIEW TABLE
CREATE TABLE Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT FOREIGN KEY REFERENCES Book(BookID),
    UserID NVARCHAR(50) FOREIGN KEY REFERENCES tblUsers(userID),
    Rating INT,
    Comment NVARCHAR(MAX),
    ReviewDate DATETIME DEFAULT GETDATE()
)
GO

INSERT INTO Review (BookID, UserID, Rating, Comment) VALUES
(1, 'buyer01', 5, N'Sách rất hay và ý nghĩa.'),
(2, 'buyer02', 4, N'Đọc dễ hiểu, nhiều bài học.'),
(1, 'buyer02', 3, N'Tốt nhưng hơi dài.')
GO

-- tblDiscounts
CREATE TABLE tblDiscounts (
    discountID INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(50) UNIQUE NOT NULL,
    type NVARCHAR(20) NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    minOrderAmount DECIMAL(10,2) DEFAULT 0,
    expiryDate DATE NOT NULL
)
GO

INSERT INTO tblDiscounts (code, type, value, minOrderAmount, expiryDate) VALUES
('SALE10', 'percent', 10.00, 100000, '2025-12-31'),      -- Giảm 10% cho đơn từ 100k
('GIAM20K', 'fixed', 20000.00, 50000, '2025-10-01'),     -- Giảm 20,000 cho đơn từ 50k
('VIP50', 'percent', 50.00, 500000, '2025-08-30'),       -- Giảm 50% đơn từ 500k
('FREESHIP', 'fixed', 30000.00, 0, '2025-09-15');         -- Giảm 30k không yêu cầu min
GO

-- tblOrders (giả định thêm để tạo FOREIGN KEY cho tblPayments)
CREATE TABLE tblOrders (
    orderID INT IDENTITY(1,1) PRIMARY KEY,
    userID NVARCHAR(50) FOREIGN KEY REFERENCES tblUsers(userID),
    orderDate DATETIME DEFAULT GETDATE()
)
GO

-- tblPayments
CREATE TABLE tblPayments (
    paymentID INT IDENTITY(1,1) PRIMARY KEY,
    orderID INT NOT NULL FOREIGN KEY REFERENCES tblOrders(orderID),
    method NVARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status NVARCHAR(20) DEFAULT NULL,
    paymentDate DATETIME DEFAULT GETDATE()
)
GO
