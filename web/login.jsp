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
            background: linear-gradient(135deg, #e3f2fd, #fff3e0);
            background-size: 200% 200%;
            animation: gradientFlow 8s ease infinite;
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
            background: #fff;
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
            color: #0d47a1;
            font-weight: 600;
            text-align: center;
            margin-bottom: 25px;
        }

        .input-group-text {
            background-color: #bbdefb;
            border-right: none;
        }

        .form-control:focus {
            border-color: #0d47a1;
            box-shadow: 0 0 0 0.2rem rgba(13, 71, 161, 0.25);
        }

        .btn-login {
            background: linear-gradient(to right, #0d47a1, #1976d2);
            border: none;
            color: white;
            font-weight: 600;
            transition: transform 0.2s ease;
            border-radius: 8px;
        }

        .btn-login:hover {
            transform: scale(1.05);
            background: linear-gradient(to right, #1565c0, #1e88e5);
        }

        .btn-signup {
            background-color: #ffa726;
            color: white;
            font-weight: 600;
            border-radius: 8px;
        }

        .btn-signup:hover {
            background-color: #fb8c00;
        }

        .message {
            color: red;
            text-align: center;
            font-style: italic;
            margin-top: 15px;
        }
        
        .successMessage {
            color: green;
            text-align: center;
            font-style: italic;
            margin-top: 15px;
        }

        .toggle-icon {
            cursor: pointer;
            user-select: none;
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
            <input type="password" class="form-control" id="passwordInput" name="strPassword" placeholder="Password" required />
            <span class="input-group-text toggle-icon" onclick="togglePassword()">
                <i id="toggleIcon" class="bi bi-eye"></i>
            </span>
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
    <p><a href="reset.jsp">Forgot Password?</a></p>


    <%
        String message = (String) request.getAttribute("message");
        String successMessage = (String) request.getAttribute("successMessage");
    %>
    <div class="message"><%=message!=null?message:"" %></div>
    <div class="successMessage"><%=successMessage!=null?successMessage:"" %></div>
    <div style="text-align: right; margin-top: 5px;">
    <a href="home.jsp" class="back-link" style="color: red; text-decoration: none;">← Back</a>
</div
   
</div>
<%
    }
%>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById("passwordInput");
        const icon = document.getElementById("toggleIcon");

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            icon.classList.remove("bi-eye");
            icon.classList.add("bi-eye-slash");
        } else {
            passwordInput.type = "password";
            icon.classList.remove("bi-eye-slash");
            icon.classList.add("bi-eye");
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
