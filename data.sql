
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

-- Quản lý sản phẩm & phân loại
CREATE TABLE Category (
    CategoryID INT INDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(100)
);

CREATE TABLE Book (
    BookID INT INDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    BookTitle VARCHAR(255),
    Author VARCHAR(100),
    Publisher VARCHAR(100),
    Price DECIMAL(10,2),
    Image VARCHAR(255),
    Description TEXT,
    PublishYear INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);
--  Quản lý tồn kho
CREATE TABLE Inventory (
    InventoryID INT INDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    Quantity INT,
    LastUpdate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

CREATE TABLE Review (
    ReviewID INT INDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    UserID INT,
    Rating INT,            -- 1 đến 5 sao
    Comment TEXT,
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (UserID) REFERENCES tblUsers(UserID)
);

INSERT INTO Category (CategoryName) VALUES (N"Tiểu thuyết");
INSERT INTO Category (CategoryName) VALUES (N"Kinh tế");
INSERT INTO Category (CategoryName) VALUES (N"Kỹ năng sống");
INSERT INTO Category (CategoryName) VALUES (N"Truyện tranh");


INSERT INTO Book (CategoryID, BookTitle, Author, Publisher, Price, Image, Description, PublishYear)
VALUES (1, N"Đắc Nhân Tâm", N"Dale Carnegie", N"NXB Tổng hợp", 90000, N"img1.jpg", N"Sách kỹ năng sống nổi tiếng nhất thế giới.", 2019);

INSERT INTO Book (CategoryID, BookTitle, Author, Publisher, Price, Image, Description, PublishYear)
VALUES (2, N"Cha Giàu Cha Nghèo", N"Robert Kiyosaki", N"NXB Trẻ", 110000, N"img2.jpg", N"Cách suy nghĩ về tiền bạc và đầu tư.", 2020);

INSERT INTO Book (CategoryID, BookTitle, Author, Publisher, Price, Image, Description, PublishYear)
VALUES (3, N"Tôi Thấy Hoa Vàng Trên Cỏ Xanh", N"Nguyễn Nhật Ánh", N"NXB Trẻ", 85000, N"img3.jpg", N"Tiểu thuyết tuổi thơ trong trẻo.", 2015);

INSERT INTO Book (CategoryID, BookTitle, Author, Publisher, Price, Image, Description, PublishYear)
VALUES (4, N"One Piece - Tập 1", N"Eichiro Oda", N"NXB Kim Đồng", 20000, N"img4.jpg", N"Chuyến phiêu lưu của Luffy và băng hải tặc.", 2018);

INSERT INTO Inventory (BookID, Quantity, LastUpdate) VALUES (1, 20, GETDATE());
INSERT INTO Inventory (BookID, Quantity, LastUpdate) VALUES (2, 15, GETDATE());
INSERT INTO Inventory (BookID, Quantity, LastUpdate) VALUES (3, 10, GETDATE());
INSERT INTO Inventory (BookID, Quantity, LastUpdate) VALUES (4, 50, GETDATE());


INSERT INTO Review (BookID, UserID, Rating, Comment, ReviewDate)
VALUES (1, 1, 5, N"Sách rất hay và ý nghĩa.", GETDATE());

INSERT INTO Review (BookID, UserID, Rating, Comment, ReviewDate)
VALUES (2, 2, 4, N"Đọc dễ hiểu, nhiều bài học.",GETDATE());

INSERT INTO Review (BookID, UserID, Rating, Comment, ReviewDate)
VALUES (1, 2, 3, N"Tốt nhưng hơi dài.", GETDATE());
