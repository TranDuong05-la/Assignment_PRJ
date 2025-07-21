<%-- 
    Document   : search
    Created on : Jul 21, 2025, 9:38:03 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="model.BookDTO" %>
<%@ page import="model.CategoryDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Books</title>
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

            /* Book list center and card style */
            .books-list {
                display: flex;
                flex-wrap: wrap;
                gap: 32px 24px;
                margin: 30px auto 0 auto;
                justify-content: center;
                max-width: 1200px;
            }
            .book-card {
                width: 260px;
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 2px 18px #e6b9b950;
                padding: 18px 18px 14px 18px;
                margin-bottom: 18px;
                text-decoration: none;
                color: #222;
                transition: box-shadow 0.19s, transform 0.15s;
                position: relative;
                min-height: 400px;
                display: flex;
                flex-direction: column;
            }
            .book-card:hover {
                box-shadow: 0 4px 22px #ea22224c;
                transform: translateY(-4px) scale(1.03);
                z-index: 1;
            }
            .book-card img {
                width: 100%;
                height: 180px;
                object-fit: cover;
                border-radius: 10px;
                background: #f5dada;
                margin-bottom: 14px;
                box-shadow: 0 2px 10px #ecbcbc3a;
            }
            .book-title {
                font-weight: bold;
                font-size: 1.19rem;
                margin: 3px 0 3px 0;
                text-decoration: underline;
            }
            .author {
                color: #93a3b6;
                margin-bottom: 10px;
                font-size: 1.06rem;
            }
            .stars {
                color: #ffd700;
                margin-bottom: 4px;
                font-size: 1.12rem;
            }
            .price {
                color: #ea2222;
                font-weight: bold;
                font-size: 1.23rem;
                margin-bottom: 6px;
                text-shadow: 0 1px 6px #ffe7e7;
                letter-spacing: 1px;
            }
            .del-btn {
                background: none;
                border: none;
                color: #ea2222;
                font-size: 1.24rem;
                cursor: pointer;
                padding: 2px 7px;
                border-radius: 50%;
                transition: background 0.16s;
            }
            .del-btn:hover {
                background: #f8d2d2;
            }
            @media (max-width: 900px) {
                .books-list {
                    gap: 20px 10px;
                }
                .book-card {
                    width: 47vw;
                    min-width: 150px;
                }
            }
            @media (max-width: 600px) {
                .books-list {
                    gap: 9px 0;
                }
                .book-card {
                    width: 97vw;
                    padding: 12px 8px;
                    min-height: unset;
                }
                .book-card img {
                    height: 120px;
                }
            }
            /* Footer style ... giữ nguyên như cũ */
            footer {
                background: #231f20;
                color: #eee;
                padding: 0;
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
</style>
</head>
<body>
    <!-- Header -->
    <!-- Header -->
    <div class="header">
        <div class="header-wrap">
            <a class="logo" href="home.jsp"><i class="fa-solid fa-book-open"></i> ABC <span style="color:#111;font-weight:400">Book</span></a>
            <div class="search-bar">
                <form action="ProductController" method="post" style="display:flex;align-items:center;">
                    <input type="hidden" name="action" value="searchBook">
                    <input type="text" name="strKeyword" placeholder="Search books by author or publisher"
                           style="flex:1; padding:11px 44px 11px 20px; border:1px solid #ececec; border-radius:22px; font-size:1.02rem; background:#fafafa;">
                    <button type="submit" style="position:absolute;top:8px;right:12px;border:none;background:transparent;color:#ea2222;font-size:1.15rem;cursor:pointer;">
                        <i class="fa-solid fa-search"></i>
                    </button>
                </form>
            </div>
            <div class="header-menu">
                <a href="<%=request.getContextPath()%>/home" class="active">Home</a>
                <a href="category.jsp">Categories</a>
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
                        <a class="dropdown-item" href="#">Other option</a>
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
    </div>
    <div class="books-list">
        <%
            List<BookDTO> books = (List<BookDTO>) request.getAttribute("books");
            if (books != null && !books.isEmpty()) {
                for (BookDTO book : books) {
        %>
        <a class="book-card" href="book/<%= book.getBookID() %>" style="position:relative; display: block;">
            <img src="<%= 
                (book.getImage() != null && !book.getImage().equals("null") && !book.getImage().isEmpty())
                ? (book.getImage().startsWith("http") ? book.getImage() : request.getContextPath() + "/" + book.getImage())
                : "https://via.placeholder.com/150x200?text=No+Image"
                 %>" alt="<%= book.getBookTitle() %>" style="width:100%;height:246px;object-fit:cover;border-radius:7px;margin-bottom:10px;">

            <div class="book-title"><%= book.getBookTitle() %></div>
            <div class="author"><%= book.getAuthor() %></div>
            <div class="stars">
                <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star-half-alt"></i>
            </div>
            <div class="price">$<%= book.getPrice() %></div>
            <% if (session.getAttribute("user") != null && AuthUtils.isAdmin(request)) { %>
            <form method="post" action="ProductController"
                  style="position:absolute;top:10px;right:50px;">
                <input type="hidden" name="action" value="editBook">
                <input type="hidden" name="bookID" value="<%= book.getBookID() %>">
                <button type="submit" class="del-btn" title="Edit book">
                    <i class="fa-solid fa-pen"></i>
                </button>
            </form>
            <form method="post" action="ProductController"
                  style="position:absolute;top:10px;right:10px;">
                <input type="hidden" name="action" value="deleteBook">
                <input type="hidden" name="bookID" value="<%= book.getBookID() %>">
                <button type="submit" class="del-btn" title="Delete book"
                        onclick="return confirm('Delete this book?');">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </form>
            <% } %>
        </a>
        <%
                }
            } else {
        %>
        <div style="width:100%;text-align:center;padding:48px 0;font-size:1.18rem;color:#b13e3e;">
            No books found.
        </div>
        <%
            }
        %>
    </div>
    <footer>
        <div class="footer-wrap">
            <div class="footer-col">
                <a href="#" class="footer-logo"><i class="fa-solid fa-book-open"></i> ABC <span style="color:#fff;font-weight:400">Book</span></a>
                <div class="footer-desc">
                    ABC Book - Online book order platform, diverse titles, nationwide delivery.
                </div>
                <div class="footer-social">
                    <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" title="YouTube"><i class="fab fa-youtube"></i></a>
                    <a href="#" title="Tiktok"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <div class="footer-title">Categories</div>
                <ul class="footer-list">
                    <li><a href="#">Home</a></li>
                    <li><a href="#">Book Categories</a></li>
                    <li><a href="#">New Books</a></li>
                    <li><a href="#">Best Seller</a></li>
                    <li><a href="#">Blog</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <div class="footer-title">Support</div>
                <ul class="footer-list">
                    <li><a href="#">Return Policy</a></li>
                    <li><a href="#">FAQ</a></li>
                    <li><a href="#">Contact Support</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <div class="footer-title">Contact</div>
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
