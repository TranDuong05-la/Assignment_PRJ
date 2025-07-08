<%-- 
    Document   : login
    Created on : 08/07/2025, 9:12:16 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>
        <%
            if (AuthUtils.isLoggedIn(request)) {
                response.sendRedirect("welcome.jsp");
            } else {
        %>
        <div>
            <h2>Login</h2>
            <form action="MainController" method="post">
                <input type="hidden" name="action" value="login" />
                <input type="text" name="strUsername" placeholder="Username" required />
                <input type="password" name="strPassword" placeholder="Password" required />
                <input type="submit" value="Login" />
            </form>
            <%
                Object objMessage = request.getAttribute("message");
                String message = (objMessage == null) ? "" : objMessage.toString();
                if (!message.isEmpty()) {
            %>
            <%= message %>
            <%
                }
            %>
        </div>
        <%
            }
        %>
    </body>
</html>
