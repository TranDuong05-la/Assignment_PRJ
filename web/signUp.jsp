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
            background: linear-gradient(135deg, #c8f2e0, #e0fefc);
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
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 480px;
            animation: fadeIn 1s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            color: #2fb38b;
            font-weight: 600;
            text-align: center;
            margin-bottom: 30px;
        }

        .input-group-text {
            background-color: #d8f7ee;
            border-right: none;
        }

        .form-control:focus {
            border-color: #2fb38b;
            box-shadow: 0 0 0 0.2rem rgba(47, 179, 139, 0.25);
        }

        .btn-register {
            background: linear-gradient(to right, #2fb38b, #57d9a3);
            border: none;
            color: white;
            font-weight: 600;
            transition: transform 0.2s ease;
        }

        .btn-register:hover {
            transform: scale(1.05);
            background: linear-gradient(to right, #28a67f, #49c892);
        }

        .btn-back {
            background-color: #a0aec0;
            color: white;
            font-weight: 600;
        }

        .btn-back:hover {
            background-color: #8b9ab3;
        }

        .form-select {
            background-color: #fff;
        }

        .message {
            color: red;
            text-align: center;
            margin-top: 15px;
            font-style: italic;
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
                <input type="password" class="form-control" name="password" placeholder="Password" required />
            </div>

            <div class="mb-3 input-group">
                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                <input type="password" class="form-control" name="repassword" placeholder="Re-enter Password" required />
            </div>

            <div class="mb-3 input-group">
                <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                <input type="text" class="form-control" name="fullName" placeholder="Full Name" required />
            </div>

            <div class="mb-3 input-group">
                <span class="input-group-text"><i class="bi bi-award-fill"></i></span>
                <select class="form-select" name="roleID" required>
                    <option value="">-- Select Role --</option>
                    <option value="buyer">Buyer</option>
                    <option value="seller"> Seller</option>
                </select>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-register"> Register</button>
            </div>
        </form>

        <form action="login.jsp" method="get">
            <div class="d-grid">
                <button type="submit" class="btn btn-back">Back to Login</button>
            </div>
        </form>

        <div class="message">${message}</div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
