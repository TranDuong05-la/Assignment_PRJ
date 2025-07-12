<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
<head>
    <title>QR Payment</title>
</head>
<body>
    <%
            UserDTO user = AuthUtils.getCurrentUser(request);
            if (!AuthUtils.isLoggedIn(request)) {
                response.sendRedirect("MainController");
                return;
            }
        %>
    <h2>QR Code Payment</h2>

    <% 
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
        <p style="color: green;"><b><%= message %></b></p>
        <br/>
        <a href="home.jsp">Back to home</a>
    <%
        } else {
            String qrUrl = (String) request.getAttribute("qrUrl");
            int orderID = (Integer) request.getAttribute("orderID");
            double amount = (Double) request.getAttribute("amount");
    %>
        <p>Order ID: <%= orderID %></p>
        <p>Amount: <%= amount %> VND</p>
        <img src="<%= qrUrl %>" width="300" alt="QR Code" />
        <br/><br/>
        <form action="PaymentController" method="post">
            <input type="hidden" name="action" value="confirm" />
            <input type="hidden" name="orderID" value="<%= orderID %>" />
            <input type="hidden" name="amount" value="<%= amount %>" />
            <input type="submit" value="I have paid" />
        </form>
    <%
        }
    %>
</body>
</html>
