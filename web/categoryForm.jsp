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
        <style>
            .form-container {
                max-width: 440px;
                margin: 40px auto;
                background: #fff6f6;
                padding: 32px 28px 22px 28px;
                border-radius: 16px;
                box-shadow: 0 2px 24px #e7bdbd22;
                border: 1px solid #f0dddd;
            }

            .form-container h2 {
                margin-bottom: 28px;
                color: #ea2222;
                text-align: center;
            }

            .form-container label {
                display: block;
                margin-bottom: 15px;
                font-weight: 500;
                color: #2d1d12;
            }

            .form-container input[type="text"],
            .form-container input[type="number"],
            .form-container input[type="url"],
            .form-container textarea,
            .form-container select {
                width: 100%;
                padding: 8px 13px;
                margin-top: 3px;
                border: 1px solid #e1bebe;
                border-radius: 6px;
                font-size: 1rem;
                margin-bottom: 6px;
                background: #fafafa;
                box-sizing: border-box;
            }

            .form-container textarea {
                resize: vertical;
            }

            .form-container .btn {
                background: #ea2222;
                color: #fff;
                border: none;
                padding: 9px 32px;
                border-radius: 18px;
                font-weight: bold;
                font-size: 1.08rem;
                cursor: pointer;
                margin-top: 9px;
                margin-right: 11px;
                transition: background 0.16s;
                text-decoration: none;
                display: inline-block;
            }

            .form-container .btn:hover {
                background: #d31717;
            }
            .form-container .btn.cancel {
                background: #e7b7b7;
                color: #7b3c3c;
            }
            .form-container .btn.cancel:hover {
                background: #d7bcbc;
                color: #333;
            }
            .access-denied {
                color: #b90000;
                text-align: center;
                font-size: 1.2rem;
                margin: 38px 0;
            }
        </style>
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
