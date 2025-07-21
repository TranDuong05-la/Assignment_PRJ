<%-- 
    Document   : reviewForm
    Created on : Jul 15, 2025, 12:34:42 PM
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
        <title>Add Review</title>
        <link rel="stylesheet" href="assets/form-style.jsp" />
    </head>
    <body>
        <%
            if (AuthUtils.isAdmin(request)) {
        %>
        <div class="form-container">
            <h2>Review Form</h2>
            <form method="post" action="MainController">
                <label>Book ID
                    <input type="number" name="bookId" required>
                </label>
                <label>User ID
                    <input type="number" name="userId" required>
                </label>
                <label>Rating
                    <select name="rating">
                        <option value="1">1 Star</option>
                        <option value="2">2 Stars</option>
                        <option value="3">3 Stars</option>
                        <option value="4">4 Stars</option>
                        <option value="5" selected>5 Stars</option>
                    </select>
                </label>
                <label>Comment
                    <textarea name="comment" rows="3"></textarea>
                </label>
                <button type="submit" class="btn">Save</button>
                <a href="home.jsp" class="btn cancel">Cancel</a>
            </form>
        </div>
        <%
            } else {
        %>
        <div class="access-denied">
            <%= AuthUtils.getAccessDeniedMessage(" review-form page ") %>
        </div>
        <%
            }
        %>
    </body>
</html>
