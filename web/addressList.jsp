<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.AddressDAO" %>
<%@ page import="model.AddressDTO" %>
<%@ page import="model.UserDTO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shipping Addresses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

<div class="container mt-5">
    <h2>Your Shipping Addresses</h2>
    <a href="MainController?action=add" class="btn btn-success mb-3">+ Add New Address</a>

    <table class="table table-hover">
        <thead>
            <tr>
                <th>Recipient Name</th>
                <th>Phone</th>
                <th>Address Detail</th>
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
                <td><%= addr.isDefault() ? "This is default address" : "" %></td>
                <td>
                    <a href="MainController?action=edit&addressID=<%= addr.getAddressID() %>" class="btn btn-sm btn-primary">Edit</a>
                    <a href="MainController?action=delete&addressID=<%= addr.getAddressID() %>" class="btn btn-sm btn-danger" onclick="return confirm('Delete this address?')">Delete</a>
                    <% if (!addr.isDefault()) { %>
                        <a href="MainController?action=setDefault&addressID=<%= addr.getAddressID() %>" class="btn btn-sm btn-secondary">Set Default</a>
                    <% } %>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr><td colspan="7">No addresses found.</td></tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
