<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.OrderDTO" %>
<%@ page import="model.OrderItemDTO" %>
<%@ page import="model.BookDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    OrderDTO order = (OrderDTO) request.getAttribute("order");
    List<OrderItemDTO> orderItems = (List<OrderItemDTO>) request.getAttribute("orderItems");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Detail</title>
    <style>
        body { background: #faf9f8; font-family: 'Segoe UI', Arial, sans-serif; margin: 0; }
        .container { max-width: 800px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 4px 32px #0001; padding: 32px 36px; }
        .section-title { font-size: 1.3em; font-weight: bold; color: #ea2222; margin-bottom: 22px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 18px; }
        th, td { border: 1px solid #eee; padding: 10px 8px; text-align: left; }
        th { background: #f7fafd; color: #1d82d2; }
        .order-info { margin-bottom: 24px; }
        .order-label { color: #ea2222; font-weight: bold; min-width: 120px; display: inline-block; }
        .order-value { color: #222; font-weight: 500; }
        .empty-msg { color: #888; text-align: center; margin: 40px 0; font-size: 1.1em; }
    </style>
</head>
<body>
<div class="container">
    <a href="OrderController?action=listOrder" style="position:absolute;left:30px;top:30px;color:#ea2222;font-weight:bold;text-decoration:none;font-size:1.1em;">&larr; Back to Order List</a>
    <div class="section-title">Order Detail</div>
    <% if (order != null) { %>
    <div class="order-info">
        <div><span class="order-label">Order ID:</span> <span class="order-value"><%= order.getOrderID() %></span></div>
        <div><span class="order-label">Order Date:</span> <span class="order-value">
        <% try { %>
            <%= order.getOrderDate() != null && !order.getOrderDate().isEmpty() ? sdf.format(java.sql.Timestamp.valueOf(order.getOrderDate())) : "" %>
        <% } catch(Exception e) { %>
            <%= order.getOrderDate() %>
        <% } %>
    </span></div>
        <div><span class="order-label">Status:</span> <span class="order-value"><%= order.getStatus() != null ? order.getStatus() : "-" %></span></div>
        <div><span class="order-label">Total Amount:</span> <span class="order-value">₫<%= String.format("%,.0f", order.getTotalAmount()) %></span></div>
        <div><span class="order-label">Shipping Address:</span> <span class="order-value"><%= order.getShippingAddress() != null ? order.getShippingAddress() : "-" %></span></div>
        <div><span class="order-label">Phone:</span> <span class="order-value"><%= order.getPhone() != null ? order.getPhone() : "-" %></span></div>
        <div><span class="order-label">Note:</span> <span class="order-value"><%= order.getNote() != null ? order.getNote() : "-" %></span></div>
    </div>
    <div class="section-title">Product List</div>
    <table>
        <tr>
            <th>Product</th>
            <th>Title</th>
            <th>Author</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
        </tr>
        <% if (orderItems != null && !orderItems.isEmpty()) {
            for (OrderItemDTO item : orderItems) {
                BookDTO book = item.getBook();
                double total = book.getPrice() * item.getQuantity();
        %>
        <tr>
            <td><img src="<%=book.getImage()%>" alt="img" style="width:48px;height:64px;object-fit:cover;border-radius:6px;box-shadow:0 2px 8px #0001;" /></td>
            <td><%=book.getBookTitle()%></td>
            <td><%=book.getAuthor()%></td>
            <td>₫<%=String.format("%,.0f", book.getPrice())%></td>
            <td><%=item.getQuantity()%></td>
            <td>₫<%=String.format("%,.0f", total)%></td>
        </tr>
        <% } } else { %>
        <tr><td colspan="6" style="text-align:center;color:#888;">No products found.</td></tr>
        <% } %>
    </table>
    <% } else { %>
    <div class="empty-msg">Order not found.</div>
    <% } %>
</div>
</body>
</html> 