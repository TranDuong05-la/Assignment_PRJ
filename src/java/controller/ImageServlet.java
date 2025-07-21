/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.nio.file.Files;

/**
 *
 * @author ASUS
 */
@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Lấy tên file sau /uploads/
        String filename = req.getPathInfo();
        if (filename == null || filename.equals("/")) {
            resp.sendError(404);
            return;
        }
        filename = filename.substring(1); // bỏ dấu /
        // Đường dẫn tuyệt đối tới thư mục uploads
        File file = new File("D:/HK4/PRJ301/Assignment_PRJ/web/uploads", filename);
        if (file.exists()) {
            // Xác định kiểu content-type dựa vào file
            String contentType = getServletContext().getMimeType(file.getName());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            resp.setContentType(contentType);
            Files.copy(file.toPath(), resp.getOutputStream());
        } else {
            resp.sendError(404);
        }
    }
}
