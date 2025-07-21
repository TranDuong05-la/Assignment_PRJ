package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

// Đặt filter cho các form, dùng chung được cho nhiều form khác nhau
@WebFilter(urlPatterns = {"/productForm.jsp", "/categoryForm.jsp", "/userForm.jsp","/home"})
public class FormFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        String uri = req.getRequestURI();

        // --- Product Form ---
        if (uri.endsWith("productForm.jsp")) {
            if (request.getAttribute("categories") == null) {
                // Kiểm tra có phải edit không
                String qs = req.getQueryString();
                String forwardUrl = "/ProductController?action=addBook";
                if (qs != null && qs.contains("edit")) {
                    forwardUrl = "/ProductController?action=editBook&" + qs.replace("edit&", "");
                }
                // forward (không redirect)
                request.getRequestDispatcher(forwardUrl).forward(request, response);
                return;
            }
        }
        // --- Category Form ---
        else if (uri.endsWith("categoryForm.jsp")) {
            if (request.getAttribute("categoryList") == null) {
                request.getRequestDispatcher("/CategoryController?action=addCategory").forward(request, response);
                return;
            }
        }
        // --- User Form... ---

        // Tiếp tục filter/servlet nếu đã có attribute hoặc không match
        chain.doFilter(request, response);
    }
}
