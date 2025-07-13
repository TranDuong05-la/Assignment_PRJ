<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.AddressDAO" %>
<%@ page import="model.AddressDTO" %>
<%@ page import="model.UserDTO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Shipping Addresses</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd, #fff3e0);
            background-size: 200% 200%;
            animation: gradientMove 10s ease infinite;
            font-family: 'Poppins', sans-serif;
            padding: 40px 0;
        }

        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            max-width: 960px;
            margin: auto;
        }

        h3 {
            font-weight: 600;
            color: #0d47a1;
        }

        .table {
            background-color: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .table thead th {
            background-color: #0d47a1;
            color: #fff;
            text-align: center;
            vertical-align: middle;
        }

        .table td {
            vertical-align: middle;
            text-align: center;
        }

        .default-badge {
            background-color: #2e7d32;
            color: white;
            font-size: 0.85rem;
            padding: 4px 10px;
            border-radius: 50px;
            white-space: nowrap;
        }

        .btn-sm {
            border-radius: 8px;
            font-weight: 500;
        }

        .btn-primary {
            background-color: #1976d2;
            border: none;
        }

        .btn-primary:hover {
            background-color: #1565c0;
        }

        .btn-danger {
            background-color: #e53935;
            border: none;
        }

        .btn-danger:hover {
            background-color: #c62828;
        }

        .btn-secondary {
            background-color: #757575;
            border: none;
        }

        .btn-secondary:hover {
            background-color: #616161;
        }

        .btn-success {
            background-color: #2e7d32;
            border: none;
            border-radius: 10px;
        }

        .btn-success:hover {
            background-color: #1b5e20;
        }

        .table-responsive {
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

        .no-data {
            text-align: center;
            color: #888;
            font-style: italic;
        }

        @media (max-width: 768px) {
            .btn-sm {
                margin-bottom: 5px;
                width: 100%;
            }
        }
    </style>
</head>
<body>

<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<AddressDTO> addresses = (List<AddressDTO>) request.getAttribute("addresses");
    if (addresses == null) {
        AddressDAO dao = new AddressDAO();
        addresses = dao.getAddressesByUser(user.getUserID());
    }
%>

<div class="container">
    <h3 class="mb-4 text-center"><i class="bi bi-geo-alt-fill"></i> Your Shipping Addresses</h3>

    <div class="d-flex justify-content-end mb-3">
        <a href="MainController?action=add" class="btn btn-success px-4 py-2">
            <i class="bi bi-plus-circle-fill"></i> Add New Address
        </a>
    </div>
    <form action="home.jsp" method="get">
        <div class="d-grid">
            <button type="submit" class="btn btn-back">← Back to home</button>
        </div>
    </form>
    <div class="table-responsive">
        <table class="table align-middle">
            <thead>
                <tr>
                    <th>Recipient</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>District</th>
                    <th>City</th>
                    <th>Default</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (addresses != null && !addresses.isEmpty()) {
                        for (AddressDTO addr : addresses) {
                %>
                    <tr>
                        <td><%= addr.getRecipientName() %></td>
                        <td><%= addr.getPhone() %></td>
                        <td><%= addr.getAddressDetail() %></td>
                        <td><%= addr.getDistrict() %></td>
                        <td><%= addr.getCity() %></td>
                        <td>
                            <% if (addr.isDefault()) { %>
                                <span class="default-badge">Default</span>
                            <% } %>
                        </td>
                        <td>
                            <a href="MainController?action=edit&addressID=<%= addr.getAddressID() %>" class="btn btn-sm btn-primary mb-1">
                                <i class="bi bi-pencil-fill"></i> Edit
                            </a>
                            <a href="MainController?action=delete&addressID=<%= addr.getAddressID() %>" class="btn btn-sm btn-danger mb-1" onclick="return confirm('Delete this address?')">
                                <i class="bi bi-trash-fill"></i> Delete
                            </a>
                            <% if (!addr.isDefault()) { %>
                            <a href="MainController?action=setDefault&addressID=<%= addr.getAddressID() %>" class="btn btn-sm btn-secondary">
                                <i class="bi bi-star-fill"></i> Default
                            </a>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="no-data py-3">No addresses found.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
