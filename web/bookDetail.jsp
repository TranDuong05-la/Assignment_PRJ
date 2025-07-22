<%-- 
    Document   : bookDetail
    Created on : Jul 13, 2025, 10:11:09 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.BookDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="model.UserDTO" %>
<%@ page import="model.BookDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="model.CategoryDTO" %>
<%@ page import="model.ReviewDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Detail</title>
        <!-- Font Awesome, CSS... -->

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
                flex:1;
                max-width:420px;
                margin:0 32px;
                position:relative;
            }
            .search-bar input {
                width:100%;
                padding:11px 44px 11px 20px;
                border:1px solid #ececec;
                border-radius:22px;
                font-size:1.02rem;
                background:#fafafa;
            }
            .search-bar button {
                position:absolute;
                top:8px;
                right:12px;
                border:none;
                background:transparent;
                color:#ea2222;
                font-size:1.15rem;
                cursor:pointer;
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
                margin-left: 8px;
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
            /* DETAIL HEADER */
            .detail-section {
                max-width: 970px;
                margin: 48px auto 0 auto;
            }
            .book-main {
                background: #ff2323;
                border-radius: 8px;
                display: flex;
                align-items: flex-start;
                gap: 40px;
                padding: 38px 55px 38px 38px;
            }
            .book-image {
                flex-shrink: 0;
            }
            .book-image img {
                width: 200px;
                height: 285px;
                object-fit: cover;
                border-radius: 6px;
                box-shadow: 0 2px 10px #b4252525;
            }
            .book-info {
                color: #fff;
            }
            .book-info h2 {
                font-size: 2rem;
                font-weight: bold;
                margin: 0 0 8px 0;
            }
            .book-info .author {
                font-size: 1.1rem;
                margin-bottom: 18px;
                font-style: italic;
                color: #ffe3e3;
            }
            .book-info .price {
                font-size: 1.28rem;
                font-weight: bold;
                margin-bottom: 8px;
            }
            .book-info .stars {
                color: #fff53d;
                font-size: 1.05rem;
                margin-bottom: 4px;
            }
            .book-info .review-count {
                font-size: .97rem;
                color: #ffd8d8;
            }
            .book-info .btns {
                margin-top: 17px;
            }
            .book-info .btn {
                background: #fff;
                color: #ea2222;
                padding: 7px 22px;
                border-radius: 21px;
                border:none;
                font-weight: bold;
                font-size: 1rem;
                margin-right: 11px;
                cursor:pointer;
                transition: background 0.18s;
            }
            .book-info .btn:hover {
                background: #ffeaea;
            }
            /* Tab section */
            .tab-section {
                max-width: 970px;
                margin: 25px auto 30px auto;
            }
            .tabs {
                display: flex;
                gap: 9px;
            }
            .tab-btn {
                background: #fff;
                color: #ea2222;
                border: 1.2px solid #ea2222;
                border-radius: 14px;
                padding: 6px 22px;
                font-weight: 500;
                cursor: pointer;
                transition: background .15s;
                font-size: 1rem;
            }
            .tab-btn.active, .tab-btn:hover {
                background: #ea2222;
                color: #fff;
            }
            .tab-content {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 12px #a52c2c09;
                margin-top: 16px;
                padding: 26px 26px 19px 26px;
                color: #222;
                font-size: 1.07rem;
            }
            /* Footer (giống home.jsp) */
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
            @media (max-width:600px){
                .footer-col {
                    min-width: 0;
                    margin-bottom: 26px;
                }
            }
            @media (max-width:1000px){
                .detail-section, .tab-section {
                    max-width:97vw;
                    padding:0 8px;
                }
                .book-main{
                    padding:19px;
                    gap:18px;
                }
            }
            @media (max-width:600px){
                .book-image img {
                    width:110px;
                    height:160px;
                }
                .book-main{
                    flex-direction:column;
                    align-items:center;
                }
            }
        </style>
    </head>
    <body>
        <%
            BookDTO book = (BookDTO) request.getAttribute("book");
            
            List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("reviews");
                 
           
             if (book == null) {
                out.print("<div style='color:red'>No Found Book</div>");
                return;
            }
        %>


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
                    <a href="./category.jsp">Categories</a>
                    <a href="CartController?action=viewCart" class="cart-btn"><i class="fa-solid fa-cart-shopping"></i>
                    <span class="cart-count"><%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %></span>
                    </a>
                </div>

                
                <% if(AuthUtils.isLoggedIn(request)){%>
                <%
           UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null) {
                %>
                <div class="btn-group">
                    <button type="button" class="btn btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <%= user.getFullName() %>
                    </button>
                    <div class="dropdown-menu dropdown-menu-right">
                        <a class="dropdown-item" href="viewDiscounts.jsp">View Discounts Code</a>
                        <a class="dropdown-item" href="addressList.jsp">Your Address</a>

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
        </div>

        <div class="detail-section">
            <div class="book-main">
                <div class="book-image">
                    <%
                         String img = "";
                        if (book != null && book.getImage() != null && !book.getImage().trim().isEmpty()) {
                            if (book.getImage().startsWith("http")) {
                                img = book.getImage(); // Là link ngoài
                             } else {
                            img = request.getContextPath() + "/" + book.getImage(); // Là file uploads nội bộ
                            }
                        }
                    %>
                    <img src="<%= img %>" width="200" alt="Ảnh sách">
                    <%--<%=request.getServletContext().getRealPath("/uploads")%>--%>
                </div>
                <div class="book-info">
                    <h2><%= book.getBookTitle() %></h2>
                    <div class="author">by <%= book.getAuthor() %></div>
                    <div class="price">$<%= book.getPrice() %></div>
                    <div class="stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star-half-alt"></i>

                    </div>
                    <div class="btns">
                        <button class="btn">Add To Cart</button>
                        <button class="btn"><i class="fa fa-heart"></i></button>
                    </div>
                </div>
            </div>
        </div>

        <div class="tab-section">
            <div class="tabs">
                <button class="tab-btn active" type="button">All</button>
                <button class="tab-btn" type="button">Description</button>
                <button class="tab-btn" type="button">Author</button>
                <button class="tab-btn" type="button">Review</button>
            </div>
            <div class="tab-content" id="tab-desc">
                <%= book.getDescription() %>
            </div>
            <div class="tab-content d-none" id="tab-author">
                <b>Aúthour:</b> <%= book.getAuthor() %><br>
                <b>Publisher:</b> <%= book.getPublisher() %>
            </div>
            <div class="tab-content d-none" id="tab-review">
                <% if (reviews != null && !reviews.isEmpty()) { %>
                <% for (ReviewDTO r : reviews) { %>
                <div style="border-bottom:1px solid #eee;margin-bottom:16px;padding-bottom:8px">
                    <b><%= r.getUserID() %></b>
                    <span>(<%= r.getRating() %>/5 sao)</span>:<br/>
                    <span><%= r.getComment() %></span>
                    <br>
                    <span style="color:#888;font-size:12px"><%= r.getReviewDate() %></span>
                </div>
                <% } %>
                <% } else { %>
                <i>Have not reviews.</i>
                <% } %>
            </div>

        </div>
        <div style="text-align:center; margin:36px 0 24px 0;">
            <a href="<%=request.getContextPath()%>/home" style="
               display:inline-block;
               background:#ea2222;
               color:#fff;
               border-radius:22px;
               padding:9px 32px;
               font-weight:600;
               font-size:1.08rem;
               text-decoration:none;
               transition:background .18s;
               " onmouseover="this.style.background = '#d31717'" onmouseout="this.style.background = '#ea2222'">
                ← Back Home
            </a>
        </div>


        <!-- Footer (giống home.jsp) -->
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
                        <li><a href="#">Return policy</a></li>
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Contact support</a></li>
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

        <script>
            const tabBtns = document.querySelectorAll('.tab-btn');
            const tabContents = document.querySelectorAll('.tab-content');
            tabBtns.forEach((btn, idx) => {
                btn.onclick = function () {
                    tabBtns.forEach(b => b.classList.remove('active'));
                    tabContents.forEach(t => t.classList.add('d-none'));
                    btn.classList.add('active');
                    tabContents[idx].classList.remove('d-none');
                }
            });
        </script>
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
