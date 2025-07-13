<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Discount</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd, #fff3e0);
            background-size: 200% 200%;
            animation: gradientMove 10s ease infinite;
            font-family: 'Poppins', sans-serif;
            padding: 50px 0;
        }

        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            max-width: 620px;
            background: #ffffff;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
            color: #333;
        }

        h2 {
            text-align: center;
            color: #0d47a1;
            margin-bottom: 25px;
            font-weight: 600;
        }

        .form-label {
            font-weight: 500;
            color: #333;
        }

        .form-control, .form-select {
            border-radius: 8px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d47a1;
            box-shadow: 0 0 0 0.2rem rgba(13, 71, 161, 0.25);
        }

        .btn-primary {
            background: linear-gradient(to right, #0d47a1, #1976d2);
            border: none;
            font-weight: 600;
            border-radius: 10px;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #1565c0, #1e88e5);
        }

        .btn-link {
            font-weight: 500;
            margin-top: 15px;
            color: #0d47a1;
        }

        .btn-link:hover {
            text-decoration: underline;
        }

        .message {
            color: #d32f2f;
            text-align: center;
            font-weight: 500;
            margin-bottom: 20px;
        }

        @media (max-width: 576px) {
            .container {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
<%
    if (AuthUtils.isAdmin(request)) {
        String message = (String) request.getAttribute("message");
%>
    <div class="container">
        <h2><i class="bi bi-percent"></i> Create New Discount Code</h2>

        <% if (message != null) { %>
            <div class="message"><%= message %></div>
        <% } %>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="create" />

            <div class="mb-3">
                <label class="form-label">Code:</label>
                <input type="text" name="code" class="form-control" required />
            </div>

            <div class="mb-3">
                <label class="form-label">Type:</label>
                <select name="type" class="form-select">
                    <option value="percent">Percent</option>
                    <option value="fixed">Fixed</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Value:</label>
                <input type="number" name="value" class="form-control" step="0.01" required />
            </div>

            <div class="mb-3">
                <label class="form-label">Min Order Amount:</label>
                <input type="number" name="minOrderAmount" class="form-control" step="0.01" value="0" />
            </div>

            <div class="mb-3">
                <label class="form-label">Expiry Date:</label>
                <input type="date" name="expiryDate" class="form-control" required />
            </div>

            <div class="d-grid">
                <input type="submit" value="Create Discount" class="btn btn-primary" />
            </div>
        </form>

        <div class="text-center">
            <a href="viewDiscounts.jsp" class="btn btn-link"><i class="bi bi-arrow-left-circle"></i> Back to Discounts</a>
        </div>
    </div>
<%
    } else {
%>
    <div class="container text-center">
        <h4 class="text-danger"><%= AuthUtils.getAccessDeniedMessage("Discount form page") %></h4>
    </div>
<%
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
