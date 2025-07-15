package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CartDAO;
import model.CartDTO;

@WebServlet(name = "CartController", urlPatterns = {"/CartController"})
public class CartController extends HttpServlet {
    private static final String CART_PAGE = "cartList.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = CART_PAGE;
        try {
            String action = request.getParameter("action");
            if (action == null) action = "viewCart";
            if (action.equals("addCart")) {
                url = handleAddCart(request, response);
            } else if (action.equals("viewCart")) {
                url = handleViewCart(request, response);
            } else if (action.equals("deleteCart")) {
                url = handleDeleteCart(request, response);
            } else {
                request.setAttribute("message", "Invalid action: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error occurred!");
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private String handleAddCart(HttpServletRequest request, HttpServletResponse response) {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String createdTime = request.getParameter("createdTime");
            CartDTO cart = new CartDTO(0, userId, createdTime);
            CartDAO dao = new CartDAO();
            boolean success = dao.insertCart(cart);
            if (success) {
                request.setAttribute("message", "Cart created!");
            } else {
                request.setAttribute("message", "Failed to create cart!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return CART_PAGE;
    }

    private String handleViewCart(HttpServletRequest request, HttpServletResponse response) {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            CartDAO dao = new CartDAO();
            CartDTO cart = dao.getCartByUserId(userId);
            request.setAttribute("cart", cart);
            return CART_PAGE;
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return ERROR_PAGE;
    }

    private String handleDeleteCart(HttpServletRequest request, HttpServletResponse response) {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            CartDAO dao = new CartDAO();
            boolean success = dao.deleteCart(cartId);
            if (success) {
                request.setAttribute("message", "Cart deleted!");
            } else {
                request.setAttribute("message", "Failed to delete cart!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return CART_PAGE;
    }
} 