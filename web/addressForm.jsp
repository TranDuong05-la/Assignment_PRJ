<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.AddressDTO" %>
<%@ page import="model.UserDTO" %>

<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    AddressDTO addr = (AddressDTO) request.getAttribute("address");
    boolean isEdit = Boolean.TRUE.equals(request.getAttribute("isEdit"));

    String addressID     = (addr != null) ? String.valueOf(addr.getAddressID()) : "";
    String recipientName = (addr != null) ? addr.getRecipientName() : "";
    String phone         = (addr != null) ? addr.getPhone() : "";
    String addressDetail = (addr != null) ? addr.getAddressDetail() : "";
    String district      = (addr != null) ? addr.getDistrict() : "";
    String city          = (addr != null) ? addr.getCity() : "";
    boolean isDefault    = (addr != null && addr.isDefault());

    String message = (request.getAttribute("message") != null)
            ? request.getAttribute("message").toString()
            : "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Edit Address" : "Add Address" %></title>

    <!-- Bootstrap & Icons -->
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

        .form-card {
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            animation: fadeIn 0.8s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h4 {
            color: #0d47a1;
            font-weight: 600;
            text-align: center;
            margin-bottom: 25px;
        }

        .input-group-text {
            background-color: #bbdefb;
            border-right: none;
            border-radius: 8px 0 0 8px;
        }

        .form-control {
            border-radius: 0 8px 8px 0;
        }

        .form-control:focus {
            border-color: #0d47a1;
            box-shadow: 0 0 0 0.2rem rgba(13, 71, 161, 0.25);
        }

        .btn-submit {
            background: linear-gradient(to right, #0d47a1, #1976d2);
            border: none;
            color: white;
            font-weight: 600;
            border-radius: 8px;
            transition: transform 0.2s ease;
        }

        .btn-submit:hover {
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

        .form-check-label {
            margin-left: 5px;
        }

        .alert {
            margin-top: 20px;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>

<div class="form-card">
    <h4><i class="bi bi-geo-alt-fill"></i> <%= isEdit ? "Edit Address" : "Add Address" %></h4>

    <form action="MainController" method="post">
        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
        <input type="hidden" name="addressID" value="<%= addressID %>" />

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
            <input type="text" class="form-control" name="recipientName" value="<%= recipientName %>" placeholder="Recipient Name" required>
        </div>

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="bi bi-telephone-fill"></i></span>
            <input type="text" class="form-control" name="phone" value="<%= phone %>" placeholder="Phone Number" required>
        </div>

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="bi bi-house-door-fill"></i></span>
            <input type="text" class="form-control" name="addressDetail" value="<%= addressDetail %>" placeholder="Address Detail" required>
        </div>

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="bi bi-signpost-2-fill"></i></span>
            <input type="text" class="form-control" name="district" value="<%= district %>" placeholder="District" required>
        </div>

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="bi bi-building"></i></span>
            <input type="text" class="form-control" name="city" value="<%= city %>" placeholder="City" required>
        </div>

        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="isDefault" id="defaultCheck" <%= isDefault ? "checked" : "" %> >
            <label class="form-check-label" for="defaultCheck">Set as default address</label>
        </div>

        <div class="d-grid mb-2">
            <button type="submit" class="btn btn-submit"><%= isEdit ? "Update Address" : "Add Address" %></button>
        </div>
    </form>

    <form action="addressList.jsp" method="get">
        <div class="d-grid">
            <button type="submit" class="btn btn-back">← Back to Address List</button>
        </div>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-warning text-center mt-3"><%= message %></div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
