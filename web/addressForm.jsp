<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.AddressDTO" %>
<%@ page import="model.UserDTO" %>

<%
    // Kiểm tra đăng nhập
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lấy dữ liệu nếu đang edit
    AddressDTO addr = (AddressDTO) request.getAttribute("address");
    boolean isEdit = request.getAttribute("isEdit") != null;

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

<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Edit Address" : "Add New Address" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header bg-success text-white text-center">
            <h4><%= isEdit ? "Edit Address" : "Add New Shipping Address" %></h4>
        </div>
        <div class="card-body">
            <form action="MainController" method="post">
                <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
                <input type="hidden" name="addressID" value="<%= addressID %>" />

                <div class="mb-3">
                    <label class="form-label">Recipient Name:</label>
                    <input type="text" class="form-control" name="recipientName" value="<%= recipientName %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Phone:</label>
                    <input type="text" class="form-control" name="phone" value="<%= phone %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Address Detail:</label>
                    <input type="text" class="form-control" name="addressDetail" value="<%= addressDetail %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">District:</label>
                    <input type="text" class="form-control" name="district" value="<%= district %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">City:</label>
                    <input type="text" class="form-control" name="city" value="<%= city %>" required>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="isDefault" id="defaultCheck"
                           <%= isDefault ? "checked" : "" %>>
                    <label class="form-check-label" for="defaultCheck">Set as Default</label>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <button type="submit" class="btn btn-success">
                        <%= isEdit ? "Update Address" : "Add Address" %>
                    </button>
                    <a href="MainController?action=list" class="btn btn-link">Back to List</a>
                </div>
            </form>
        </div>
    </div>

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-warning mt-3 text-center"><%= message %></div>
    <% } %>
</div>

</body>
</html>
