<%-- 
    Document   : cartList
    Created on : Jul 8, 2025, 11:10:39 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.CartDTO" %>
<%@ page import="model.CartItemDTO" %>
<%@ page import="model.BookDTO" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="model.CartDAO" %>
<%
    CartDTO cart = (CartDTO) session.getAttribute("cart");
    if (cart == null) {
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            cart = cartDAO.getCartByUserId(user.getUserID());
            session.setAttribute("cart", cart);
            session.setAttribute("cartCount", (cart != null && cart.getItems() != null) ? cart.getItems().size() : 0);
        }
    }
    List<CartItemDTO> items = (cart != null) ? cart.getItems() : null;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; background: #fff; }
        .header { width: 100%; background: #fff; box-shadow: 0 1px 16px rgba(180,0,0,.07); padding: 0; position: sticky; top: 0; z-index: 50; }
        .header-wrap { max-width: 1300px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; height: 76px; padding: 0 32px; }
        .logo { display: flex; align-items: center; gap: 10px; font-size: 1.5rem; font-weight: bold; color: #ea2222; text-decoration: none; }
        .logo i { font-size: 2rem; }
        .search-bar { flex: 1; max-width: 420px; margin: 0 32px; position: relative; display: flex; align-items: center; }
        .search-bar input { width: 100%; padding: 11px 44px 11px 20px; border: 1px solid #ececec; border-radius: 22px; font-size: 1.02rem; background: #fafafa; transition: border .2s; }
        .search-bar input:focus { border-color: #ea2222; outline: none; }
        .search-bar button { position: absolute; right: 12px; background: transparent; border: none; color: #ea2222; font-size: 1.15rem; cursor: pointer; }
        .header-menu { display: flex; gap: 28px; align-items: center; font-size: 1.07rem; }
        .header-menu a { text-decoration: none; color: #333; padding: 4px 0; position: relative; }
        .header-menu a.active, .header-menu a:hover { color: #ea2222; font-weight: bold; }
        .header-right { display: flex; gap: 20px; align-items: center; }
        .cart-btn { position: relative; color: #333; text-decoration: none; font-size: 1.35rem; padding: 3px 5px; }
        .cart-btn .cart-count { position: absolute; top: -6px; right: -8px; background: #ea2222; color: #fff; font-size: .85rem; border-radius: 50%; width: 18px; height: 18px; text-align: center; line-height: 18px; font-weight: 500; border: 2px solid #fff; }
        .sign-btn { background: #ea2222; color: #fff; border: none; border-radius: 22px; padding: 8px 26px; font-weight: 600; font-size: 1.08rem; text-decoration: none; transition: background .18s; margin-left: 8px; cursor: pointer; }
        .sign-btn:hover { background: #d31717; }
        .cart-header { position: relative; width: 100%; height: 110px; background: url('https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1500&q=80') center/cover no-repeat; display: flex; align-items: center; justify-content: center; }
        .cart-header h1 { color: #fff; font-size: 3em; text-shadow: 0 2px 16px #000a; }
        .cart-container {
            max-width: 1100px;
            margin: -120px auto 40px auto; /* Kéo khung trắng lên trên ảnh nền */
            position: relative; /* Đảm bảo nó nổi lên trên */
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 6px 32px rgba(37,116,169,0.13);
            padding: 40px 32px 32px 32px;
        }
        .cart-container h1 {
            text-align: center;
            color: #444;
            font-size: 2.5em;
            margin-bottom: 24px;
            font-weight: 600;
        }
        table { width: 100%; border-collapse: collapse; margin-top: 24px; }
        th, td { padding: 18px 12px; text-align: center; }
        th { background: #f7fafd; color: #1d82d2; font-size: 1.1em; border-bottom: 2px solid #e3eaf3; }
        tr { border-bottom: 1px solid #f0f0f0; }
        .product-img { width: 48px; height: 64px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 8px #0001; }
        .product-title { font-weight: 600; font-size: 1.08em; color: #222; text-align: left; }
        .product-desc { color: #888; font-size: 0.98em; text-align: left; }
        .qty-box { display: flex; align-items: center; justify-content: center; }
        .qty-btn { width: 28px; height: 28px; border: none; background: #f2f6fa; color: #1d82d2; font-size: 1.2em; border-radius: 6px; cursor: pointer; margin: 0 4px; }
        .qty-input { width: 38px; text-align: center; border: 1px solid #e3eaf3; border-radius: 6px; padding: 4px; font-size: 1em; }
        .cart-actions { display: flex; justify-content: flex-end; gap: 18px; margin-top: 32px; }
        .cart-btn { position: relative; color: #333; text-decoration: none; font-size: 1.35rem; padding: 3px 5px; }
        .payment-btn { background: #f39c12; color: #fff; border: none; border-radius: 8px; padding: 10px 32px; font-size: 1.08em; font-weight: 600; cursor: pointer; transition: background 0.18s; }
        .payment-btn:hover { background: #e67e22; }
        .cart-total { text-align: right; font-size: 1.2em; font-weight: 600; margin-top: 18px; color: #1d82d2; }
        .delete-btn { background: #e74c3c; color: #fff; border: none; border-radius: 6px; padding: 6px 14px; font-size: 1em; cursor: pointer; margin-left: 8px; }
        .delete-btn:hover { background: #c0392b; }
        .msg { background: #e5f2fb; color: #1d82d2; border: 1px solid #acd1f8; border-radius: 8px; padding: 14px 24px; font-size: 1.08em; text-align: center; margin: 18px auto 0 auto; max-width: 600px; box-shadow: 0 2px 8px #abd8ff33; }
        .qty-btn-disabled {
          opacity: 0.5 !important;
          cursor: not-allowed !important;
          pointer-events: none;
        }
    </style>
    <script>
        function updateTotal() {
            var checkboxes = document.querySelectorAll('.item-check');
            var total = 0;
            checkboxes.forEach(function(cb) {
                if (cb.checked) {
                    var row = cb.closest('tr');
                    var rowTotal = parseFloat(row.querySelector('.row-total').getAttribute('data-value'));
                    if (!isNaN(rowTotal)) total += rowTotal;
                }
            });
            document.getElementById('grandTotal').innerText = total.toLocaleString('en-US', {style:'currency', currency:'USD'});
        }
        function deleteItem(cartItemID) {
            if(confirm('Do you want to remove this item? It will be moved to Recently Deleted.')) {
                var form = document.createElement('form');
                form.method = 'post';
                form.action = 'CartController';
                form.innerHTML = '<input type="hidden" name="action" value="deleteItem" />' +
                                 '<input type="hidden" name="cartItemID" value="'+cartItemID+'" />';
                document.body.appendChild(form);
                form.submit();
            }
        }
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.item-check').forEach(function(cb) {
                cb.addEventListener('change', updateTotal);
            });
            updateTotal();
            var msg = document.getElementById('cartMsg');
            if(msg) setTimeout(function(){ msg.style.display='none'; }, 2000);
        });
    </script>
    </head>
    <body>
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
                    
                
            </div>
            <div class="header-right">
                <a href="CartController?action=viewCart" class="cart-btn"><i class="fa-solid fa-cart-shopping"></i>
                    <span class="cart-count"><%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %></span>
                </a>
                <<%
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
                        <a class="dropdown-item" href="orderList.jsp">View History</a>

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
    <!-- Banner Background với chữ Cart căn giữa -->
    <div class="cart-banner-bg">
        <h1>Cart</h1>
    </div>

    <!-- Cart Container -->
    <div class="cart-container">
        <% String msg = (String) request.getAttribute("message");
           if (msg != null && !msg.isEmpty()) { %>
        <div class="msg" id="cartMsg"><%=msg%></div>
        <% } %>

        <h2>Your Cart</h2>
        <% if (items != null && !items.isEmpty()) { %>
<form id="cartForm" action="checkout.jsp" method="get">
<table border="1" cellpadding="8" style="width:100%;text-align:center;">
    <tr>
        <th>Select</th>
        <th>Image</th>
        <th>Book Title</th>
        <th>Quantity</th>
        <th>Price</th>
        <th>Total</th>
        <th>Action</th>
    </tr>
    <% for (CartItemDTO item : items) { %>
    <tr>
        <td><input type="checkbox" class="item-check" name="selectedItems" value="<%=item.getCartItemID()%>" checked /></td>
        <td><img src="<%=item.getBook() != null ? item.getBook().getImage() : ""%>" width="50"/></td>
        <td><%=item.getBook() != null ? item.getBook().getBookTitle() : ""%></td>
        <td>
            <div class="qty-box">
                <button type="button" class="qty-btn" onclick="updateQuantity(<%=item.getCartItemID()%>, <%=item.getQuantity()%>, -1)" <%= (item.getQuantity() <= 1) ? "disabled style='opacity:0.5;cursor:not-allowed;'" : "" %>>-</button>
                <input type="text" class="qty-input" value="<%=item.getQuantity()%>" readonly style="width:38px;text-align:center;" />
                <button type="button" class="qty-btn" onclick="updateQuantity(<%=item.getCartItemID()%>, <%=item.getQuantity()%>, 1)" <%= (item.getQuantity() >= 10) ? "disabled style='opacity:0.5;cursor:not-allowed;'" : "" %>>+</button>
            </div>
        </td>
        <td><%=item.getBook() != null ? item.getBook().getPrice() : 0%></td>
        <td class="row-total" data-value="<%= (item.getBook() != null) ? (item.getBook().getPrice() * item.getQuantity()) : 0 %>"><%= (item.getBook() != null) ? (item.getBook().getPrice() * item.getQuantity()) : 0 %></td>
        <td>
            <button type="submit" name="action" value="deleteItem" formaction="CartController" formmethod="post" style="background:#e74c3c;color:#fff;border:none;padding:4px 12px;border-radius:6px;cursor:pointer;" onclick="document.getElementById('cartItemIDInput').value='<%=item.getCartItemID()%>';">Delete</button>
        </td>
    </tr>
    <% } %>
</table>
<input type="hidden" id="actionInput" name="action" value="" />
<input type="hidden" id="cartItemIDInput" name="cartItemID" value="" />
<input type="hidden" id="changeInput" name="change" value="" />
<input type="hidden" id="currentQuantityInput" name="currentQuantity" value="" />
<div class="cart-total">Total: <span id="grandTotal"></span></div>
<div class="cart-actions">
    <a href="cartDetail.jsp" class="payment-btn" style="margin-right:16px;">Restore Items</a>
    <button type="submit" class="payment-btn">Payment</button>
</div>
</form>
        <script>
        function updateQuantity(cartItemID, currentQuantity, change) {
            document.getElementById('actionInput').value = 'updateQuantity';
            document.getElementById('cartItemIDInput').value = cartItemID;
            document.getElementById('changeInput').value = change;
            document.getElementById('currentQuantityInput').value = currentQuantity;
            document.getElementById('cartForm').submit();
        }
        function submitRestore() {
            document.getElementById('actionInput').value = 'viewDeleted';
            document.getElementById('cartForm').submit();
        }
        function submitPayment() {
            document.getElementById('actionInput').value = 'payment';
            document.getElementById('cartForm').submit();
        }
        </script>
        <% } else { %>
        <div style="color:#888;font-size:1.2em;margin:40px 0;">There are no items in your cart.</div>
        <% } %>
    </div>
    <style>
.cart-banner-bg {
  width: 1000px;
  height: 340px;
  margin: 36px auto 0 auto;
  border-radius: 16px;
  overflow: hidden;
  background: url('https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1500&q=80') center/cover no-repeat;
  display: flex;
  align-items: center;
  justify-content: center;
}
.cart-banner-bg h1 {
  color: #fff;
  font-size: 2.2em;
  text-shadow: 0 2px 16px #000a;
  margin: 0;
}
.cart-container {
    max-width: 1100px;
    margin: 30px auto 40px auto;
    position: relative;
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 6px 32px rgba(37,116,169,0.13);
    padding: 40px 32px 32px 32px;
}
.cart-container h1 {
    text-align: center;
    color: #444;
    font-size: 2.5em;
    margin-bottom: 24px;
    font-weight: 600;
}
/* Footer styles 
footer {
  width: 100%;
  background: #231f20;
  margin: 0;
  padding: 0;
}
.footer-wrap {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  color: #fff;
  padding: 48px 32px 24px 32px;
  flex-wrap: nowrap;
  max-width: 1200px;
  margin: 0 auto;
  background: none;
}
.footer-col { flex: 1 1 0; min-width: 180px; margin-right: 0; text-align: left; }
.footer-logo { font-size: 1.5em; color: #ea2222; text-decoration: none; font-weight: bold; display: flex; align-items: center; gap: 10px; margin-bottom: 18px; justify-content: flex-start; }
.footer-logo i { font-size: 2em; }
.footer-title { font-weight: bold; font-size: 1.1em; margin-bottom: 16px; }
.footer-list { list-style: none; padding: 0; margin: 0; }
.footer-list li { margin-bottom: 10px; }
.footer-list a { color: #fff; text-decoration: none; transition: color 0.15s; }
.footer-list a:hover { color: #ea2222; }
.footer-desc { margin-bottom: 18px; font-size: 1em; color: #eee; text-align: left; }
.footer-social { margin-bottom: 18px; text-align: left; }
.footer-social a { color: #ea2222; font-size: 1.3em; margin-right: 16px; transition: color 0.15s; }
.footer-social a:last-child { margin-right: 0; }
.footer-social a:hover { color: #fff; }
.footer-contact { font-size: 1em; color: #eee; text-align: left; }
.footer-contact i { margin-right: 8px; color: #ea2222; }
.footer-bottom { background: #1a1718; color: #ccc; text-align: center; padding: 16px 0 8px 0; font-size: 1em; margin-top: 0; }
@media (max-width: 900px) {
  .footer-wrap { flex-direction: column; gap: 32px; padding: 48px 24px 24px 24px; max-width: 100%; }
  .footer-col { margin-right: 0; margin-bottom: 32px; text-align: center; }
}*/
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