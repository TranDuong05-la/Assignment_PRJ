<%-- 
    Document   : categoryForm
    Created on : Jul 13, 2025, 11:45:03 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.BookDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="model.CategoryDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Category Form</title>
        <link rel="stylesheet" href="assets/form-style.jsp"/>
    </head>
    <%
     if (AuthUtils.isAdmin(request)) {
    %>
    <div class="form-container">
        <h2>Category Form</h2>
        <form method="post" action="CategoryController">
            <label>Category Name
                <input type="text" name="name" required>
            </label>
            <label>Description
                <textarea name="description" rows="3"></textarea>
            </label>
            <button type="submit" class="btn">Save</button>
            <a href="category.jsp" class="btn cancel">Cancel</a>
        </form>
    </div>
    <%
        } else {
    %>
    <div class="access-denied">
        <%= AuthUtils.getAccessDeniedMessage(" category-form page ") %>
    </div>
    <%
        }
    %>
</body>
</html>
