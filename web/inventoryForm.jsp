<%-- 
    Document   : inventoryForm
    Created on : Jul 14, 2025, 1:00:09 AM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.BookDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="model.CategoryDTO" %>
<%@ page import="model.InventoryDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inventory Form</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: #fff6f6;
                color: #222;
                margin: 0;
                padding: 0;
            }
            .container, .form-container {
                max-width: 540px;
                margin: 48px auto;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 6px 32px #ea222210;
                padding: 0 0 32px 0;
            }
            h1, h2 {
                background: #ea2222;
                color: #fff;
                text-align: center;
                margin: 0;
                padding: 28px 0 20px 0;
                border-radius: 15px 15px 0 0;
                font-weight: 700;
                letter-spacing: 0.5px;
            }
            form {
                padding: 28px 26px 0 26px;
            }
            form > div {
                margin-bottom: 22px;
            }
            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #ea2222;
                font-size: 15px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            input[type="text"], input[type="number"], input[type="password"], input[type="email"], textarea, select {
                width: 100%;
                padding: 12px 14px;
                border: 2px solid #fae6e6;
                border-radius: 7px;
                font-size: 15px;
                background-color: #fff6f6;
                transition: border 0.2s;
                color: #222;
            }
            input:focus, textarea:focus, select:focus {
                border-color: #ea2222;
                outline: none;
                background: #fff;
            }
            input[readonly], input[readonly]:focus {
                background: #f5f5f5;
                color: #a0a0a0;
                border-color: #f0f0f0;
            }
            .checkbox-container {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 7px;
            }
            input[type="checkbox"] {
                accent-color: #ea2222;
                width: 19px;
                height: 19px;
                margin-right: 5px;
                cursor: pointer;
            }
            .form-actions, .btn-group {
                display: flex;
                gap: 18px;
                justify-content: center;
                margin-top: 30px;
            }
            input[type="submit"], input[type="reset"], .btn, .cancel-btn {
                padding: 12px 32px;
                border-radius: 22px;
                border: none;
                font-size: 1.06rem;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.15s, color 0.15s;
                text-transform: uppercase;
                background: #ea2222;
                color: #fff;
                text-decoration: none;
                margin-bottom: 0;
            }
            input[type="submit"]:hover, .btn:hover {
                background: #ba1919;
            }
            .cancel-btn, input[type="reset"] {
                background: #fff;
                color: #ea2222;
                border: 2px solid #ea2222;
            }
            .cancel-btn:hover, input[type="reset"]:hover {
                background: #ea2222;
                color: #fff;
            }
            .message-container {
                padding: 20px 30px 0 30px;
            }
            .error-message {
                color: #ea2222;
                background: #fff0f0;
                padding: 13px 15px;
                border-left: 4px solid #ea2222;
                border-radius: 4px;
                margin-bottom: 10px;
                font-weight: 500;
            }
            .success-message {
                color: #198754;
                background: #f3fff7;
                padding: 13px 15px;
                border-left: 4px solid #198754;
                border-radius: 4px;
                margin-bottom: 10px;
                font-weight: 500;
            }
            .access-denied {
                text-align: center;
                padding: 60px 30px;
                color: #fff;
                font-size: 19px;
                font-weight: 500;
                background: #ea2222;
                border-radius: 15px;
                margin: 30px auto 0 auto;
                box-shadow: 0 6px 32px #ea222222;
                max-width: 550px;
            }
            @media (max-width: 600px) {
                .container, .form-container, .access-denied {
                    padding: 0;
                }
                form {
                    padding: 18px 4vw 0 4vw;
                }
                h1, h2 {
                    font-size: 1.15rem;
                    padding: 16px 0 13px 0;
                }
                .form-actions, .btn-group {
                    flex-direction: column;
                    gap: 9px;
                }
            }
            input::placeholder, textarea::placeholder {
                color: #e7b6b6;
                font-style: italic;
            }


        </style>
    </head>
    <body>
        <%
     if (AuthUtils.isAdmin(request)) {
        List<BookDTO> books = (List<BookDTO>) request.getAttribute("books");
         InventoryDTO inventory = (InventoryDTO) request.getAttribute("inventory");
         boolean isEdit = request.getAttribute("isEdit") != null;
         String message = (String) request.getAttribute("message");
         String checkError = (String) request.getAttribute("checkError");
         int selectedBookId = (inventory != null) ? inventory.getBookID() : 0;
        %>
        <div class="container">
            <h2><%=isEdit ? "Edit Inventory" : "Add Inventory"%></h2>
            <form method="post" action="InventoryController">
                <input type="hidden" name="action" value="<%= isEdit ? "updateInventory" : "createInventory" %>"/>
                <input type="hidden" name="inventoryID" value="<%=inventory!=null ? inventory.getInventoryID() : ""%>" />
                
                <% if(isEdit && inventory != null) { %>
                
                <% } %>
                <div>
                    <label for="bookID">Book ID</label>
                    <select name="bookID" id="bookID" required style="width:100%;padding:12px 15px;font-size:17px;border:2px solid #faeceb;border-radius:10px;background:#fff6f6;">
                        <option value="">-- Select Book --</option>
                        <% if (books != null) {
                for (BookDTO b : books) { %>
                        <option value="<%=b.getBookID()%>" <%= (selectedBookId == b.getBookID()) ? "selected" : "" %>>
                            <%=b.getBookID()%> - <%=b.getBookTitle()%>
                        </option>
                        <%  }
            } %>
                    </select>
                </div>
                <div>
                    <label for="quantity">Stock Quantity</label>
                    <input type="number" name="quantity" id="quantity" min="0" required
                           value="<%=inventory!=null ? inventory.getQuantity() : ""%>" />
                </div>
                <div class="form-actions">
                    <input type="hidden" name="action" value="<%=isEdit?"updateInventory":"createInventory"%>"/>
                    <input type="submit" class="btn" value="<%=isEdit ? "Update" : "Add"%>"/>
                    <a href="inventory.jsp" class="btn cancel-btn">Cancel</a>
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
            <%= AuthUtils.getAccessDeniedMessage(" inventory-form page ") %>
        </div>
        <%
            }
        %>
    </body>
</html>
