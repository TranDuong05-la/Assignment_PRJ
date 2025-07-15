<%-- 
    Document   : home.jsp
    Created on : Jul 8, 2025, 11:10:39 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <style>
            body {
                background: #fff6f6;
                margin: 0;
                font-family: 'Roboto', Arial, sans-serif;
                color: #222;
            }
            .header {
                width: 100%;
                background: #fff;
                box-shadow: 0 1px 16px rgba(180,0,0,.07);
                padding: 0;
                position: sticky;
                top: 0;
                z-index: 50;
            }
            .header-wrap {
                max-width: 1300px;
                margin: 0 auto;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 76px;
                padding: 0 32px;
            }
            .logo {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 1.5rem;
                font-weight: bold;
                color: #ea2222;
                text-decoration: none;
            }
            .logo i {
                font-size: 2rem;
            }
            .search-bar {
                flex: 1;
                max-width: 420px;
                margin: 0 32px;
                position: relative;
                display: flex;
                align-items: center;
            }

            .search-bar input {
                width: 100%;
                padding: 11px 44px 11px 20px;
                border: 1px solid #ececec;
                border-radius: 22px;
                font-size: 1.02rem;
                background: #fafafa;
                transition: border .2s;
            }
            .search-bar input:focus {
                border-color: #ea2222;
                outline: none;
            }
            .search-bar button {
                position: absolute;
                right: 12px;
                background: transparent;
                border: none;
                color: #ea2222;
                font-size: 1.15rem;
                cursor: pointer;
            }

            .header-menu {
                display: flex;
                gap: 28px;
                align-items: center;
                font-size: 1.07rem;
            }
            .header-menu a {
                text-decoration: none;
                color: #333;
                padding: 4px 0;
                position: relative;
            }
            .header-menu a.active, .header-menu a:hover {
                color: #ea2222;
                font-weight: bold;
            }
            .header-right {
                display: flex;
                gap: 20px;
                align-items: center;
            }
            .cart-btn {
                position: relative;
                color: #333;
                text-decoration: none;
                font-size: 1.35rem;
                padding: 3px 5px;
            }
            .cart-btn .cart-count {
                position: absolute;
                top: -6px;
                right: -8px;
                background: #ea2222;
                color: #fff;
                font-size: .85rem;
                border-radius: 50%;
                width: 18px;
                height: 18px;
                text-align: center;
                line-height: 18px;
                font-weight: 500;
                border: 2px solid #fff;
            }
            .sign-btn {
                background: #ea2222;
                color: #fff;
                border: none;
                border-radius: 22px;
                padding: 8px 26px;
                font-weight: 600;
                font-size: 1.08rem;
                text-decoration: none;
                transition: background .18s;
                margin-left: 8px;
                cursor: pointer;
            }
            .sign-btn:hover {
                background: #d31717;
            }

            .dropdown {
                display: none;
            }
            @media screen and (max-width: 768px) {
                .search-bar  {
    position: absolute;
    top: 71px;
    left: 50%;
    transform: translateX(-50%);
    width: 70% !important;
    max-width: 600px;
    margin: 0;
    z-index: 999;
    background: white;
    padding: 6px 12px;
    border-radius: 28px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.12);
}
                .header-wrap {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .header-menu,
                .header-right,
                .cart-btn ,
                .cart-count,
                .sign-btn{
                    display: none;
                }

                .dropdown {
                    display: block;
                    position: absolute;
                    top: 72px;
                    right: 10px;
                    z-index: 1000;
                    
                }
                
                .dropdown .dropdown-menu {
                    min-width: 180px;
                    background-color: #fff;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                }

                .dropdown .dropdown-item {
                    padding: 10px 15px;
                    font-size: 0.95rem;
                }
                
.dropdown .btn.dropdown-toggle {
    padding: 6px 10px;
    font-size: 1rem;
    border-radius: 50%;
    width: 38px;
    height: 38px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f5f5f5;
    border: 1px solid #ddd;
    color: #333;
    box-shadow: 0 1px 4px rgba(0,0,0,0.1);
    transition: background 0.2s;
}

.dropdown .btn.dropdown-toggle:hover {
    background-color: #e6e6e6;
}


                .dropdown-divider {
                    margin: 5px 0;
                    border-top: 1px solid #ddd;
                }
            }
            /* Slider */
            .slider-section {
                margin: 36px auto 0 auto;
                max-width: 1000px;
                min-height: 340px;
                background: #000;
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                overflow: hidden;
            }
            .slider-img {
                width: 100%;
                height: 340px;
                object-fit: cover;
                opacity: 0.88;
                border-radius: 16px;
                display: block;
            }
            .slider-content {
                position: absolute;
                left: 70px;
                top: 48px;
                color: #fff;
                z-index: 2;
                width: 370px;
            }
            .slider-content .genre {
                background: #fff;
                color: #222;
                border-radius: 13px;
                font-size: 1.02rem;
                padding: 2px 13px;
                display: inline-block;
                font-weight: 500;
                margin-bottom: 22px;
            }
            .slider-content h1 {
                font-size: 2.6rem;
                margin: 0 0 25px 0;
                line-height: 1.18;
                font-weight: bold;
                text-shadow: 0 3px 16px #00000022;
            }
            .slider-content .btn {
                background: #ea2222;
                color: #fff;
                border-radius: 24px;
                font-weight: 600;
                padding: 12px 30px;
                text-decoration: none;
                font-size: 1.13rem;
                margin-top: 14px;
                display: inline-block;
                transition: background .2s;
            }
            .slider-content .btn:hover {
                background: #c81c1c;
            }
            .slider-dots {
                position: absolute;
                bottom: 18px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 9px;
            }
            .slider-dot {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #fff6f6;
                border: 1.5px solid #ea2222;
                cursor: pointer;
                opacity: 0.65;
            }
            .slider-dot.active {
                background: #ea2222;
                opacity: 1;
            }
            /* Best Seller */
            .best-seller-section {
                margin: 52px auto 0 auto;
                max-width: 1200px;
            }
            .best-title {
                font-size: 1.7rem;
                font-weight: bold;
                color: #2d1d12;
                text-align: center;
                margin-bottom: 30px;
            }
            .add-book-bar {
                max-width:1200px;
                margin:30px auto 0 auto;
                display:flex;
                justify-content:flex-end;
            }
            .books-list {
                display: flex;
                gap: 16px;
                overflow-x: auto;
                justify-content: center;
                padding: 0 15px 12px 15px;
            }
            .book-card {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 3px 14px #cdaaa74d;
                width: 190px;
                min-width: 190px;
                max-width: 190px;
                padding: 12px 12px 18px 12px;
                display: flex;
                flex-direction: column;
                align-items: flex-start;
                transition: box-shadow .2s;
                border: 1px solid #f1e6e4;
                position: relative;
            }
            .book-card:hover {
                box-shadow: 0 8px 32px #ea22224a;
            }
            .book-card img {
                width: 100%;
                height: 246px;
                object-fit: cover;
                border-radius: 7px;
                margin-bottom: 10px;
            }
            .book-card .book-title {
                font-weight: 600;
                font-size: 1.06rem;
                color: #2d1d12;
                margin-bottom: 2px;
                margin-top: 0;
            }
            .book-card .author {
                font-size: 0.97rem;
                color: #888;
                margin-bottom: 8px;
            }
            .book-card .stars {
                color: #faad14;
                margin-bottom: 3px;
                font-size: 1rem;
            }
            .book-card .review-count {
                font-size: 0.97rem;
                color: #9e6144;
                margin-bottom: 4px;
            }
            .book-card .price {
                color: #ea2222;
                font-size: 1.14rem;
                font-weight: 700;
                letter-spacing: 1px;
                margin-bottom: 2px;
            }
            .del-btn {
                position: absolute;
                top: 10px;
                right: 10px;
                background: #fff4f4;
                border: 1px solid #ffc2c2;
                color: #ea2222;
                border-radius: 50%;
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 1.1rem;
                z-index: 4;
                transition: background .2s;
            }
            .del-btn:hover {
                background: #ea2222;
                color: #fff;
            }
            /* Add Book Modal */
            #addModal {
                display: none;
                position: fixed;
                z-index:1001;
                top:0;
                left:0;
                width:100vw;
                height:100vh;
                background: rgba(0,0,0,0.26);
                align-items: center;
                justify-content: center;
            }
            #addForm {
                background:#fff;
                padding:28px 32px;
                border-radius:12px;
                box-shadow:0 4px 40px #a52c2c22;
                max-width:350px;
                min-width:240px;
                margin:auto;
                position:relative;
                display: flex;
                flex-direction: column;
                gap: 11px;
            }
            #addForm h3 {
                margin-top:0;
                text-align:center;
                color:#ea2222;
            }
            #addForm label {
                font-size: 1rem;
            }
            #addForm input {
                width:100%;
                margin-bottom:0.5rem;
                margin-top:3px;
                padding:7px 12px;
                border-radius: 7px;
                border: 1px solid #ececec;
                font-size:1.03rem;
            }
            #addForm input:focus {
                outline: none;
                border-color: #ea2222;
            }
            #addForm .btns {
                display: flex;
                gap: 14px;
                justify-content: center;
                margin-top: 7px;
            }
            #addForm button[type="button"] {
                background:#ececec;
                border:none;
                padding:8px 22px;
                border-radius:22px;
                cursor: pointer;
            }
            #addForm button[type="submit"] {
                padding:8px 22px;
            }
            #addForm .close-x {
                position:absolute;
                top:8px;
                right:18px;
                cursor:pointer;
                font-size:1.2rem;
                color:#ea2222;
            }

            

            /* FOOTER STYLE */
            footer {
                background: #231f20;
                color: #eee;
                padding: 0 0 0 0;
                margin-top: 60px;
                font-size: 1rem;
            }
            .footer-wrap {
                max-width: 1200px;
                margin: 0 auto;
                padding: 40px 24px 0 24px;
                display: flex;
                flex-wrap: wrap;
                gap: 36px;
                justify-content: space-between;
            }
            .footer-col {
                flex: 1 1 180px;
                min-width: 170px;
                margin-bottom: 32px;
            }
            .footer-logo {
                font-size: 1.7rem;
                font-weight: bold;
                color: #ea2222;
                text-decoration: none;
                display:flex;
                align-items:center;
                gap:7px;
            }
            .footer-logo i {
                font-size: 2rem;
            }
            .footer-desc {
                font-size: 1.04rem;
                margin: 13px 0 17px 0;
                color: #d8d8d8;
            }
            .footer-social a {
                color: #fff;
                margin-right: 13px;
                font-size: 1.34rem;
                background:#ea2222;
                border-radius: 50%;
                width:32px;
                height:32px;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                transition: background 0.18s;
                text-decoration: none;
            }
            .footer-social a:hover {
                background: #c81c1c;
            }
            .footer-title {
                font-size: 1.13rem;
                font-weight: bold;
                color: #fff;
                margin-bottom: 12px;
            }
            .footer-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            .footer-list li {
                margin-bottom: 8px;
            }
            .footer-list a {
                color: #d8d8d8;
                text-decoration: none;
                transition: color 0.18s;
            }
            .footer-list a:hover {
                color: #fff;
                text-decoration: underline;
            }
            .footer-contact {
                color: #d8d8d8;
                font-size: 1.03rem;
                line-height: 1.7;
            }
            .footer-contact i {
                color: #ea2222;
                margin-right: 8px;
                width: 18px;
                text-align: center;
            }
            .footer-bottom {
                border-top: 1px solid #343434;
                text-align: center;
                padding: 14px 0 10px 0;
                font-size: 1rem;
                background: #1a1819;
                color: #bbb;
            }
            @media (max-width:900px){
                .footer-wrap {
                    flex-direction: column;
                    padding: 30px 14px 0 14px;
                }
            }



        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="header">
            <div class="header-wrap">
                <a class="logo" href="home.jsp"><i class="fa-solid fa-book-open"></i> ABC <span style="color:#111;font-weight:400">Book</span></a>
                <div class="search-bar">
                    <input type="text" class="form-control rounded-pill" placeholder="Search book by author or publisher">
                    <button class="btn btn-link text-danger ml-n4"><i class="fa fa-search"></i></button>
                </div>

                <div class="header-menu">
                    <a href="#" class="active">Home</a>
                    <a href="#">Categories</a>
                </div>
                <div class="header-right">
                    <a href="#" style="color:#3d3d3d;font-size:1.02rem;text-decoration:none;">FAQ</a>
                    <% if(AuthUtils.isLoggedIn(request)){%>
                    <div class="btn-group">
                        <button type="button" class="btn btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            See More
                        </button>
                        <div class="dropdown-menu dropdown-menu-right">
                            <a class="dropdown-item" href="viewDiscounts.jsp">View Discounts Code</a>
                            <a class="dropdown-item" href="addressList.jsp">Your Address</a>
                            <a class="dropdown-item" href="#">Something else here</a>
                            <a class="dropdown-item" href="#">Something else here</a>
                            <a class="dropdown-item" href="#">Something else here</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="reset.jsp">Reset Password</a>
                        </div>
                        <%}%>
                    </div>

                    <a href="#" class="cart-btn"><i class="fa-solid fa-cart-shopping"></i>
                        <span class="cart-count">1</span>
                    </a>
                    <%
                    UserDTO user = (UserDTO) session.getAttribute("user");
                     if (user != null) {
                    %>
                    <span style="font-size: 1rem;"><%= user.getFullName() %></span>
                    <a href="MainController?action=logout" class="sign-btn" style="background:#ccc;color:#222;">Logout</a>
                    <%
                        } else {
                    %>
                    <a href="login.jsp" class="sign-btn">Sign in</a>
                    <%
                        }
                    %>

                </div>
            </div>
            <!-- Mobile Dropdown Menu -->
            <div class="dropdown d-md-none">
                <button class="btn btn-light dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown">
                    <i class="fa fa-bars"></i>
                </button>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuButton">
                    <a class="dropdown-item" href="home.jsp">Home</a>
                    <a class="dropdown-item" href="#">Categories</a>
                    <a class="dropdown-item" href="#">FAQ</a>
                    <a class="dropdown-item" href="#">Track Order</a>
                    <a class="dropdown-item" href="#"><i class="fa fa-shopping-cart"></i> Cart (1)</a>
                    <%
                        if (user != null) {
                    %>
                    <div class="dropdown-divider"></div>
                    <span class="dropdown-item-text"><%= user.getFullName() %></span>
                    <a class="dropdown-item" href="MainController?action=logout">Logout</a>
                    <%
                        } else {
                    %>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="login.jsp">Sign in</a>
                    <%
                        }
                    %>
                </div>

            </div>

            <!-- Slider -->
            <div class="slider-section">
                <img class="slider-img" src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80" alt="">
                <div class="slider-content">
                    <span class="genre">Science Fiction</span>
                    <h1>The History<br> of Phipino</h1>
                    <a class="btn" href="#">Browse Store</a>
                </div>
                <div class="slider-dots">
                    <div class="slider-dot active"></div>
                    <div class="slider-dot"></div>
                    <div class="slider-dot"></div>
                </div>
            </div>

            <!-- Add Product Button -->
            <div class="add-book-bar">
                <button class="sign-btn" onclick="openAddModal()">+ Thêm sản phẩm</button>
            </div>

            <!-- Add Product Modal -->
            <div id="addModal">
                <form id="addForm" autocomplete="off">
                    <h3>Thêm sản phẩm mới</h3>
                    <label>Tên sách:<input type="text" name="title" required></label>
                    <label>Tác giả:<input type="text" name="author" required></label>
                    <label>Giá ($):<input type="number" name="price" min="1" required></label>
                    <label>Ảnh (URL):<input type="url" name="image" required placeholder="http://..."></label>
                    <div class="btns">
                        <button type="button" onclick="closeAddModal()">Hủy</button>
                        <button type="submit" class="sign-btn">Lưu</button>
                    </div>
                    <span onclick="closeAddModal()" class="close-x" title="Đóng">&times;</span>
                </form>
            </div>

            <!-- Best Seller -->
            <div class="best-seller-section">
                <div class="best-title">Best Selling Books Ever</div>
                <div class="books-list" id="books-list">
                    <!-- Các book-card giữ nguyên như code bạn gửi -->
                    <!-- ... -->
                    <div class="book-card">
                        <img src="https://m.media-amazon.com/images/I/41zoxjP4xlL.jpg" alt="">
                        <div class="book-title">Sin Eater</div>
                        <div class="author">Megan Campisi</div>
                        <div class="stars">
                            <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star-half-alt"></i>
                        </div>
                        <div class="review-count">(120 Review)</div>
                        <div class="price">$50</div>
                        <button class="del-btn" title="Xóa sản phẩm" onclick="removeBook(this)">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </div>
                    <!-- ... Các book-card còn lại ... -->
                </div>
            </div>
            <!-- Latest/New Books Section -->
            <div class="best-seller-section" style="margin-top:48px;">
                <div class="best-title">Latest Books</div>
                <div class="books-list">
                    <!-- Các book-card sách mới giữ nguyên -->
                </div>
            </div>

            <footer>
                <div class="footer-wrap">
                    <div class="footer-col">
                        <a href="#" class="footer-logo"><i class="fa-solid fa-book-open"></i> ABC <span style="color:#fff;font-weight:400">Book</span></a>
                        <div class="footer-desc">
                            ABC Book - Nền tảng đặt sách trực tuyến, đa dạng đầu sách, giao hàng toàn quốc.
                        </div>
                        <div class="footer-social">
                            <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                            <a href="#" title="YouTube"><i class="fab fa-youtube"></i></a>
                            <a href="#" title="Tiktok"><i class="fab fa-tiktok"></i></a>
                        </div>
                    </div>
                    <div class="footer-col">
                        <div class="footer-title">Danh mục</div>
                        <ul class="footer-list">
                            <li><a href="#">Trang chủ</a></li>
                            <li><a href="#">Thể loại sách</a></li>
                            <li><a href="#">Sách mới</a></li>
                            <li><a href="#">Bán chạy</a></li>
                            <li><a href="#">Blog</a></li>
                        </ul>
                    </div>
                    <div class="footer-col">
                        <div class="footer-title">Hỗ trợ</div>
                        <ul class="footer-list">
                            <li><a href="#">Chính sách đổi trả</a></li>
                            <li><a href="#">Câu hỏi thường gặp</a></li>
                            <li><a href="#">Liên hệ hỗ trợ</a></li>
                        </ul>
                    </div>
                    <div class="footer-col">
                        <div class="footer-title">Liên hệ</div>
                        <div class="footer-contact">
                            <div><i class="fa fa-map-marker-alt"></i> FPT University, HCM</div>
                            <div><i class="fa fa-envelope"></i> kiemtienonl2108@gmail.com</div>
                            <div><i class="fa fa-phone"></i> 0917972397</div>
                        </div>
                    </div>
                </div>
                <div class="footer-bottom">
                    2025 ABC Book. All rights reserved.
                </div>
            </footer>
            <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
