<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<%
    UserDTO user = AuthUtils.getCurrentUser(request);
    if (!AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("MainController");
        return;
    }

    String message = (String) request.getAttribute("message");
    String qrUrl = (String) request.getAttribute("qrUrl");
    int orderID = (Integer) request.getAttribute("orderID");
    double originalAmount = (Double) request.getAttribute("amount");
    Double finalAmountObj = (Double) request.getAttribute("finalAmount");
    double finalAmount = (finalAmountObj != null) ? finalAmountObj : originalAmount;
    String discountCode = (String) request.getAttribute("discountCode");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>QR Payment</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #e0f7fa, #f5f5f5); /* mint green to light grey */
            color: #333;
            padding-top: 40px;
            font-family: 'Segoe UI', sans-serif;
        }

        .container {
            background-color: #ffffffcc;
            border-radius: 16px;
            padding: 30px;
            max-width: 500px;
            margin: auto;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }

        h2, h4 {
            text-align: center;
            color: #00695c;
        }

        .form-control, .btn {
            border-radius: 10px;
        }

        .btn-primary {
            background-color: #00796b;
            border: none;
        }

        .btn-primary:hover {
            background-color: #004d40;
        }

        .btn-success {
            background-color: #43a047;
            border: none;
        }

        .btn-success:hover {
            background-color: #2e7d32;
        }

        img {
            display: block;
            margin: 20px auto;
            border: 4px solid #ccc;
            border-radius: 10px;
        }

        .message {
            text-align: center;
            font-weight: bold;
            color: #d84315;
        }

        hr {
            border-top: 1px solid #ccc;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>QR Code Payment</h2>

    <% if (message != null) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <p><strong>Order ID:</strong> <%= orderID %></p>
    <p><strong>Amount:</strong> <%= String.format("%,.0f", finalAmount) %> VND</p>

    <img src="<%= qrUrl %>" width="300" alt="QR Code" />

    <hr>
    <h4>Apply Discount Code</h4>
    <form action="MainController" method="post" class="mb-3">
        <input type="hidden" name="action" value="applyDiscount" />
        <input type="hidden" name="orderID" value="<%= orderID %>" />
        <input type="hidden" name="amount" value="<%= originalAmount %>" />
        <input type="text" name="discountCode" class="form-control mb-2"
               placeholder="Enter discount code"
               value="<%= (discountCode != null) ? discountCode : "" %>" />
        <button type="submit" class="btn btn-primary w-100">Apply</button>
    </form>

    <hr>
    <form action="MainController" method="post">
        <input type="hidden" name="action" value="confirm" />
        <input type="hidden" name="orderID" value="<%= orderID %>" />
        <input type="hidden" name="amount" value="<%= finalAmount %>" />
        <button type="submit" class="btn btn-success w-100">I have paid</button>
    </form>
        <div class="text-center">
            <a href="home.jsp" class="btn btn-link">← Back to home</a>
        </div>
</div>
</body>
</html>
