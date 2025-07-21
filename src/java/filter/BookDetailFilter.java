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

        // Cắt lấy số id cuối cùng (dạng /book/1)
        String[] split = path.split("/");
        String bookId = split[split.length - 1];

        // Chuyển sang controller, forward nội bộ, KHÔNG chuyển địa chỉ trình duyệt
        // (có thể dùng forward, không dùng sendRedirect)
        request.getRequestDispatcher(
                "/ProductController?action=bookDetail&bookID=" + bookId
        ).forward(req, resp);

        // KHÔNG gọi chain.doFilter nữa vì đã forward xong
    }
}
