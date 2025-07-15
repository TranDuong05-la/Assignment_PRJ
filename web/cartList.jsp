<%-- 
    Document   : cartList
    Created on : Jul 8, 2025, 11:10:39 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.CartDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart List Page</title>
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
        </style>
    </head>
    <body>
        <%
             List<CartDTO> cartList = (List<CartDTO>) request.getAttribute("cartList");
        %>
        <h2>Cart List</h2>
        
        <%
            String message = (String) request.getAttribute("message");
            if (message != null && !message.isEmpty()) { %>
        <div class="message"><%= message %></div>
        <% } %>

        <table border="1" cellpadding="5" cellspacing="0">
            <tr>
                <th>Cart ID</th>
                <th>User ID</th>
                <th>Created Time</th>
                <th>Action</th>
            </tr>
            <% if (cartList != null && !cartList.isEmpty()) {
            for (CartDTO cart : cartList) { %>
            <tr>
                <td><%= cart.getCartId() %></td>
                <td><%= cart.getUserId() %></td>
                <td><%= cart.getCreatedTime() %></td>
                <td>
                    <form action="CartController" method="post" style="display: inline; margin:0;">
                        <input type="hidden" name="action" value="viewCart"/>
                        <input type="hidden" name="cartId" value="<%=cart.getCartId()%>"/>
                        <button type="submit">View Items</button>
                    </form>
                    <form action="CartController" method="post" style="display: inline; margin:0;">
                        <input type="hidden" name="action" value="deleteCart"/>
                        <input type="hidden" name="cartId" value="<%=cart.getCartId()%>"/>
                        <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this cart?')">Delete</button>
                    </form>
                </td>
            </tr>
            <%   }
           } else { %>
            <tr><td colspan="4">No carts found.</td></tr>
            <% } %>
        </table>

        <br>
        <a href="MainController?action=dashboard">Back to Dashboard</a>
    </body>
</html> 