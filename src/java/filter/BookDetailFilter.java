/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author ASUS
 */
// @WebFilter để đăng ký filter với 1 hoặc nhiều URL pattern
@WebFilter({"/bookDetail", "/book/*"})
public class BookDetailFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        String path = request.getRequestURI(); // VD: /Assignment_PRJ/book/1
        // Nếu là đường dẫn category thì cho đi thẳng, KHÔNG forward
        if (path.endsWith("/category.jsp") || path.contains("CategoryController")) {
            chain.doFilter(req, resp); // Cho qua bình thường
            return;
        }

        // Nếu là /bookDetail hoặc /book/{id}
        if (path.endsWith("/bookDetail")) {
            // Nếu là /bookDetail?id=123 (query string)
            String bookId = request.getParameter("id");
            if (bookId == null) {
                // fallback: nếu có dạng /book/{id}
                String[] split = path.split("/");
                bookId = split[split.length - 1];
            }
            request.getRequestDispatcher(
                "/ProductController?action=bookDetail&bookID=" + bookId
            ).forward(req, resp);
            return;
        }

        // Nếu là /book/{id} thì cắt id cuối cùng
        if (path.matches(".*/book/\\d+$")) {
            String[] split = path.split("/");
            String bookId = split[split.length - 1];
            request.getRequestDispatcher(
                "/ProductController?action=bookDetail&bookID=" + bookId
            ).forward(req, resp);
            return;
        }

        // KHÔNG gọi chain.doFilter nữa vì đã forward xong
         // Các trường hợp khác cứ cho đi qua
        chain.doFilter(req, resp);
    }
}
