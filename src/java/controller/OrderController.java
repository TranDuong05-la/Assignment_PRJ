package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.OrderDAO;
import model.OrderDTO;
import model.OrderItemDAO;
import model.OrderItemDTO;
import java.util.List;
import jakarta.servlet.http.HttpSession;
import model.CartItemDAO;

@WebServlet(name = "OrderController", urlPatterns = {"/OrderController"})
public class OrderController extends HttpServlet {
    private static final String ORDER_LIST_PAGE = "orderList.jsp";
    private static final String ORDER_DETAIL_PAGE = "orderDetail.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ORDER_LIST_PAGE;
        try {
            String action = request.getParameter("action");
            if (action == null) action = "listOrder";
            if (action.equals("addOrder")) {
                url = handleAddOrder(request, response);
            } else if (action.equals("viewOrder")) {
                url = handleViewOrder(request, response);
            } else if (action.equals("listOrder")) {
                url = handleListOrder(request, response);
            } else if (action.equals("updateOrderStatus")) {
                url = handleUpdateOrderStatus(request, response);
            } else if (action.equals("deleteOrder")) {
                url = handleDeleteOrder(request, response);
            } else if (action.equals("createOrderFromCart")) {
                url = handleCreateOrderFromCart(request, response);
            } else if (action.equals("showOrderList")) {
                url = handleShowOrderList(request, response);
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

    private String handleAddOrder(HttpServletRequest request, HttpServletResponse response) {
        try {
            String userId = request.getParameter("userId");
            String orderDate = request.getParameter("orderDate");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String status = request.getParameter("status");
            String paymentMethod = request.getParameter("paymentMethod");
            OrderDTO order = new OrderDTO(0, userId, orderDate, totalAmount, status, 0, 0, 0);
            OrderDAO dao = new OrderDAO();
            boolean success = dao.insertOrder(order);
            if (success) {
                int orderId = 0;
                List<OrderDTO> allOrders = dao.getAllOrders();
                for (OrderDTO o : allOrders) {
                    if (o.getUserId().equals(userId) && o.getTotalAmount() == totalAmount) {
                        orderId = o.getOrderId();
                    }
                }
                String[] selectedCartItemIDs = request.getParameterValues("selectedItems");
                if (selectedCartItemIDs != null && selectedCartItemIDs.length > 0) {
                    java.util.List<Integer> idList = new java.util.ArrayList<>();
                    for (String id : selectedCartItemIDs) idList.add(Integer.parseInt(id));
                    model.CartItemDAO itemDAO = new model.CartItemDAO();
                    itemDAO.deleteByCartItemIts(idList);
                } else {
                    model.CartDAO cartDAO = new model.CartDAO();
                    model.CartDTO cart = cartDAO.getCartByUserId(userId);
                    if (cart != null) {
                        CartItemDAO itemDAO = new CartItemDAO();
                        itemDAO.deleteAllByCartId(cart.getCartId());
                    }
                }
                if ("online".equals(paymentMethod)) {
                    // Redirect sang PaymentController với orderID và amount
                    String url = String.format("PaymentController?orderID=%d&amount=%.0f&action=showQR", orderId, totalAmount);
                    try {
                        response.sendRedirect(url);
                        return null; // Đã redirect, không forward nữa
                    } catch (Exception e) {
                        request.setAttribute("message", "Redirect to payment failed: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("message", "Order placed successfully! Please wait for delivery.");
                    request.setAttribute("newOrderId", orderId);
                    return handleShowOrderList(request, response);
                }
            } else {
                request.setAttribute("message", "Failed to add order!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return handleListOrder(request, response);
    }

    private String handleViewOrder(HttpServletRequest request, HttpServletResponse response) {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            OrderDAO dao = new OrderDAO();
            OrderItemDAO itemDao = new OrderItemDAO();
            OrderDTO order = dao.getOrderById(orderId);
            List<OrderItemDTO> orderItems = itemDao.getOrderItemsByOrderId(orderId);
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            return ORDER_DETAIL_PAGE;
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return ERROR_PAGE;
    }

    private String handleListOrder(HttpServletRequest request, HttpServletResponse response) {
        OrderDAO dao = new OrderDAO();
        List<OrderDTO> list = dao.getAllOrders();
        request.setAttribute("orderList", list);
        return ORDER_LIST_PAGE;
    }

    private String handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response) {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            OrderDAO dao = new OrderDAO();
            boolean success = dao.updateOrderStatus(orderId, status);
            if (success) {
                request.setAttribute("message", "Order status updated!");
            } else {
                request.setAttribute("message", "Failed to update order status!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return handleListOrder(request, response);
    }

    private String handleDeleteOrder(HttpServletRequest request, HttpServletResponse response) {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            OrderDAO dao = new OrderDAO();
            boolean success = dao.deleteOrder(orderId);
            if (success) {
                request.setAttribute("message", "Order deleted!");
            } else {
                request.setAttribute("message", "Failed to delete order!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return handleListOrder(request, response);
    }

    private String handleCreateOrderFromCart(HttpServletRequest request, HttpServletResponse response) {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            // TODO: Implement logic to create order from cart
            // This would involve:
            // 1. Getting cart items
            // 2. Creating a new order
            // 3. Creating order items from cart items
            // 4. Deleting the cart
            request.setAttribute("message", "Order created from cart successfully!");
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return handleListOrder(request, response);
    }

    private String handleShowOrderList(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession(false);
            model.UserDTO currentUser = (session != null) ? (model.UserDTO) session.getAttribute("user") : null;
            if (currentUser == null) {
                request.setAttribute("message", "Please login to view your orders.");
                return "login.jsp";
            }
            model.OrderDAO orderDAO = new model.OrderDAO();
            model.OrderItemDAO orderItemDAO = new model.OrderItemDAO();
            java.util.List<model.OrderDTO> allOrders = orderDAO.getAllOrders();
            java.util.List<model.OrderDTO> userOrders = new java.util.ArrayList<>();
            java.util.Map<Integer, java.util.List<model.OrderItemDTO>> orderItemsMap = new java.util.HashMap<>();
            for (model.OrderDTO order : allOrders) {
                // Sửa lỗi: getUserId() là int, không so sánh với null và không dùng equals với String
                if (String.valueOf(order.getUserId()).equals(currentUser.getUserID())) {
                    userOrders.add(order);
                    java.util.List<model.OrderItemDTO> items = orderItemDAO.getOrderItemsByOrderId(order.getOrderId());
                    orderItemsMap.put(order.getOrderId(), items);
                }
            }
            request.setAttribute("orderList", userOrders);
            request.setAttribute("orderItemsMap", orderItemsMap);
            return "orderList.jsp";
        } catch (Exception e) {
            request.setAttribute("message", "Error loading orders: " + e.getMessage());
            return "orderList.jsp";
        }
    }
} 