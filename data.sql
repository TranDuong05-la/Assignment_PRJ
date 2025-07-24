USE master
GO
DROP DATABASE IF EXISTS PRJ301_Assignment
GO

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
    email NVARCHAR(100) UNIQUE NOT NULL,          
    roleID NVARCHAR(20) NOT NULL,
    status BIT NOT NULL DEFAULT 1,
    resetToken NVARCHAR(255),                     
    tokenExpiry DATETIME                          
)
GO

INSERT INTO tblUsers (userID, fullName, password, email, roleID, status)
VALUES 
('ant', 'Ánh Ngân', '123', 'kieuantran123@gmail.com', 'admin', 1),
('rosie', 'Rosie', '1102', 'ntlinh11297@gmail.com', 'admin', 1),
('admin', 'Duơng', '123', 'duongkieu090302@gmail.com', 'admin', 1),
('user01', 'Nguyễn Văn A', '123456', 'a@example.com', 'user', 1),
('user02', 'Lê Văn C', '123abc', 'c@example.com', 'user', 1);

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
('admin',   N'Quản trị viên',      '0900000001', N'1 Tràng Tiền',        N'Hoàn Kiếm',    N'Hà Nội',     1),
('user01',  N'Nguyễn Văn A',       '0912345678', N'123 Lê Lợi',          N'Ba Đình',      N'Hà Nội',     1),
('user01',  N'Nguyễn Văn A',       '0912345678', N'456 Trần Hưng Đạo',   N'Hoàn Kiếm',    N'Hà Nội',     0),
('user02',  N'Lê Thị B',           '0934567890', N'789 Nguyễn Huệ',      N'Quận 1',       N'TP.HCM',     1),
('rosie',   N'Hoàng Văn C',        '0978123456', N'12 Lý Thường Kiệt',   N'Hải Châu',     N'Đà Nẵng',    1),
('ant',     N'Anh Ngan',           '0988111222', N'88 Nguyễn Trãi',      N'Thanh Xuân',   N'Hà Nội',     1),
('ant',     N'ANT',                '0909988776', N'99 Lê Văn Sỹ',        N'Phú Nhuận',    N'TP.HCM',     1),
('rosie',   N'Cửa hàng khóa',      '0966778899', N'77 Trần Phú',         N'Hồng Bàng',    N'Hải Phòng',  1);

-- Quản lý sản phẩm & phân loại

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
    CategoryID INT,
    BookTitle NVARCHAR(255),
    Author NVARCHAR(100),
    Publisher NVARCHAR(100),
    Price DECIMAL(10,2),
    Image NVARCHAR(255),
    Description NTEXT,
    PublishYear INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
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
    BookID INT,
    Quantity INT,
    LastUpdate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);
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
    BookID INT,
    UserID NVARCHAR(50),
    Rating INT,            
    Comment NTEXT,
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (UserID) REFERENCES tblUsers(UserID)
);
GO

INSERT INTO Review (BookID, UserID, Rating, Comment) VALUES
(1, 'user01', 5, N'Sách rất hay và ý nghĩa.'),
(2, 'user02', 4, N'Đọc dễ hiểu, nhiều bài học.'),
(1, 'user02', 3, N'Tốt nhưng hơi dài.')
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
('SALE10', 'percent', 10.00, 100000, '2025-12-31'),      
('GIAM20K', 'fixed', 20000.00, 50000, '2025-10-01'),     
('VIP50', 'percent', 50.00, 500000, '2025-08-30'),       
('FREESHIP', 'fixed', 30000.00, 0, '2025-09-15');         
GO

CREATE TABLE tblOrders (
    orderID INT PRIMARY KEY IDENTITY(1,1),
    userID NVARCHAR(50),
    totalAmount INT,
    status VARCHAR(50),
    FOREIGN KEY (userID) REFERENCES tblUsers(userID)
);

INSERT INTO tblOrders (userID, totalAmount, status) VALUES
('ant', 420000, 'Da giao'),
('rosie', 150000, 'Dang xu ly');

CREATE TABLE tblPayments (
    paymentID INT IDENTITY(1,1) PRIMARY KEY,
    orderID INT NOT NULL FOREIGN KEY REFERENCES tblOrders(orderID),
    method NVARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status NVARCHAR(20) DEFAULT NULL,
    paymentDate DATETIME DEFAULT GETDATE()
)
GO

CREATE TRIGGER trg_EnsureSingleDefaultAddress
ON tblAddresses
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE tblAddresses
    SET isDefault = 0
    WHERE userID IN (
        SELECT userID FROM inserted WHERE isDefault = 1
    )
    AND addressID NOT IN (
        SELECT addressID FROM inserted WHERE isDefault = 1
    );
END;
GO
 

-- CART & CARTITEM TABLES
DROP TABLE IF EXISTS CartItem;
DROP TABLE IF EXISTS Cart;
GO

CREATE TABLE Cart (
    cartID INT PRIMARY KEY IDENTITY(1,1),
    userID NVARCHAR(50) NOT NULL UNIQUE,
    FOREIGN KEY (userID) REFERENCES tblUsers(userID) ON DELETE CASCADE
);
GO

INSERT INTO Cart (userID) VALUES ('ant'), ('rosie'), ('user01');
GO

CREATE TABLE CartItem (
    cartItemID INT PRIMARY KEY IDENTITY(1,1),
    cartID INT NOT NULL,
    bookID INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (cartID) REFERENCES Cart(cartID) ON DELETE CASCADE,
    FOREIGN KEY (bookID) REFERENCES Book(BookID) ON DELETE CASCADE
);
GO

-- bookIDs: 1=Dac Nhan Tam, 2=Cha Giau Cha Ngheo, 3=Toi Thay Hoa Vang..., 4=One Piece
-- cartIDs: 1=ant, 2=rosie, 3=user01
INSERT INTO CartItem (cartID, bookID, quantity) VALUES
(1, 1, 1), -- ant's cart: 1 Dac Nhan Tam
(1, 3, 2), -- ant's cart: 2 Toi Thay Hoa Vang...
(2, 4, 5), -- rosie's cart: 5 One Piece
(2,1,1),
(2,3,1),
(3, 2, 1); -- user01's cart: 1 Cha Giau Cha Ngheo
GO

-- Bang order (OrderDTO)
CREATE TABLE tblOrder (
    orderID INT PRIMARY KEY IDENTITY(1,1),
    userID NVARCHAR(50) NOT NULL,
    orderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    totalAmount DECIMAL(12,2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    shippingAddress VARCHAR(255),
    phone VARCHAR(20),
    note VARCHAR(255),
    FOREIGN KEY (userID) REFERENCES tblUsers(userID)
);

GO

-- Bang orderItem (OrderItemDTO)
CREATE TABLE orderItem (
    orderItemID INT PRIMARY KEY IDENTITY(1,1),
    orderID INT NOT NULL,
    bookID INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (orderID) REFERENCES tblOrder(orderID),
    FOREIGN KEY (bookID) REFERENCES Book(BookID)
);
GO

-- Insert sample orders for 2 users, each with 2 orders
INSERT INTO tblOrder (userID, orderDate, totalAmount, status, shippingAddress, phone, note) VALUES
('ant', '2024-06-01 10:00:00', 250000, 'Đã giao', '123 ABC, HCM', '0909123456', 'Giao nhanh'),
('rosie', '2024-06-05 15:30:00', 180000, 'Đang xử lý', '123 ABC, HCM', '0909123456', NULL),
('rosie', '2024-06-02 09:20:00', 320000, 'Đã giao', '456 XYZ, HN', '0912345678', NULL),
('ant', '2024-06-06 17:45:00', 120000, 'Đang xử lý', '456 XYZ, HN', '0912345678', 'Giao giờ hành chính');
GO
-- Insert order items for each order (giả sử orderID tự tăng từ 1 đến 4, bookID có sẵn là 1,2,3,4)
INSERT INTO orderItem (orderID, bookID, quantity, price) VALUES
(1, 1, 2, 85000), -- user 1, order 1
(1, 2, 1, 80000),
(2, 3, 2, 90000), -- user 1, order 2
(3, 2, 3, 80000), -- user 2, order 1
(3, 4, 1, 80000),
(4, 1, 1, 120000); -- user 2, order 2
GO