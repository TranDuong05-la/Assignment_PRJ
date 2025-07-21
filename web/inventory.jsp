<%-- 
    Document   : inventory
    Created on : Jul 14, 2025, 9:19:51 AM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.UserDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="model.BookDTO" %>
<%@ page import="model.CategoryDTO" %>
<%@ page import="model.InventoryDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inventory</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: #fff;
                margin: 0;
                padding: 0;
                color: #1a1a1a;
            }

            .container {
                max-width: 1100px;
                margin: 40px auto 0 auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 32px #ea222229;
                padding: 34px 30px 34px 30px;
            }

            .header-section {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 2px solid #faeceb;
                padding-bottom: 14px;
                margin-bottom: 30px;
            }

            h1 {
                color: #ea2222;
                font-weight: 800;
                margin: 0;
                letter-spacing: 1px;
                font-size: 2rem;
            }

            .logout-btn {
                background: #ea2222;
                color: #fff;
                padding: 9px 20px;
                border-radius: 22px;
                font-size: 1rem;
                border: none;
                text-decoration: none;
                font-weight: 600;
                transition: background .18s;
                box-shadow: 0 1px 6px #ea222211;
            }
            .logout-btn:hover {
                background: #b81a1a;
            }

            .add-product-btn {
                display: inline-block;
                background: #fff;
                color: #ea2222;
                border: 2px solid #ea2222;
                padding: 10px 26px;
                border-radius: 22px;
                font-size: 1rem;
                font-weight: 600;
                text-decoration: none;
                margin: 20px 0 18px 0;
                transition: background .16s, color .16s;
            }
            .add-product-btn:hover {
                background: #ea2222;
                color: #fff;
            }

            .table-container {
                margin-top: 30px;
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                font-size: 1.07rem;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 2px 16px #ea222214;
            }

            th, td {
                padding: 14px 10px;
                text-align: left;
            }

            th {
                background: #ea2222;
                color: #fff;
                font-size: 1.05rem;
                font-weight: 700;
                border-bottom: 3px solid #fff6f6;
            }

            tbody tr:nth-child(even) {
                background: #fff5f5;
            }
            tbody tr:hover {
                background: #fdeaea;
                transition: background .18s;
            }

            .status-true {
                color: #ea2222;
                font-weight: bold;
            }
            .status-false {
                color: #9e6144;
                font-weight: bold;
            }

            .edit-btn, .delete-btn {
                padding: 7px 20px;
                border: none;
                border-radius: 16px;
                font-size: 0.97rem;
                font-weight: 600;
                cursor: pointer;
                margin-right: 7px;
                transition: background .15s, color .15s;
            }

            .edit-btn {
                background: #fff;
                color: #ea2222;
                border: 1.5px solid #ea2222;
            }
            .edit-btn:hover {
                background: #ea2222;
                color: #fff;
            }

            .delete-btn {
                background: #fff;
                color: #fff;
                border: 1.5px solid #ea2222;
                background: linear-gradient(45deg, #ea2222 70%, #fff 100%);
                color: #fff;
            }
            .delete-btn:hover {
                background: #b81a1a;
                color: #fff;
                border-color: #b81a1a;
            }

            .no-results {
                text-align: center;
                background: #fff0f0;
                border: 1px solid #ffc2c2;
                border-radius: 7px;
                color: #ea2222;
                font-size: 1.07rem;
                margin: 26px 0;
                padding: 22px;
            }

            @media (max-width: 800px) {
                .container {
                    padding: 14px 4vw 20px 4vw;
                }
                th, td {
                    padding: 9px 5px;
                }
                .header-section {
                    flex-direction: column;
                    gap: 9px;
                    align-items: flex-start;
                }
            }

            @media (max-width: 500px) {
                h1 {
                    font-size: 1.1rem;
                }
                .add-product-btn, .logout-btn {
                    font-size: 0.95rem;
                    padding: 7px 13px;
                }
                table {
                    font-size: 0.94rem;
                }
            }
        </style>
    </head>
    <body>
        <%
                UserDTO user = AuthUtils.getCurrentUser(request);
                if(!AuthUtils.isLoggedIn(request)){
                response.sendRedirect("MainController");
                } else {
        %>

        <div class="container">

            <!-- Only admin can add inventory -->
            <% if(AuthUtils.isAdmin(request)) { %>
            <a href="InventoryController?action=createInventory" class="add-product-btn">Add/Update Inventory</a>
            <a href="InventoryController?action=showInventory" class="add-product-btn">Show Inventory</a>
             <a href="<%=request.getContextPath()%>/home" class="add-product-btn">Back Home</a>
            <% } %>

            <%
                List<InventoryDTO> inventoryList = (List<InventoryDTO>)request.getAttribute("inventories");
                if(inventoryList!=null && inventoryList.isEmpty()){
            %>
            <div class="no-results">
                No inventory data found!
            </div>
            <%
                } else if(inventoryList!=null && !inventoryList.isEmpty()){
            %>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Inventory ID</th>
                            <th>Book ID</th>
                            <th>Quantity</th>
                            <th>Last Update</th>
                                <% if(AuthUtils.isAdmin(request)){ %>
                            <th>Action</th>
                                <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for(InventoryDTO i : inventoryList){
                        %>
                        <tr>
                            <td><%=i.getInventoryID()%></td>
                            <td><%=i.getBookID()%></td>
                            <td><%=i.getQuantity()%></td>
                            <td><%=i.getLastUpdate()%></td>
                            <% if(AuthUtils.isAdmin(request)){ %>
                            <td>
                                <!-- Edit/update inventory action -->
                                <form action="MainController" method="post" style="display:inline-block">
                                    <input type="hidden" name="action" value="editInventory"/>
                                    <input type="hidden" name="inventoryID" value="<%=i.getInventoryID()%>"/>
                                    <input type="submit" value="Edit" class="edit-btn"/>
                                </form>
                                <!-- Optionally, allow delete if business allows -->                          
                                <form action="MainController" method="post" style="display:inline-block">
                                    <input type="hidden" name="action" value="deleteInventory"/>
                                    <input type="hidden" name="inventoryID" value="<%=i.getInventoryID()%>"/>
                                    <input type="submit" value="Delete" class="delete-btn"
                                           onclick="return confirm('Are you sure you want to delete this inventory record?')"/>
                                </form>

                            </td>
                            <% } %>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>

        <%
            }
        %>
    </body>
</html>
