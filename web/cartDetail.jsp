<%-- 
    Document   : cartDetail
    Created on : Jul 8, 2025, 11:10:39 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.CartDTO" %>
<%@ page import="model.CartItemDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart Detail Page</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: linear-gradient(120deg, #e3f0ff 0%, #f9fcff 100%);
                margin: 0;
                padding: 0;
            }
            h2 {
                text-align: center;
                color: #1d82d2;
                margin-top: 42px;
                letter-spacing: 1px;
                font-weight: 700;
                font-size: 2em;
                text-shadow: 0 2px 10px #abd8ff55;
            }
            .cart-info {
                width: 70%;
                margin: 20px auto;
                background: #fff;
                border-radius: 18px;
                padding: 20px;
                box-shadow: 0 6px 32px rgba(37,116,169,0.13);
            }
            .cart-info h3 {
                color: #1d82d2;
                margin-bottom: 15px;
                border-bottom: 2px solid #e3f3ff;
                padding-bottom: 10px;
            }
            .cart-info p {
                margin: 8px 0;
                font-size: 1.1em;
            }
            .cart-info strong {
                color: #1d82d2;
            }
            table {
                border-collapse: collapse;
                width: 70%;
                margin: 32px auto 0 auto;
                background: #fff;
                border-radius: 18px;
                overflow: hidden;
                box-shadow: 0 6px 32px rgba(37,116,169,0.13);
            }
            th, td {
                padding: 15px 22px;
                text-align: center;
                font-size: 1.08em;
            }
            th {
                background: #e3f3ff;
                color: #1d82d2;
                font-size: 1.16em;
                font-weight: 600;
                border-bottom: 2.5px solid #acd1f8;
            }
            tr:nth-child(even) {
                background: #f4f9ff;
            }
            tr:nth-child(odd) {
                background: #fff;
            }
            td {
                font-size: 1em;
                border-bottom: 1px solid #e6eef8;
            }
            .message {
                color: #1d82d2;
                text-align: center;
                margin: 10px auto;
                padding: 10px;
                background: #e5f2fb;
                border: 1px solid #acd1f8;
                border-radius: 6px;
                width: 70%;
            }
            form[method="post"] button,
            button[type="submit"] {
                background: linear-gradient(90deg, #61b2fc 60%, #57dbdb 100%);
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 7px 25px;
                font-size: 1em;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.18s, box-shadow 0.17s, transform 0.12s;
                box-shadow: 0 1px 8px #71bfff15;
                outline: none;
                margin: 0 5px;
            }
            form[method="post"] button:hover,
            button[type="submit"]:hover {
                background: linear-gradient(90deg, #3571cb 50%, #0ab5d4 100%);
                transform: translateY(-1px) scale(1.045);
                box-shadow: 0 3px 16px #1d82d245;
            }
            .delete-btn {
                background: linear-gradient(90deg, #ff6b6b 60%, #ff8e8e 100%) !important;
            }
            .delete-btn:hover {
                background: linear-gradient(90deg, #e74c3c 50%, #ff6b6b 100%) !important;
            }
            .checkout-btn {
                background: linear-gradient(90deg, #28a745 60%, #20c997 100%) !important;
            }
            .checkout-btn:hover {
                background: linear-gradient(90deg, #218838 50%, #1ea085 100%) !important;
            }
            a {
                display: block;
                width: fit-content;
                margin: 40px auto 0 auto;
                color: #2472b8;
                background: #e5f2fb;
                border-radius: 8px;
                padding: 10px 32px;
                text-decoration: none;
                font-weight: 500;
                font-size: 1.06em;
                box-shadow: 0 1px 7px #d5eaff80;
                transition: background 0.13s, color 0.13s;
            }
            a:hover {
                background: #1d82d2;
                color: #fff;
                text-decoration: underline;
                transform: scale(1.045);
            }
            .quantity-input {
                width: 60px;
                padding: 5px;
                border: 1px solid #acd1f8;
                border-radius: 4px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <%
             CartDTO cart = (CartDTO) request.getAttribute("cart");
             List<CartItemDTO> cartItems = (List<CartItemDTO>) request.getAttribute("cartItems");
        %>
        <h2>Cart Detail</h2>
        
        <%
            String message = (String) request.getAttribute("message");
            if (message != null && !message.isEmpty()) { %>
        <div class="message"><%= message %></div>
        <% } %>

        <% if (cart != null) { %>
        <div class="cart-info">
            <h3>Cart Information</h3>
            <p><strong>Cart ID:</strong> <%= cart.getCartId() %></p>
            <p><strong>User ID:</strong> <%= cart.getUserId() %></p>
            <p><strong>Created Time:</strong> <%= cart.getCreatedTime() %></p>
        </div>
        <% } %>

        <table border="1" cellpadding="5" cellspacing="0">
            <tr>
                <th>Product ID</th>
                <th>Quantity</th>
                <th>Action</th>
            </tr>
            <% if (cartItems != null && !cartItems.isEmpty()) {
            for (CartItemDTO item : cartItems) { %>
            <tr>
                <td><%= item.getProductId() %></td>
                <td>
                    <form action="CartController" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="updateQuantity"/>
                        <input type="hidden" name="cartId" value="<%=item.getCartId()%>"/>
                        <input type="hidden" name="productId" value="<%=item.getProductId()%>"/>
                        <input type="number" name="quantity" value="<%=item.getQuantity()%>" min="1" class="quantity-input"/>
                        <button type="submit">Update</button>
                    </form>
                </td>
                <td>
                    <form action="CartController" method="post" style="display: inline; margin:0;">
                        <input type="hidden" name="action" value="removeItem"/>
                        <input type="hidden" name="cartId" value="<%=item.getCartId()%>"/>
                        <input type="hidden" name="productId" value="<%=item.getProductId()%>"/>
                        <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to remove this item?')">Remove</button>
                    </form>
                </td>
            </tr>
            <%   }
           } else { %>
            <tr><td colspan="3">No items in cart.</td></tr>
            <% } %>
        </table>

        <% if (cartItems != null && !cartItems.isEmpty()) { %>
        <div style="text-align: center; margin-top: 20px;">
            <form action="OrderController" method="post" style="display: inline;">
                <input type="hidden" name="action" value="createOrderFromCart"/>
                <input type="hidden" name="cartId" value="<%=cart.getCartId()%>"/>
                <button type="submit" class="checkout-btn">Checkout</button>
            </form>
        </div>
        <% } %>

        <br>
        <a href="CartController?action=listCart">Back to Cart List</a>
    </body>
</html> 