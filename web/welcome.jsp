<%-- 
    Document   : welcome
    Created on : 08/07/2025, 9:23:11 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home</title>
    </head>
    <body>
        <%
            String message = (String) request.getAttribute("message");
            UserDTO user = AuthUtils.getCurrentUser(request);
            if (!AuthUtils.isLoggedIn(request)) {
                response.sendRedirect("MainController");
                return;
            }
        %>
         <%= message!=null?message:""%>
        <h1>Welcome <%= user.getFullName() %>!</h1>
        <a href="MainController?action=logout">Logout</a>
    </body>
</html>
