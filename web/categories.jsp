<%-- 
    Document   : categories
    Created on : Jul 3, 2025, 11:11:09 AM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ExamCategoryDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Categories Page</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: linear-gradient(120deg, #e3f0ff 0%, #f9fcff 100%);
                margin: 0;
                padding: 0;
            }
            h2 {
                text-align: center;
                color: #1d82d2;
                margin-top: 42px;
                letter-spacing: 1px;
                font-weight: 700;
                font-size: 2em;
                text-shadow: 0 2px 10px #abd8ff55;
            }
            table {
                border-collapse: collapse;
                width: 70%;
                margin: 32px auto 0 auto;
                background: #fff;
                border-radius: 18px;
                overflow: hidden;
                box-shadow: 0 6px 32px rgba(37,116,169,0.13);
            }
            th, td {
                padding: 15px 22px;
                text-align: center;
                font-size: 1.08em;
            }
            th {
                background: #e3f3ff;
                color: #1d82d2;
                font-size: 1.16em;
                font-weight: 600;
                border-bottom: 2.5px solid #acd1f8;
            }
            tr:nth-child(even) {
                background: #f4f9ff;
            }
            tr:nth-child(odd) {
                background: #fff;
            }
            td {
                font-size: 1em;
                border-bottom: 1px solid #e6eef8;
            }
            .error-msg {
                color: #b20000;
                text-align: center;
                margin-top: 16px;
                margin-bottom: 8px;
                background: #fff4f4;
                border: 1px solid #ffb4b4;
                border-radius: 6px;
                padding: 10px 0;
                width: 70%;
                margin-left: auto;
                margin-right: auto;
            }
            form[method="post"] button,
            button[type="submit"] {
                background: linear-gradient(90deg, #61b2fc 60%, #57dbdb 100%);
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 7px 25px;
                font-size: 1em;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.18s, box-shadow 0.17s, transform 0.12s;
                box-shadow: 0 1px 8px #71bfff15;
                outline: none;
            }
            form[method="post"] button:hover,
            button[type="submit"]:hover {
                background: linear-gradient(90deg, #3571cb 50%, #0ab5d4 100%);
                transform: translateY(-1px) scale(1.045);
                box-shadow: 0 3px 16px #1d82d245;
            }
            a {
                display: block;
                width: fit-content;
                margin: 40px auto 0 auto;
                color: #2472b8;
                background: #e5f2fb;
                border-radius: 8px;
                padding: 10px 32px;
                text-decoration: none;
                font-weight: 500;
                font-size: 1.06em;
                box-shadow: 0 1px 7px #d5eaff80;
                transition: background 0.13s, color 0.13s;
            }
            a:hover {
                background: #1d82d2;
                color: #fff;
                text-decoration: underline;
                transform: scale(1.045);
            }
        </style>
    </head>
    <body>
        <%
             List<ExamCategoryDTO> categories = (List<ExamCategoryDTO>) request.getAttribute("categories");
        %>
        <h2>Exam Categories </h2>
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) { %>
        <div style="color: red;"><%= error %></div>
        <% } %>

        <table border="1" cellpadding="5" cellspacing="0">
            <tr>
                <th>CategoryName</th>
                <th>Description</th>
                <th>Action</th>
            </tr>
            <% if (categories != null) {
            for (ExamCategoryDTO cat : categories) { %>
            <tr>
                <td><%= cat.getCategoryName() %></td>
                <td><%= cat.getDescription() %></td>
                <td>
                    <form action="ExamController" method="post" style="margin:0;">
                        <input type="hidden" name="action" value="listExamsByCategory"/>
                        <input type="hidden" name="categoryId" value="<%=cat.getCategoryId()%>"/>
                        <button type="submit">View Exam</button>
                    </form>
                </td>
            </tr>
            <%   }
           } else { %>
            <tr><td colspan="3">There are not data.</td></tr>
            <% } %>
        </table>

        <br>
        <a href="MainController?action=dashboard">Turn Back Dashboard</a>
    </body>
</html>
