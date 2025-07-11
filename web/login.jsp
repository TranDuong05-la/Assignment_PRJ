<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #c8f2e0, #e0fefc);
            background-size: 200% 200%;
            animation: gradientFlow 10s ease infinite;
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Poppins', sans-serif;
        }

        @keyframes gradientFlow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .login-card {
            background: white;
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            max-width: 450px;
            width: 100%;
            animation: fadeIn 0.8s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h3 {
            color: #2fb38b;
            font-weight: 600;
            text-align: center;
            margin-bottom: 25px;
        }

        .input-group-text {
            background-color: #d8f7ee;
            border-right: none;
        }

        .form-control:focus {
            border-color: #2fb38b;
            box-shadow: 0 0 0 0.2rem rgba(47, 179, 139, 0.25);
        }

        .btn-login {
            background: linear-gradient(to right, #2fb38b, #57d9a3);
            border: none;
            color: white;
            font-weight: 600;
            transition: transform 0.2s ease;
        }

        .btn-login:hover {
            transform: scale(1.05);
            background: linear-gradient(to right, #28a67f, #49c892);
        }

        .btn-signup {
            background-color: #a0aec0;
            color: white;
            font-weight: 600;
        }

        .btn-signup:hover {
            background-color: #8b9ab3;
        }

        .message {
            color: red;
            text-align: center;
            font-style: italic;
            margin-top: 15px;
        }
    </style>
</head>
<body>
<%
    if (AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("welcome.jsp");
    } else {
%>
<div class="login-card">
    <h3><i class="bi bi-person-circle"></i> Login</h3>

    <form action="MainController" method="post">
        <input type="hidden" name="action" value="login" />

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
            <input type="text" class="form-control" name="strUsername" placeholder="Username" required />
        </div>

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
            <input type="password" class="form-control" name="strPassword" placeholder="Password" required />
        </div>

        <div class="d-grid mb-2">
            <button type="submit" class="btn btn-login">Login</button>
        </div>
    </form>

    <form action="signUp.jsp" method="get">
        <div class="d-grid">
            <button type="submit" class="btn btn-signup">Signup</button>
        </div>
    </form>

    <%
        Object objMessage = request.getAttribute("message");
        String message = (objMessage == null) ? "" : objMessage.toString();
        if (!message.isEmpty()) {
    %>
    <div class="message"><%= message %></div>
    <%
        }
    %>
</div>
<%
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
