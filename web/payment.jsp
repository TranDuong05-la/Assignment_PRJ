<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<%
    UserDTO user = AuthUtils.getCurrentUser(request);
    if (!AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("MainController");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>QR Payment</title>
</head>
<body>
    <h2>QR Code Payment</h2>

    <%
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
        <p style="color: red;"><b><%= message %></b></p>
    <%
        }

        String qrUrl = (String) request.getAttribute("qrUrl");
        int orderID = (Integer) request.getAttribute("orderID");
        double originalAmount = (Double) request.getAttribute("amount");
        Double finalAmountObj = (Double) request.getAttribute("finalAmount");
        double finalAmount = (finalAmountObj != null) ? finalAmountObj : originalAmount;
        String discountCode = (String) request.getAttribute("discountCode");
    %>

    <p><b>Order ID:</b> <%= orderID %></p>
    <p><b>Amount:</b> <%= finalAmount %> VND</p>
    <img src="<%= qrUrl %>" width="300" alt="QR Code" />

    <hr/>
    <h4>Apply Discount Code</h4>
    <form action="MainController" method="post">
        <input type="hidden" name="action" value="applyDiscount" />
        <input type="hidden" name="orderID" value="<%= orderID %>" />
        <input type="hidden" name="amount" value="<%= originalAmount %>" />
        <input type="text" name="discountCode" placeholder="Enter discount code" 
               value="<%= (discountCode != null) ? discountCode : "" %>" />
        <input type="submit" value="Apply" />
    </form>

    <hr/>
    <form action="MainController" method="post">
        <input type="hidden" name="action" value="confirm" />
        <input type="hidden" name="orderID" value="<%= orderID %>" />
        <input type="hidden" name="amount" value="<%= finalAmount %>" />
        <input type="submit" value="I have paid" />
    </form>
</body>
</html>
