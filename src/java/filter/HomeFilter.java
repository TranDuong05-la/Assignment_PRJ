package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// Filter áp dụng cho /, /home, /books
@WebFilter(urlPatterns = {"/", "/home", "/books"})
public class HomeFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Forward tới Controller xử lý listBook
        // Nếu đang ở /, /home, /books thì forward đến ProductController
        // Forward nội bộ, người dùng vẫn thấy /home, / hoặc /books trên URL
        RequestDispatcher rd = request.getRequestDispatcher("/ProductController?action=listBook");
        rd.forward(request, response);
        // Nếu muốn code cực sạch, không chain.doFilter() nữa!
        // chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

    @Override
    public void destroy() { }
}
