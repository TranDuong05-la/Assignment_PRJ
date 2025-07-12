<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.DiscountDTO" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Available Discount Codes</title>
    </head>
    <body>
        <%
                UserDTO user = AuthUtils.getCurrentUser(request);
                if (!AuthUtils.isLoggedIn(request)) {
                    response.sendRedirect("MainController");
                    return;
                }
        %>
        <h2>Available Discounts</h2>
        <% if (AuthUtils.isAdmin(request)) { %>
        <a href="createDiscount.jsp">Add Deal Discount</a>
        <% } %>
        <%
        
            List<DiscountDTO> discounts = (List<DiscountDTO>) request.getAttribute("discounts");
            if (discounts == null) {
                    response.sendRedirect("MainController?action=viewAll");
                    return;
                }
            if (discounts == null || discounts.isEmpty()) {
        %>
        <p>No available discounts.</p>
        <%
            } else {
        %>
        <table border="1" cellpadding="5">
            <tr>
                <th>Code</th>
                <th>Type</th>
                <th>Value</th>
                <th>Min Order Amount</th>
                <th>Expiry Date</th>
            </tr>
            <% for (DiscountDTO d : discounts) { %>
            <tr>
                <td><%= d.getCode() %></td>
                <td><%= d.getType() %></td>
                <td><%= d.getValue() %> <% if(d.getType().equals("percent")) { %>%<% } else { %>VND<% } %></td>
                <td><%= d.getMinOrderAmount() %></td>
                <td><%= d.getExpiryDate() %></td>
            </tr>
            <% } %>
        </table>
        <%
            }
        %>

        <br/>
        <a href="MainController">Back to Home</a>
    </body>
</html>
