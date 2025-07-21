 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "MainController", urlPatterns = {"","/", "/MainController"})

public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";
     private static final String HOME_PAGE = "home.jsp";

    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "logout".equals(action)
                || "signUp".equals(action)
                || "reset".equals(action);
    }

    private boolean isAddressAction(String action) {
        return "list".equals(action)
                || "add".equals(action)
                || "edit".equals(action)
                || "update".equals(action)
                || "delete".equals(action)
                || "setDefault".equals(action);
    }

    private boolean isPaymentAction(String action) {
        return "showQR".equals(action)
                || "applyDiscount".equals(action)
                || "confirm".equals(action);
    }
    
    private boolean isDiscountAction(String action) {
        return "create".equals(action)
              ||"viewAll".equals(action);
    }
// ----------quản lý sản phẩm & phân loại-------------------

    private boolean isProductAction(String action) {
        return "listBook".equals(action)
                || "bookDetail".equals(action)
                || "addBook".equals(action)
                || "editBook".equals(action)
                || "updateBook".equals(action)
                || "deleteBook".equals(action)
                || "searchBook".equals(action);
    }

    private boolean isCategoryAction(String action) {
        return "listCategory".equals(action)
                || "addCategory".equals(action)
                || "editCategory".equals(action)
                || "updateCategory".equals(action)
                || "deleteCategory".equals(action);
    }

    private boolean isInventoryAction(String action) {
        return "showInventory".equals(action)
                || "editInventory".equals(action)
                || "updateInventory".equals(action);
    }

    private boolean isReviewAction(String action) {
        return "listReview".equals(action)
                || "addReview".equals(action)
                || "deleteReview".equals(action);
    }
 private boolean isOrderAction(String action) {
        return "addOrder".equals(action)
                || "viewOrder".equals(action)
                || "listOrder".equals(action)
                || "updateOrderStatus".equals(action)
                || "deleteOrder".equals(action)
                || "createOrderFromCart".equals(action);
    }
    
    private boolean isCartAction(String action) {
        return "addCart".equals(action)
                || "viewCart".equals(action)
                || "listCart".equals(action)
                || "updateQuantity".equals(action)
                || "removeItem".equals(action)
                || "viewDeleted".equals(action)
                || "deleteCart".equals(action);
        
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = HOME_PAGE;
        try {
            String action = request.getParameter("action");
            if (isUserAction(action)) {
                url = "/UserController";
            } else if (isAddressAction(action)) {
                url = "/AddressController";
            } else if (isPaymentAction(action)) {
                url = "/PaymentController";
            } else if (isDiscountAction(action)) {
                url = "/DiscountController";
            } else if (isProductAction(action)) {
                url = "/ProductController";
            } else if (isCategoryAction(action)) {
                url = "/CategoryController";
            } else if (isInventoryAction(action)) {
                url = "/InventoryController";
            } else if (isReviewAction(action)) {
                url = "/ReviewController";
            } else if (isOrderAction(action)) {
                url = "/OrderController";
            } else if (isCartAction(action)) {
                url = "/CartController";
            }
        } catch (Exception e) {

        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
