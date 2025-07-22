<%-- 
    Document   : categories
    Created on : Jul 3, 2025, 11:11:09 AM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.BookDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="model.CategoryDTO" %>
<%@ page import="model.UserDTO" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Categories Page</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            body {
                background: #fff6f6;
                margin:0;
                font-family:'Roboto', Arial, sans-serif;
                color:#222;
            }
            .header {
                width:100%;
                background:#fff;
                box-shadow:0 1px 16px rgba(180,0,0,.07);
                position: sticky;
                top:0;
                z-index:50;
            }
            .header-wrap {
                max-width:1300px;
                margin:0 auto;
                display:flex;
                align-items:center;
                justify-content:space-between;
                height:76px;
                padding:0 32px;
            }
            .logo {
                display:flex;
                align-items:center;
                gap:10px;
                font-size:1.5rem;
                font-weight:bold;
                color:#ea2222;
                text-decoration:none;
            }
            .logo i {
                font-size:2rem;
            }
            .search-bar {
                flex:1;
                max-width:320px;
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
                display:flex;
                gap:28px;
                align-items:center;
                font-size:1.07rem;
            }
            .header-menu a {
                text-decoration:none;
                color:#333;
                padding:4px 0;
            }
            .header-menu a.active, .header-menu a:hover {
                color:#ea2222;
                font-weight:bold;
            }
            .header-right {
                display:flex;
                gap:20px;
                align-items:center;
            }
            .cart-btn {
                position:relative;
                color:#333;
                text-decoration:none;
                font-size:1.35rem;
            }
            .cart-btn .cart-count {
                position:absolute;
                top:-6px;
                right:-8px;
                background:#ea2222;
                color:#fff;
                font-size:.85rem;
                border-radius:50%;
                width:18px;
                height:18px;
                text-align:center;
                line-height:18px;
                font-weight:500;
                border:2px solid #fff;
            }
            .sign-btn {
                background:#ea2222;
                color:#fff;
                border:none;
                border-radius:22px;
                padding:8px 26px;
                font-weight:600;
                font-size:1.08rem;
                text-decoration:none;
                transition:background .18s;
                margin-left:8px;
            }
            .sign-btn:hover {
                background:#d31717;
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
            /* Banner */
            input[type="range"] {
                accent-color: #ea2222;
                height: 6px;
                margin: 0;
            }
            input[type="range"]:focus {
                outline: none;
            }
            .price-label-row span {
                color: #ea2222;
                font-weight: 600;
                min-width: 32px;
                text-align: center;
            }
            .category-banner {
                margin:30px auto 0 auto;
                max-width:900px;
                height:220px;
                background:#222;
                border-radius:20px;
                overflow:hidden;
                display:flex;
                align-items:center;
                justify-content:center;
                position:relative;
            }
            .category-banner img {
                width:100%;
                height:220px;
                object-fit:cover;
                filter:brightness(0.8);
            }
            .category-banner .banner-title {
                position:absolute;
                left:50%;
                top:50%;
                transform:translate(-50%,-50%);
                color:#fff;
                font-size:2.4rem;
                font-weight:bold;
                text-shadow:0 4px 16px #0009;
            }
            /* Main */
            .main-content {
                max-width:1280px;
                margin:0 auto 0 auto;
                padding:36px 0 0 0;
                display:flex;
                gap:38px;
            }
            /* Sidebar Filter */
            .sidebar-filter {
                background:#fff;
                border-radius:9px;
                padding:28px 24px 20px 24px;
                min-width:260px;
                max-width:260px;
                box-shadow:0 3px 14px #cdaaa74d;
                font-size:1rem;
            }
            .sidebar-filter h4 {
                font-size:1.16rem;
                font-weight:bold;
                margin-bottom:15px;
            }
            .sidebar-filter label, .sidebar-filter .custom-radio {
                display:block;
                margin-bottom:11px;
                cursor:pointer;
            }
            .sidebar-filter input[type="radio"] {
                accent-color: #ea2222;
                margin-right:9px;
            }
            .sidebar-filter input[type="checkbox"] {
                accent-color: #ea2222;
                margin-right:9px;
            }
            .sidebar-filter .filter-group {
                margin-bottom:28px;
            }
            .sidebar-filter .price-range {
                margin:9px 0;
            }
            .sidebar-filter .price-values {
                font-size:.98rem;
                color:#ea2222;
                margin-top:5px;
            }
            .sidebar-filter select {
                width:100%;
                padding:7px 8px;
                border-radius:7px;
                border:1px solid #ddd;
            }
            /* Book Grid */
            .books-section {
                flex:1 1 0%;
            }
            .books-top {
                display:flex;
                justify-content:flex-end;
                align-items:center;
                margin-bottom:20px;
            }
            .sort-select {
                padding:7px 12px;
                border-radius:7px;
                border:1px solid #ececec;
                font-size:1rem;
            }
            .book-grid {
                display:grid;
                grid-template-columns:repeat(auto-fill, minmax(180px, 1fr));
                gap:21px;
            }
            .book-card {
                background:#fff;
                border-radius:10px;
                box-shadow:0 3px 14px #cdaaa74d;
                padding:12px 12px 18px 12px;
                display:flex;
                flex-direction:column;
                align-items:flex-start;
                border:1px solid #f1e6e4;
                transition:box-shadow .2s;
                position:relative;
            }
            .book-card:hover {
                box-shadow:0 8px 32px #ea22224a;
            }
            .book-card img {
                width:100%;
                height:220px;
                object-fit:cover;
                border-radius:7px;
                margin-bottom:10px;
            }
            .book-card .book-title {
                font-weight:600;
                font-size:1.06rem;
                color:#2d1d12;
                margin-bottom:2px;
            }
            .book-card .author {
                font-size:.97rem;
                color:#888;
                margin-bottom:8px;
            }
            .book-card .stars {
                color:#faad14;
                margin-bottom:3px;
                font-size:1rem;
            }
            .book-card .review-count {
                font-size:.97rem;
                color:#9e6144;
                margin-bottom:4px;
            }
            .book-card .price {
                color:#ea2222;
                font-size:1.14rem;
                font-weight:700;
                letter-spacing:1px;
                margin-bottom:2px;
            }
            .browse-more-btn {
                display:block;
                margin:33px auto 55px auto;
                padding:10px 34px;
                border-radius:22px;
                border:1.5px solid #ea2222;
                color:#ea2222;
                background:#fff;
                font-weight:600;
                font-size:1.09rem;
                transition:background .2s;
                cursor:pointer;
            }
            .browse-more-btn:hover {
                background:#ea2222;
                color:#fff;
            }
            @media (max-width: 1000px) {
                .main-content {
                    flex-direction:column;
                    gap:18px;
                }
                .sidebar-filter {
                    max-width:100vw;
                    min-width:0;
                }
            }
            @media (max-width: 650px) {
                .book-grid {
                    grid-template-columns:repeat(2, 1fr);
                }
                .category-banner {
                    max-width:99vw;
                }
            }
            /* FOOTER giữ nguyên home.jsp */
            /* ...copy lại phần CSS footer từ home.jsp... */
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
            @media (max-width:600px){
                .footer-col {
                    min-width: 0;
                    margin-bottom: 26px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="header">
            <div class="header-wrap">
                <a class="logo" href="#"><i class="fa-solid fa-book-open"></i> ABC <span style="color:#111;
                                                                                         font-weight:400">Book</span></a>
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
                    <a href="CartController?action=viewCart" class="cart-btn"><i class="fa-solid fa-cart-shopping"></i>
                    <span class="cart-count"><%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %></span>
                </a>
                </div>
                <div class="header-right">
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
                    </div>

                    
                    

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


        <%
            List<BookDTO> products = (List<BookDTO>) request.getAttribute("products");
            List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
            String selectedCategoryId = request.getParameter("categoryID");
            String priceMinStr = (String) request.getAttribute("priceMin");
            String priceMaxStr = (String) request.getAttribute("priceMax");
            int defaultMin = 0;
            int defaultMax = 500;
            int minValue = (priceMinStr != null && !priceMinStr.isEmpty()) ? Integer.parseInt(priceMinStr) : defaultMin;
            int maxValue = (priceMaxStr != null && !priceMaxStr.isEmpty()) ? Integer.parseInt(priceMaxStr) : defaultMax;
            String selectedPub = (String) request.getAttribute("selectedPub");
            String selectedAuthor = (String) request.getAttribute("selectedAuthor");
            String selectedRating = (String) request.getAttribute("selectedRating");
        %>
        <!-- Banner -->
        <div class="category-banner">
            <img src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80" alt="">
            <span class="banner-title">Book Category</span>
        </div>
        <div class="best-seller-section" style="margin-top:48px;">
            <div style="display: flex; justify-content: flex-end;">
                <% if (session.getAttribute("user") != null && AuthUtils.isAdmin(request)) { %>
                <form action="CategoryController" method="get" style="display:inline;">
                    <input type="hidden" name="action" value="addCategory">
                    <button class="sign-btn" style="margin-right:10px;" type="submit">+ Add Category</button>
                </form>
                <% } %>
            </div>
        </div>

        <div class="main-content">
            <!-- Sidebar Filter -->
            <div class="sidebar-filter">
                <form action="MainController" method="post">
                    <div class="filter-group">
                        <h4>Filter by Category</h4>

                        <input type="hidden" name="action" value="listCategory"/>
                        <% if (categories != null && !categories.isEmpty()) {
                            for (CategoryDTO cat : categories) { %>
                        <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px;">
                            <label style="flex:1;display:flex;align-items:center;gap:8px;margin:0;">
                                <input type="checkbox" name="categoryID" value="<%=cat.getCategoryID()%>"
                                       <%= (selectedCategoryId != null && selectedCategoryId.equals(String.valueOf(cat.getCategoryID()))) ? "checked" : "" %> />
                                <span><%= cat.getCategoryName() %></span>
                            </label>
                            <% if (session.getAttribute("user") != null && utils.AuthUtils.isAdmin(request)) { %>
                            <form action="CategoryController" method="post" style="display:inline;margin:0;">
                                <input type="hidden" name="action" value="deleteCategory"/>
                                <input type="hidden" name="categoryID" value="<%=cat.getCategoryID()%>"/>
                                <button type="submit" style="background:#ea2222;color:#fff;border:none;border-radius:6px;padding:3px 10px;font-size:0.97rem;font-weight:bold;cursor:pointer;"
                                        onclick="return confirm('Delete this category?');">
                                    <i class="fa fa-trash"></i>
                                </button>
                            </form>
                            <% } %>
                        </div>
                        <%  }
                         } else { %>
                        <span>No Found Categories.</span>
                        <% } %>
                    </div>
                    <!-- Price Filter -->
                    <div class="filter-group" style="margin-bottom: 24px;">
                        <h4>Filter by Price</h4>
                        <div style="width: 100%; margin: 18px 0 8px 0;">
                            <input 
                                type="range" min="0" max="500" step="1"
                                value="<%= minValue %>" 
                                name="priceMax" id="priceMax"
                                style="width:100%;" 
                                oninput="onSliderChange()"
                                >
                        </div>
                        <div class="price-label-row" style="display:flex; justify-content:space-between; font-size:1rem; margin-top: 6px;">
                            <span>0</span>
                            <span id="priceMaxLabel"><%= minValue %></span>
                            <span>500</span>
                        </div>
                    </div>

                    <!-- Publisher Filter -->
                    <div class="filter-group">
                        <h4>Filter by Publisher</h4>
                        <label>
                            <input type="checkbox" name="pub" value="Green Publications" <% if ("Green Publications".equals(selectedPub)) out.print("checked"); %> > Green Publications
                        </label>
                        <label>
                            <input type="checkbox" name="pub" value="Arnold Publications" <% if ("Arnold Publications".equals(selectedPub)) out.print("checked"); %> > Arnold Publications
                        </label>
                        <!-- Thêm các nhà xuất bản khác nếu có -->
                    </div>

                    <!-- Author Filter -->
                    <div class="filter-group">
                        <h4>Filter by Author</h4>
                        <label>
                            <input type="checkbox" name="author" value="Phil Harmonic" <% if ("Phil Harmonic".equals(selectedAuthor)) out.print("checked"); %> > Phil Harmonic
                        </label>
                        <label>
                            <input type="checkbox" name="author" value="Buster Hyman" <% if ("Buster Hyman".equals(selectedAuthor)) out.print("checked"); %> > Buster Hyman
                        </label>
                        <!-- Thêm các tác giả khác nếu có -->
                    </div>

                    <!-- Rating Filter -->
                    <div class="filter-group">
                        <h4>Filter by Rating</h4>
                        <select name="rating">
                            <option value="">Filter by Rating</option>
                            <option value="5" <% if ("5".equals(selectedRating)) out.print("selected"); %> >5 sao</option>
                            <option value="4" <% if ("4".equals(selectedRating)) out.print("selected"); %> >4 sao</option>
                        </select>
                    </div>
                    <button type="submit" class="browse-more-btn" style="margin:12px 0 0 0;
                            width:100%;">Lọc</button>
                </form>

            </div>

            <!-- Sách theo Category -->
            <div class="books-section">
                <div class="books-top">
                    <select class="sort-select">
                        <option>Browse by popularity</option>
                        <option>Price: Low to High</option>
                        <option>Price: High to Low</option>
                        <option>Newest</option>
                    </select>
                </div>
                <div class="book-grid">
                    <% if (products != null && !products.isEmpty()) {
                    for (BookDTO book : products) { %>
                    <a class="book-card" href="book/<%= book.getBookID() %>">
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
                    </a>
                    <%  }
                    } else { %>
                    <div>No Found Book in the category.</div>
                    <% } %>
                </div>
                <button class="browse-more-btn">Browse More</button>
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
            function onSliderChange() {
                let slider = document.getElementById('priceMax');
                let label = document.getElementById('priceMaxLabel');
                label.textContent = slider.value;
            }
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
