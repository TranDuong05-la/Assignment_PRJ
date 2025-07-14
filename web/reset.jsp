<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String token = request.getParameter("token");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= (token == null) ? "Reset Password Request" : "Reset Your Password" %></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd, #fff3e0);
            font-family: 'Poppins', sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .reset-card {
            background: #ffffff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
            max-width: 450px;
            width: 100%;
        }

        h3 {
            text-align: center;
            font-weight: 600;
            color: #0d47a1;
            margin-bottom: 25px;
        }

        .form-control:focus {
            border-color: #0d47a1;
            box-shadow: 0 0 0 0.2rem rgba(13, 71, 161, 0.25);
        }

        .btn-reset {
            background: linear-gradient(to right, #0d47a1, #1976d2);
            color: white;
            font-weight: 600;
            border: none;
            border-radius: 8px;
        }

        .btn-reset:hover {
            background: linear-gradient(to right, #1565c0, #1e88e5);
        }

        .message {
            text-align: center;
            color: red;
            margin-bottom: 15px;
            font-style: italic;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #555;
            text-decoration: none;
        }

        .back-link:hover {
            color: #000;
        }
    </style>
</head>
<body>

<div class="reset-card">
    <h3>
        <i class="bi bi-shield-lock-fill"></i>
        <%= (token == null) ? "Reset Password Request" : "Set New Password" %>
    </h3>

    <% if (message != null) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <form action="UserController" method="post">
        <input type="hidden" name="action" value="reset" />
        <% if (token == null) { %>
            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <input type="email" name="email" class="form-control" placeholder="Enter your email" required />
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-reset">Send Reset Link</button>
            </div>
        <% } else { %>
            <input type="hidden" name="token" value="<%= token %>" />
            <div class="mb-3">
                <label class="form-label">New Password</label>
                <input type="password" name="newPassword" class="form-control" placeholder="Enter new password" required />
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-reset">Reset Password</button>
            </div>
        <% } %>
    </form>

    <a href="login.jsp" class="back-link">← Back to Login</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
