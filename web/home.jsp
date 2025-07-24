<%-- 
    Document   : home.jsp
    Created on : Jul 8, 2025, 11:10:39 PM
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
                max-width: 320px;
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
            @media screen and (max-width: 900px) {
                .header-wrap {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }
                .search-bar {
                    width: 99vw;
                    max-width: 98vw;
                    margin: 10px 0 0 0;
                }
                .header-menu, .header-right {
                    display: none;
                }
                .dropdown {
                    display: block;
                    position: absolute;
                    top: 72px;
                    right: 10px;
                    z-index: 1000;
                }
            }
            /* Slider Section */
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
            /* Book List */
            .best-seller-section {
                margin: 52px auto 0 auto;
                max-width: 1300px;
            }
            .best-title {
                font-size: 1.7rem;
                font-weight: bold;
                color: #2d1d12;
                text-align: center;
                margin-bottom: 30px;
            }
            .add-book-bar {
                max-width: 1200px;
                margin: 30px auto 0 auto;
                display: flex;
                justify-content: flex-end;
            }
            .books-list {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
                gap: 38px 26px;
                justify-items: center;
                margin: 0 auto;
                padding: 28px 0 12px 0;
                width: 97vw;
                max-width: 1320px;
                box-sizing: border-box;
            }
            .book-card {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 4px 24px #e6b9b930;
                width: 315px;
                min-height: 380px;
                padding: 22px 16px 16px 16px;
                display: flex;
                flex-direction: column;
                align-items: flex-start;
                transition: box-shadow .17s, transform .13s;
                border: none;
                position: relative;
                text-decoration: none;
                color: #222;
                margin: 0;
            }
            .book-card:hover {
                box-shadow: 0 12px 36px #ea222244;
                transform: translateY(-5px) scale(1.015);
                z-index: 2;
            }
            .book-card img, .book-card .img-preview {
                width: 100%;
                height: 180px;
                object-fit: cover;
                border-radius: 14px;
                background: #f6eeee;
                margin-bottom: 13px;
                display: block;
                box-shadow: 0 3px 13px #ecbcbc2c;
            }
            .book-title {
                font-weight: bold;
                font-size: 1.18rem;
                margin: 0 0 7px 0;
                text-decoration: underline;
                line-height: 1.19;
                color: #1b1a1b;
            }
            .author {
                color: #98a3b6;
                margin-bottom: 13px;
                font-size: 1.07rem;
            }
            .stars {
                color: #ffd700;
                margin-bottom: 6px;
                font-size: 1.12rem;
            }
            .price {
                color: #ea2222;
                font-weight: bold;
                font-size: 1.22rem;
                margin: 7px 0 0 0;
                letter-spacing: 1px;
                text-shadow: 0 1px 6px #ffe7e7;
            }
            /* Admin button */
            .del-btn {
                position: absolute;
                top: 14px;
                right: 12px;
                background: #fff4f4;
                border: 1.5px solid #ffc2c2;
                color: #ea2222;
                border-radius: 50%;
                width: 33px;
                height: 33px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 1.1rem;
                z-index: 4;
                transition: background .16s, color .12s;
            }
            .del-btn:hover {
                background: #ea2222;
                color: #fff;
            }
            .no-books {
                grid-column: 1/-1;
                text-align: center;
                color: #b92a2a;
                font-size: 1.3rem;
                margin: 24px 0;
                width: 100%;
            }
            /* Responsive */
            @media (max-width: 1000px) {
                .books-list {
                    grid-template-columns: repeat(2, 1fr);
                    gap: 19px 7px;
                }
                .book-card {
                    width: 98%;
                    min-width: 0;
                    padding: 13px 7px 13px 7px;
                }
            }
            @media (max-width: 600px) {
                .books-list {
                    grid-template-columns: 1fr;
                    gap: 11px 0;
                }
                .book-card {
                    width: 99vw;
                    min-width: unset;
                    padding: 9px 3px 11px 3px;
                }
                .book-card img, .book-card .img-preview {
                    height: 110px;
                }
            }
            /* Footer */
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
        <%
           
            List<BookDTO> books = (List<BookDTO>) request.getAttribute("books");
            
        %>
        <!-- Header -->
        <div class="header">
            <div class="header-wrap">
                <a class="logo" href="<%=request.getContextPath()%>/home"><i class="fa-solid fa-book-open"></i> ABC <span style="color:#111;font-weight:400">Book</span></a>
                <div class="search-bar">
                    <form action="ProductController" method="post" style="display:flex;align-items:center;">
                        <input type="hidden" name="action" value="searchBook">
                        <input type="text" name="strKeyword" placeholder="Search book by author or publisher"
                               style="flex:1; padding:11px 44px 11px 20px; border:1px solid #ececec; border-radius:22px; font-size:1.02rem; background:#fafafa;">
                        <button type="submit" style="position:absolute;top:8px;right:12px;border:none;background:transparent;color:#ea2222;font-size:1.15rem;cursor:pointer;">
                            <i class="fa-solid fa-search"></i>
                        </button>
                    </form>
                </div>

                <div class="header-menu">
                    <a href="<%=request.getContextPath()%>/home" class="active">Home</a>
                    <a href="category.jsp">Categories</a>
                    <a href="<%=request.getContextPath()%>/CartController?action=viewCart" class="cart-btn"><i class="fa-solid fa-cart-shopping"></i>
                        <span class="cart-count"><%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %></span>
                    </a>
                </div>
                <%
                UserDTO user = (UserDTO) session.getAttribute("user");
                 if (user != null) {
                %>
                <% if(AuthUtils.isLoggedIn(request)){%>
                <div class="btn-group">
                    <button type="button" class="btn btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <%= user.getFullName() %>
                    </button>
                    <div class="dropdown-menu dropdown-menu-right">
                        <a class="dropdown-item" href="viewDiscounts.jsp">View Discounts Code</a>
                        <a class="dropdown-item" href="addressList.jsp">Your Address</a>
                        <a class="dropdown-item" href="OrderController?action=listOrder">View History</a>

                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="reset.jsp">Reset Password</a>
                    </div>
                    <%}%>

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
                    <a href="cart.jsp" class="cart-btn" title="Go to cart">
    <i class="fa fa-shopping-cart"></i>
    <span class="cart-count">
        <%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %>
    </span>
</a>
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
        <% if (AuthUtils.isAdmin(request)) { %>
        <div class="add-book-bar">
            <a href="inventory.jsp" class="sign-btn" style="margin-left:12px;">Inventory</a>
        </div>
        <% } %>



        <!-- Latest/New Books Section -->
        <div class="best-seller-section" style="margin-top:48px;">
            <div style="display:flex;align-items:center;justify-content:space-between;">
                <div class="best-title" style="margin-bottom:0;">Books</div>
                <% if (session.getAttribute("user") != null && AuthUtils.isAdmin(request)) { %>
                <a class="sign-btn" href="productForm.jsp">+ Add Book</a>
                <% } %>
            </div>
            <div class="books-list">
                <%
                    if (books != null && !books.isEmpty()) {
                        for (BookDTO book : books) {
                %>
                <a class="book-card" href="book/<%= book.getBookID() %>" style="position:relative; display: block;">
                    <img id="preview" class="img-preview"
                         src="<%= (book != null && book.getImage() != null && !book.getImage().equals("null") && !book.getImage().isEmpty()) ? book.getImage() : "" %>"
                         alt="Preview Image"/>

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
                        <button type="submit" class="del-btn" title="udate book">
                            <i class="fa-solid fa-pen"></i>
                        </button>
                    </form>

                    <form method="post" action="ProductController"
                          style="position:absolute;top:10px;right:10px;">
                        <input type="hidden" name="action" value="deleteBook">
                        <input type="hidden" name="bookID" value="<%= book.getBookID() %>">
                        <button type="submit" class="del-btn" title="Xóa sách"
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
                <div class="no-books">No books found.</div>
                <%
                    }
                %>
            </div>
        </div>

        <footer>
            <div class="footer-wrap">
                <div class="footer-col">
                    <a href="#" class="footer-logo"><i class="fa-solid fa-book-open"></i> ABC <span style="color:#fff;font-weight:400">Book</span></a>
                    <div class="footer-desc">
                        ABC Book - Online book ordering platform, diverse titles, nationwide delivery.
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
                        <li><a href="#">Book genres</a></li>
                        <li><a href="#">New books</a></li>
                        <li><a href="#">Best sellers</a></li>
                        <li><a href="#">Blog</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <div class="footer-title">Support</div>
                    <ul class="footer-list">
                        <li><a title="Use Chatbot for more info">Return policy</a></li>
                        <li><a title="Use Chatbot for more info">FAQ</a></li>
                        <li><a title="Use Chatbot for more info">Contact support</a></li>
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
        <!--Start of Tawk.to Script-->
        <script type="text/javascript">
                                            var Tawk_API = Tawk_API || {}, Tawk_LoadStart = new Date();
                                            (function () {
                                                var s1 = document.createElement("script"), s0 = document.getElementsByTagName("script")[0];
                                                s1.async = true;
                                                s1.src = 'https://embed.tawk.to/6879c8a03d9d30190be79d42/1j0drfcq5';
                                                s1.charset = 'UTF-8';
                                                s1.setAttribute('crossorigin', '*');
                                                s0.parentNode.insertBefore(s1, s0);
                                            })();
        </script>
    </body>
</html>
