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
<%@ page import="model.UserDTO" %>
<%@ page import="model.ReviewDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Review</title>
        <style>
            body {
                background: #fff6f6;
                color: #1a1a1a;
                font-family: 'Segoe UI', Arial, sans-serif;
                margin: 0;
                min-height: 100vh;
            }

            .form-container {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 4px 22px #ea222236, 0 1.5px 8px #b7222230;
                max-width: 420px;
                margin: 58px auto 0 auto;
                padding: 38px 36px 30px 36px;
                display: flex;
                flex-direction: column;
                gap: 16px;
                border-top: 6px solid #ea2222;
                border-bottom: 2px solid #ffd5d5;
            }

            .form-container h2 {
                color: #ea2222;
                font-size: 2.1rem;
                text-align: center;
                margin-bottom: 18px;
                font-weight: bold;
                letter-spacing: .5px;
            }

            .form-container label {
                font-weight: 600;
                margin-bottom: 8px;
                display: block;
                color: #ea2222;
            }

            .form-container input[type="number"],
            .form-container select,
            .form-container textarea {
                width: 100%;
                padding: 10px 16px;
                border: 1.3px solid #f5c3c3;
                border-radius: 13px;
                background: #fffafa;
                font-size: 1.06rem;
                margin-top: 6px;
                margin-bottom: 18px;
                transition: border .2s;
                color: #1a1a1a;
                outline: none;
                resize: vertical;
            }

            .form-container input:focus,
            .form-container select:focus,
            .form-container textarea:focus {
                border-color: #ea2222;
                box-shadow: 0 0 4px #ea222250;
            }

            .form-container textarea {
                min-height: 70px;
            }

            .btn, .btn.cancel {
                display: inline-block;
                padding: 10px 32px;
                margin: 8px 10px 0 0;
                font-weight: 600;
                font-size: 1.1rem;
                border: none;
                border-radius: 24px;
                cursor: pointer;
                transition: background .18s, color .16s;
                text-decoration: none;
                outline: none;
            }

            .btn {
                background: #ea2222;
                color: #fff;
                box-shadow: 0 2px 12px #ea222230;
            }

            .btn:hover, .btn:focus {
                background: #b71818;
                color: #fff;
            }

            .btn.cancel {
                background: #fff;
                color: #ea2222;
                border: 1.5px solid #ea2222;
                margin-right: 0;
            }

            .btn.cancel:hover, .btn.cancel:focus {
                background: #ffeaea;
                color: #ea2222;
            }

            @media (max-width: 600px) {
                .form-container {
                    max-width: 98vw;
                    padding: 24px 8vw 18px 8vw;
                }
                .form-container h2 {
                    font-size: 1.35rem;
                }
            }
        </style>
    </head>
    <body>
        <%
            UserDTO user = (UserDTO) session.getAttribute("user");
            String bookIdStr = request.getParameter("bookId"); // Khi add
            ReviewDTO review = (ReviewDTO) request.getAttribute("review"); // Khi edit

            String action = (review == null) ? "addReview" : "updateReview";
            String bookID = (review != null) ? String.valueOf(review.getBookID()) : bookIdStr;
            String comment = (review != null) ? review.getComment() : "";
            String rating = (review != null) ? String.valueOf(review.getRating()) : "5";
            String reviewID = (review != null) ? String.valueOf(review.getReviewID()) : "";

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
                }
            if (bookIdStr == null) {
                out.print("<div style='color:red'>Book not found!</div>");
                return;
            }
        %>
        <div class="form-container">
            <h2><%= (review == null) ? "Add" : "Edit" %> Review Book #<%= bookID %></h2>
            <form method="post" action="ReviewController">
                <input type="hidden" name="action" value="<%= action %>"/>
                <% if (review != null) { %>
                <input type="hidden" name="reviewID" value="<%= reviewID %>"/>
                <% } %>
                <input type="hidden" name="bookID" value="<%= bookID %>"/>
                <input type="hidden" name="userID" value="<%= user.getUserID() %>"/>
                <label>Rating
                    <select name="rating">
                        <% for (int i = 1; i <= 5; i++) { %>
                        <option value="<%=i%>" <%= (String.valueOf(i).equals(rating)) ? "selected" : "" %>><%=i%> Star<%= (i > 1 ? "s" : "") %></option>
                        <% } %>
                    </select>
                </label>
                <label>Comment
                    <textarea name="comment" rows="3"><%= comment %></textarea>
                </label>
                <button type="submit" class="btn"><%= (review == null) ? "Save" : "Update" %></button>
                <a href="ProductController?action=bookDetail&bookID=<%= bookID %>" class="btn cancel">Cancel</a>
            </form>
        </div>
    </body>
</html>
