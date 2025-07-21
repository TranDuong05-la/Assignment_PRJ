<%-- 
    Document   : productForm
    Created on : Jul 13, 2025, 5:14:42 PM
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
        <title>Add/Edit Book</title>
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
    <body>
        <%
            if (AuthUtils.isAdmin(request)) {
                BookDTO book = (BookDTO) request.getAttribute("book");
                String checkError = (String) request.getAttribute("checkError");
                String message = (String) request.getAttribute("message");
                String keyword = (String) request.getAttribute("keyword");
                boolean isEdit = request.getAttribute("isEdit") != null;
                List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
        %>
        <div class="form-container">
            <h1><%= isEdit ? "Edit Book" : "Add New Book" %></h1>
            <%-- BACK LINK --%>
            <% if(keyword != null && !keyword.isEmpty()) { %>
            <a href="ProductController?action=searchBook&strKeyword=<%=keyword%>" class="back-link">
                ← Back to Book List
            </a>
            <% } else { %>
            <a href="home.jsp" class="back-link">
                ← Back to Home
            </a>
            <% } %>

            <form action="ProductController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="<%=isEdit ? "updateBook" : "addBook"%>"/>
                <% if(isEdit) { %>
                <input type="hidden" name="bookID" value="<%=book!=null?book.getBookID():""%>"/>
                <% } %>

                <div>
                    <label for="bookTitle">Book Title *</label>
                    <input type="text" name="bookTitle" id="bookTitle" required
                           value="<%=book!=null?book.getBookTitle():""%>"
                           placeholder="Enter book title"/>
                </div>
                <div>
                    <label for="author">Author *</label>
                    <input type="text" name="author" id="author" required
                           value="<%=book!=null?book.getAuthor():""%>"
                           placeholder="Enter author"/>
                </div>
                <div>
                    <label for="categoryID">Category *</label>
                    <select name="categoryID" id="categoryID" required>
                        <option value="">-- Choose Category --</option>
                        <%
                            int selectedCat = (book != null) ? book.getCategoryID() : 0;
                            if(categories != null)
                                for(CategoryDTO cat : categories) {
                        %>
                        <option value="<%=cat.getCategoryID()%>" <%= (cat.getCategoryID() == selectedCat) ? "selected" : "" %>>
                            <%= cat.getCategoryName() %>
                        </option>
                        <%
                                }
                        %>
                    </select>
                </div>
                <div>
                    <label for="publisher">Publisher *</label>
                    <input type="text" name="publisher" id="publisher" required
                           value="<%=book!=null?book.getPublisher():""%>"
                           placeholder="Enter publisher"/>
                </div>
                <div>
                    <label for="price">Price ($)*</label>
                    <input type="number" name="price" id="price" min="0" step="0.01" required
                           value="<%=book!=null?book.getPrice():""%>"
                           placeholder="0.00"/>
                </div>
                <div>
                    <label for="imageFile">Image (Upload)</label>
                    <input type="file" name="imageFile" id="imageFile" accept="image/*" onchange="previewImage(event)">
                </div>
                <div>
                    <label for="imageUrl">Image (URL)</label>
                    <input type="text" name="imageUrl" id="imageUrl"
                           value="<%=book!=null?book.getImage():""%>"
                           placeholder="Enter image URL..." oninput="previewImageUrl(event)">
                    <img id="preview" class="img-preview"
                         src="<%=book!=null && book.getImage()!=null?book.getImage():""%>"
                         alt="Preview Image"/>
                </div>
                <div>
                    <label for="description">Description</label>
                    <textarea name="description" id="description" 
                              placeholder="Enter book description"><%=book!=null?book.getDescription():""%></textarea>
                </div>
                <div>
                    <label for="publishYear">Publish Year</label>
                    <input type="number" name="publishYear" id="publishYear" min="1900" max="2099"
                           value="<%=book!=null && book.getPublishYear()!=0?book.getPublishYear():""%>"
                           placeholder="YYYY"/>
                </div>
                <div>
                    <input type="submit" value="<%=isEdit ? "Update Book" : "Add Book"%>"/>
                    <input type="reset" value="Reset"/>
                    <a href="<%=request.getContextPath()%>/home" class="cancel-btn">Cancel</a>
                </div>
            </form>
            <% if(checkError != null || message != null) { %>
            <div class="message-container">
                <% if(checkError != null) { %>
                <div class="error-message"><%=checkError%></div>
                <% } %>
                <% if(message != null) { %>
                <div class="success-message"><%=message%></div>
                <% } %>
            </div>
            <% } %>
        </div>
        <%
        } else {
        %>
        <div class="access-denied">
            <%= AuthUtils.getAccessDeniedMessage("book-form page") %>
            <br>
            <a href="home.jsp" class="cancel-btn">Back to Home</a>
        </div>
        <%
        }
        %>
        <script>
            function previewImage(event) {
                const preview = document.getElementById('preview');
                const file = event.target.files[0];
                if (file) {
                    preview.src = URL.createObjectURL(file);
                }
            }
            function previewImageUrl(event) {
                const preview = document.getElementById('preview');
                preview.src = event.target.value;
            }
        </script>
    </body>
</html>

