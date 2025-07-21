<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.DiscountDTO" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<%
    UserDTO user = AuthUtils.getCurrentUser(request);
    if (!AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("MainController");
        return;
    }

    List<DiscountDTO> discounts = (List<DiscountDTO>) request.getAttribute("discounts");
    if (discounts == null) {
        response.sendRedirect("MainController?action=viewAll");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Discounts</title>

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
            color: #333;
        }

        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            background-color: #fff;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.12);
            max-width: 960px;
            margin: auto;
        }

        h2 {
            text-align: center;
            color: #0d47a1;
            font-weight: 600;
            margin-bottom: 30px;
        }

        .top-actions {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .btn-custom {
            background: linear-gradient(to right, #0d47a1, #1976d2);
            border: none;
            color: white;
            font-weight: 600;
            border-radius: 10px;
        }

        .btn-custom:hover {
            background: linear-gradient(to right, #1565c0, #1e88e5);
        }

        .table-wrapper {
            overflow-x: auto;
        }

        .custom-table {
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
            background-color: #fdfdfd;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 6px 12px rgba(0,0,0,0.05);
        }

        .custom-table thead {
            background-color: #00695c;
            color: white;
        }

        .custom-table th, .custom-table td {
            padding: 16px;
            text-align: center;
            vertical-align: middle;
            font-size: 15px;
        }

        .custom-table th:first-child {
            border-top-left-radius: 12px;
        }

        .custom-table th:last-child {
            border-top-right-radius: 12px;
        }

        .custom-table tr:last-child td:first-child {
            border-bottom-left-radius: 12px;
        }

        .custom-table tr:last-child td:last-child {
            border-bottom-right-radius: 12px;
        }

        .type-cell {
            color: #1a237e;
            font-weight: 600;
        }

        .value-cell {
            color: #bf360c;
        }

        .min-cell {
            color: #33691e;
        }

        .expiry-cell {
            color: #880e4f;
        }

        .text-muted {
            text-align: center;
            margin-top: 20px;
            font-style: italic;
            color: #888;
        }

        @media (max-width: 576px) {
            .top-actions {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h2><i class="bi bi-tags-fill"></i> Available Discounts</h2>

    <div class="top-actions">
        
        <% if (AuthUtils.isAdmin(request)) { %>
            <a href="createDiscount.jsp" class="btn btn-custom"><i class="bi bi-plus-circle"></i> Add Discount</a>
        <% } else { %>
            <div></div>
        <% } %>
        <a href="MainController" class="btn btn-outline-secondary"><i class="bi bi-house-door-fill"></i> Home</a>
        <form action="MainController" method="get" class="d-flex" style="gap: 10px;">
        <input type="hidden" name="action" value="viewAll" />
        <input type="text" name="search" class="form-control" placeholder="Search by Code..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"/>
        <button type="submit" class="btn btn-custom"><i class="bi bi-search"></i> Search</button>
    </form>
    </div>

    <% if (discounts.isEmpty()) { %>
        <p class="text-muted">No available discounts at the moment.</p>
    <% } else { %>
        <div class="table-wrapper">
            <table class="custom-table">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Type</th>
                        <th>Value</th>
                        <th>Min Order</th>
                        <th>Expiry</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (DiscountDTO d : discounts) { %>
                        <tr>
                            <td><%= d.getCode() %></td>
                            <td class="type-cell"><%= d.getType() %></td>
                            <td class="value-cell">
                                <%= d.getValue() %><%= d.getType().equals("percent") ? "%" : " VND" %>
                            </td>
                            <td class="min-cell"><%= d.getMinOrderAmount() %> VND</td>
                            <td class="expiry-cell"><%= d.getExpiryDate() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
