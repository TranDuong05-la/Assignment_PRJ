<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Signup</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #e3f2fd, #fff3e0);
            background-size: 200% 200%;
            animation: gradientMove 10s ease infinite;
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .signup-container {
            background: #ffffff;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
            width: 100%;
            max-width: 480px;
            animation: fadeIn 1s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            color: #0d47a1;
            font-weight: 600;
            text-align: center;
            margin-bottom: 30px;
        }

        .input-group-text {
            background-color: #bbdefb;
            border-right: none;
            border-radius: 8px 0 0 8px;
        }

        .form-control {
            border-radius: 0 8px 8px 0;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d47a1;
            box-shadow: 0 0 0 0.2rem rgba(13, 71, 161, 0.25);
        }

        .btn-register {
            background: linear-gradient(to right, #0d47a1, #1976d2);
            border: none;
            color: white;
            font-weight: 600;
            transition: transform 0.2s ease;
            border-radius: 8px;
        }

        .btn-register:hover {
            transform: scale(1.05);
            background: linear-gradient(to right, #1565c0, #1e88e5);
        }

        .btn-back {
            background-color: #ffa726;
            color: white;
            font-weight: 600;
            border-radius: 8px;
        }

        .btn-back:hover {
            background-color: #fb8c00;
        }

        .form-select {
            background-color: #fff;
            border-radius: 8px;
        }

        .message {
            text-align: center;
            margin-top: 15px;
            font-style: italic;
            font-size: 0.95rem;
        }

        .message.error {
            color: red;
        }

        .message.success {
            color: green;
        }

        .toggle-icon {
            cursor: pointer;
            user-select: none;
        }

        @media (max-width: 576px) {
            .signup-container {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2><i class="bi bi-person-plus-fill"></i> Sign Up</h2>

        <form action="UserController" method="post">
            <input type="hidden" name="action" value="signUp"/>

            <div class="mb-3 input-group">
                <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                <input type="text" class="form-control" name="userID" placeholder="Username" required />
            </div>

            <div class="mb-3 input-group">
                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                <input type="password" class="form-control" id="passwordInput" name="password" placeholder="Password" required />
                <span class="input-group-text toggle-icon" onclick="togglePassword('passwordInput', 'icon1')">
                    <i id="icon1" class="bi bi-eye"></i>
                </span>
            </div>

            <div class="mb-3 input-group">
                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                <input type="password" class="form-control" id="repasswordInput" name="repassword" placeholder="Re-enter Password" required />
                <span class="input-group-text toggle-icon" onclick="togglePassword('repasswordInput', 'icon2')">
                    <i id="icon2" class="bi bi-eye"></i>
                </span>
            </div>

            <div class="mb-3 input-group">
                <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                <input type="text" class="form-control" name="fullName" placeholder="Full Name" required />
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-register">Register</button>
            </div>
        </form>

        <form action="login.jsp" method="get">
            <div class="d-grid">
                <button type="submit" class="btn btn-back">Back to Login</button>
            </div>
        </form>

        <%
            String message = (String) request.getAttribute("message");
            if (message != null && !message.trim().isEmpty()) {
                boolean isSuccess = message.toLowerCase().contains("success") || message.toLowerCase().contains("đăng ký thành công");
        %>
            <div class="message <%= isSuccess ? "success" : "error" %>"><%= message %></div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            }
        }
    </script>
</body>
</html>
