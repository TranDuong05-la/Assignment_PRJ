<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.OrderDTO" %>
<%@ page import="model.OrderItemDTO" %>
<%@ page import="model.BookDTO" %>
<%@ page import="model.AddressDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    OrderDTO order = (OrderDTO) request.getAttribute("order");
    List<OrderItemDTO> orderItems = (List<OrderItemDTO>) request.getAttribute("orderItems");
    AddressDTO address = (AddressDTO) request.getAttribute("address");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
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
    <div class="section-title">Order Detail</div>
    <% if (order != null) { %>
    <div class="order-info">
        <div><span class="order-label">Order ID:</span> <span class="order-value"><%= order.getOrderId() %></span></div>
        <div><span class="order-label">Order Date:</span> <span class="order-value"><%= order.getOrderDate() != null ? order.getOrderDate() : "-" %></span></div>
        <div><span class="order-label">Payment Method:</span> <span class="order-value"><%= order.getPaymentMethod() != null ? order.getPaymentMethod() : "-" %></span></div>
        <div><span class="order-label">Total Amount:</span> <span class="order-value">₫<%= String.format("%,.0f", order.getTotalAmount()) %></span></div>
    </div>
    <div class="section-title">Shipping Address</div>
    <% if (address != null) { %>
        <div style="margin-bottom:18px;">
            <b><%= address.getRecipientName() %> (<%= address.getPhone() %>)</b><br>
            <span><%= address.getAddressDetail() %>, <%= address.getDistrict() %>, <%= address.getCity() %></span>
        </div>
    <% } else { %>
        <div style="color:#888;">No shipping address found.</div>
    <% } %>
    <div class="section-title">Product List</div>
    <table>
        <tr>
            <th>Product</th>
            <th>Author</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
        </tr>
        <% if (orderItems != null && !orderItems.isEmpty()) {
            for (OrderItemDTO item : orderItems) {
                BookDTO book = item.getBook();
        %>
        <tr>
            <td><%= book != null ? book.getBookTitle() : "-" %></td>
            <td><%= book != null ? book.getAuthor() : "-" %></td>
            <td>₫<%= String.format("%,.0f", item.getPrice()) %></td>
            <td><%= item.getQuantity() %></td>
            <td>₫<%= String.format("%,.0f", item.getPrice() * item.getQuantity()) %></td>
        </tr>
        <% } } else { %>
        <tr><td colspan="5" style="text-align:center;color:#888;">No products found.</td></tr>
        <% } %>
    </table>
    <div class="section-title">Comment</div>
    <div style="color:#444;"><%= order.getComment() != null && !order.getComment().isEmpty() ? order.getComment() : "<i>No comment</i>" %></div>
    <% } else { %>
    <div class="empty-msg">Order not found.</div>
    <% } %>
</div>
</body>
</html> 