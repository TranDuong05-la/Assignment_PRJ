<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Discount</title>
</head>
<body>
    <%    if (AuthUtils.isAdmin(request)) {
%>
     <h2>Create New Discount Code</h2>

    <% String message = (String) request.getAttribute("message");
       if (message != null) { %>
        <p style="color:red;"><%= message %></p>
    <% } %>

    <form action="MainController" method="post">
        <input type="hidden" name="action" value="create" />
        Code: <input type="text" name="code" required /><br/>
        Type: 
        <select name="type">
            <option value="percent">Percent</option>
            <option value="fixed">Fixed</option>
        </select><br/>
        Value: <input type="number" name="value" step="0.01" required /><br/>
        Min Order Amount: <input type="number" name="minOrderAmount" step="0.01" value="0" /><br/>
        Expiry Date: <input type="date" name="expiryDate" required /><br/>
        <input type="submit" value="Create Discount" />
    </form>

    <br/>
    <a href="viewDiscounts.jsp">Back to viewDiscounts</a>
    <%
    } else {
%>
<div class="container">
    <%= AuthUtils.getAccessDeniedMessage("Discount form page") %>
</div>
<%
    }
%>
</body>
</html>
