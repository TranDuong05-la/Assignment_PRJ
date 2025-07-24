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
    private static final String LOGIN_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = CART_PAGE;
        boolean redirected = false;
        try {
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;

            if (currentUser == null) {
                url = LOGIN_PAGE;
                request.setAttribute("message", "Please login to view your cart.");
            } else {
                String action = request.getParameter("action");
                if (action == null) {
                    action = "viewCart";
                }

                switch (action) {
                    case "addCart":
                        handleAddCart(request, session);
                        // Sau khi thêm, cập nhật lại cart và cartCount vào session
                        CartDAO cartDAO = new CartDAO();
                        CartDTO updatedCart = cartDAO.getCartByUserId(currentUser.getUserID());
                        session.setAttribute("cart", updatedCart);
                        session.setAttribute("cartCount", (updatedCart != null && updatedCart.getItems() != null) ? updatedCart.getItems().size() : 0);
                        String productId = request.getParameter("productId");
                        response.sendRedirect(request.getContextPath() + "/book/" + productId + "?added=1");
                        redirected = true;
                        return;
                    case "updateQuantity":
                        handleUpdateQuantity(request, session, currentUser.getUserID());
                        
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
                    case "viewCart":
                        CartDAO cartDAO2 = new CartDAO();
                        CartDTO cart2 = cartDAO2.getCartByUserId(currentUser.getUserID());
                        session.setAttribute("cart", cart2);
                        url = CART_PAGE;
                        break;
                }
                // Luôn show cart sau mọi action (trừ khi đang ở cartDetail)
                if (!url.equals("cartDetail.jsp")) {
                    CartDAO cartDAO = new CartDAO();
                    CartDTO cart = cartDAO.getCartByUserId(currentUser.getUserID());
                    request.setAttribute("cart", cart);
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
            if (!redirected) {
                request.getRequestDispatcher(url).forward(request, response);
            }
        }
    }

    private void handleAddCart(HttpServletRequest request, HttpSession session) {
        try {
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user == null) return;
            String userId = user.getUserID();
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = 1;
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (Exception ignored) {}
            CartDAO cartDAO = new CartDAO();
            CartDTO cart = cartDAO.getCartByUserId(userId);
            if (cart == null) {
                cartDAO.createCartForUser(userId);
                cart = cartDAO.getCartByUserId(userId);
            }
            CartItemDAO itemDAO = new CartItemDAO();
            CartItemDTO existing = itemDAO.getCartItemByCartIdAndProductId(cart.getCartId(), productId);
            if (existing != null) {
                itemDAO.updateCartItemQuantity(existing.getCartItemID(), existing.getQuantity() + quantity);
            } else {
                CartItemDTO newItem = new CartItemDTO();
                newItem.setCartID(cart.getCartId());
                newItem.setBookID(productId);
                newItem.setQuantity(quantity);
                itemDAO.insertCartItem(newItem);
            }
            CartDTO updatedCart = cartDAO.getCartByUserId(userId);
            int cartCount = (updatedCart != null && updatedCart.getItems() != null) ? updatedCart.getItems().size() : 0;
            session.setAttribute("cartCount", cartCount);
            session.setAttribute("cart", updatedCart); // Thêm dòng này để cartList.jsp lấy được cart mới nhất
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleUpdateQuantity(HttpServletRequest request, HttpSession session, String userId) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("cartItemID"));
            int change = Integer.parseInt(request.getParameter("change"));
            int currentQuantity = Integer.parseInt(request.getParameter("currentQuantity"));
            int newQuantity = currentQuantity + change;
            if (newQuantity >= 1 && newQuantity <= 10) {
                CartItemDAO itemDAO = new CartItemDAO();
                itemDAO.updateCartItemQuantity(cartItemID, newQuantity);
            }
            // Cập nhật lại cart và cartCount vào session
            CartDAO cartDAO = new CartDAO();
            CartDTO updatedCart = cartDAO.getCartByUserId(userId);
            session.setAttribute("cart", updatedCart);
            int cartCount = (updatedCart != null && updatedCart.getItems() != null) ? updatedCart.getItems().size() : 0;
            session.setAttribute("cartCount", cartCount);
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
            // Cập nhật lại cartCount và cart trong session sau khi xóa
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null) {
                CartDAO cartDAO = new CartDAO();
                CartDTO updatedCart = cartDAO.getCartByUserId(user.getUserID());
                int cartCount = (updatedCart != null && updatedCart.getItems() != null) ? updatedCart.getItems().size() : 0;
                session.setAttribute("cartCount", cartCount);
                session.setAttribute("cart", updatedCart);
            }
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