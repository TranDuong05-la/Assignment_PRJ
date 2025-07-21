package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartDAO;
import model.CartDTO;
import model.UserDTO;
import model.CartItemDAO;
import model.CartItemDTO;

import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {"/CartController"})
public class CartController extends HttpServlet {
    private static final String CART_PAGE = "cartList.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "cartList.jsp";
        try {
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;

            if (currentUser == null) {
                url = "login.jsp";
                request.setAttribute("message", "Please login to view your cart.");
            } else {
                String action = request.getParameter("action");
                if (action == null) {
                    action = "viewCart";
                }

                switch (action) {
                    case "updateQuantity":
                        handleUpdateQuantity(request);
                        break;
                    case "deleteItem":
                        handleDeleteItem(request, session);
                        break;
                    case "undoDelete":
                        handleUndoDelete(request, session);
                        url = "cartDetail.jsp";
                        break;
                    case "restoreAll":
                        handleRestoreAll(request, session);
                        url = "cartDetail.jsp";
                        break;
                    case "viewDeleted":
                        url = "cartDetail.jsp";
                        break;
                }
                // Always show the cart after any action (trừ khi đang ở cartDetail)
                if (!url.equals("cartDetail.jsp")) {
                    CartDAO cartDAO = new CartDAO();
                    CartDTO cart = cartDAO.getCartByUserId(currentUser.getUserID());
                    request.setAttribute("cart", cart);
                    // --- Cập nhật cartCount vào session: đếm số sản phẩm khác nhau ---
                    int cartCount = 0;
                    if (cart != null && cart.getItems() != null) {
                        cartCount = cart.getItems().size();
                    }
                    session.setAttribute("cartCount", cartCount);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void handleUpdateQuantity(HttpServletRequest request) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("cartItemID"));
            int change = Integer.parseInt(request.getParameter("change"));
            int currentQuantity = Integer.parseInt(request.getParameter("currentQuantity"));
            int newQuantity = currentQuantity + change;
            if (newQuantity >= 1) {
                CartItemDAO itemDAO = new CartItemDAO();
                itemDAO.updateCartItemQuantity(cartItemID, newQuantity);
            }
            // Không cho phép về 0 hoặc nhỏ hơn, không xóa luôn
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    private void handleDeleteItem(HttpServletRequest request, HttpSession session) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("cartItemID"));
            CartItemDAO itemDAO = new CartItemDAO();
            CartItemDTO deletedItem = itemDAO.getCartItemById(cartItemID); // Sửa lại thành getCartItemById
            if (deletedItem != null) {
                List<CartItemDTO> deletedList = (List<CartItemDTO>) session.getAttribute("deletedCartItems");
                if (deletedList == null) deletedList = new java.util.ArrayList<>();
                deletedList.add(deletedItem);
                session.setAttribute("deletedCartItems", deletedList);
                request.setAttribute("message", "Item moved to Recently Deleted. You can restore it!");
            }
            itemDAO.deleteCartItem(cartItemID);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    private void handleUndoDelete(HttpServletRequest request, HttpSession session) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("undoCartItemID"));
            List<CartItemDTO> deletedList = (List<CartItemDTO>) session.getAttribute("deletedCartItems");
            if (deletedList != null) {
                CartItemDTO toRestore = null;
                for (CartItemDTO item : deletedList) {
                    if (item.getCartItemID() == cartItemID) {
                        toRestore = item;
                        break;
                    }
                }
                if (toRestore != null) {
                    CartItemDAO itemDAO = new CartItemDAO();
                    itemDAO.insertCartItem(toRestore);
                    deletedList.remove(toRestore);
                    session.setAttribute("deletedCartItems", deletedList);
                    request.setAttribute("message", "Item restored to your cart!");
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    private void handleRestoreAll(HttpServletRequest request, HttpSession session) {
        List<CartItemDTO> deletedList = (List<CartItemDTO>) session.getAttribute("deletedCartItems");
        if (deletedList != null && !deletedList.isEmpty()) {
            CartItemDAO itemDAO = new CartItemDAO();
            for (CartItemDTO item : new java.util.ArrayList<>(deletedList)) {
                itemDAO.insertCartItem(item);
                deletedList.remove(item);
            }
            session.setAttribute("deletedCartItems", deletedList);
            request.setAttribute("message", "All items have been restored to your cart!");
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
} 