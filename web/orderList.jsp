<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.OrderDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="model.UserDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order History</title>
    <style>
        body { background: #faf9f8; font-family: 'Segoe UI', Arial, sans-serif; margin: 0; }
        .container { max-width: 900px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 4px 32px #0001; padding: 32px 36px; }
        .section-title { font-size: 1.3em; font-weight: bold; color: #ea2222; margin-bottom: 22px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 18px; }
        th, td { border: 1px solid #eee; padding: 10px 8px; text-align: left; }
        th { background: #f7fafd; color: #1d82d2; }
        .empty-msg { color: #888; text-align: center; margin: 40px 0; font-size: 1.1em; }
        .btn { background: #ea2222; color: #fff; border: none; border-radius: 6px; padding: 6px 18px; cursor: pointer; font-weight: 500; }
        .btn:hover { background: #c81c1c; }
    </style>
</head>
<body>
<div class="container">
    <a href="home" style="position:absolute;left:30px;top:30px;color:#ea2222;font-weight:bold;text-decoration:none;font-size:1.1em;">&larr; Back to Dashboard</a>
    <div class="section-title">Order History</div>
    <% if (orderList != null && !orderList.isEmpty()) { %>
    <table>
        <tr>
            <th>Order ID</th>
            <th>Date</th>
            <th>Status</th>
            <th>Total</th>
            <th>Action</th>
        </tr>
        <% for (OrderDTO order : orderList) { %>
        <tr>
            <td><%= order.getOrderID() %></td>
            <td>
                <% try { %>
                    <%= order.getOrderDate() != null && !order.getOrderDate().isEmpty() ? sdf.format(java.sql.Timestamp.valueOf(order.getOrderDate())) : "" %>
                <% } catch(Exception e) { %>
                    <%= order.getOrderDate() %>
                <% } %>
            </td>
            <td><%= order.getStatus() %></td>
            <td>₫<%= String.format("%,.0f", order.getTotalAmount()) %></td>
            <td>
                <form action="OrderController" method="get" style="display:inline;">
                    <input type="hidden" name="action" value="viewOrder" />
                    <input type="hidden" name="orderId" value="<%= order.getOrderID() %>" />
                    <button type="submit" class="btn">View Detail</button>
                </form>
                <% if (user != null && user.getRole() != null && user.getRole().equalsIgnoreCase("admin")) { %>
                <form action="OrderController" method="post" style="display:inline;margin-left:8px;">
                    <input type="hidden" name="action" value="deleteOrder" />
                    <input type="hidden" name="orderId" value="<%= order.getOrderID() %>" />
                    <button type="submit" class="btn" style="background:#e74c3c;">Delete</button>
                </form>
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>
    <% } else { %>
    <div class="empty-msg">You have not placed any orders yet.</div>
    <% } %>
</div>
</body>
</html> 