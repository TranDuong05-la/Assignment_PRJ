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
        boolean forwarded = false;
        try {
            String action = request.getParameter("action");
            if (action == null) action = "listOrder";
            if (action.equals("addOrder")) {
                String resultUrl = handleAddOrder(request, response);
                if (resultUrl != null) {
                    request.getRequestDispatcher(resultUrl).forward(request, response);
                    forwarded = true;
                }
                return;
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
            if (!forwarded && url != null) {
                request.getRequestDispatcher(url).forward(request, response);
            }
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
            String userID = request.getParameter("userId");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String paymentMethod = request.getParameter("paymentMethod");
            String status = "Pending";
            String orderDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
            String shippingAddress = request.getParameter("shippingAddress");
            String phone = request.getParameter("phone");
            String note = request.getParameter("note");
    
            OrderDTO order = new OrderDTO(0, userID, orderDate, totalAmount, status, shippingAddress, phone, note);
            OrderDAO dao = new OrderDAO();
            boolean success = dao.insertOrder(order);
            if (success) {
                Integer orderID = dao.getLatestOrderIdByUser(userID);
                // Bổ sung: Lưu các sản phẩm từ cart vào orderItem
                model.CartDAO cartDAO = new model.CartDAO();
                model.CartDTO cart = cartDAO.getCartByUserId(userID);
                if (cart != null && cart.getItems() != null && !cart.getItems().isEmpty()) {
                    model.OrderItemDAO orderItemDAO = new model.OrderItemDAO();
                    for (model.CartItemDTO cartItem : cart.getItems()) {
                        model.OrderItemDTO orderItem = new model.OrderItemDTO();
                        orderItem.setOrderId(orderID);
                        orderItem.setProductId(cartItem.getBookID());
                        orderItem.setQuantity(cartItem.getQuantity());
                        orderItem.setPrice(cartItem.getBook().getPrice());
                        orderItemDAO.insertOrderItem(orderItem);
                    }
                    // Xóa cart sau khi đặt hàng
                    model.CartItemDAO cartItemDAO = new model.CartItemDAO();
                    cartItemDAO.deleteCartItemsByCartId(cart.getCartId());
                }
                if ("online".equals(paymentMethod)) {
                    request.setAttribute("orderID", orderID);
                    request.setAttribute("amount", totalAmount);
                    // Sau khi thanh toán online thành công, chuyển về listOrder
                    return "MainController?action=showQR&orderID=" + orderID + "&amount=" + totalAmount;
                } else {
                    // COD: show thông báo thành công, sau đó chuyển về listOrder
                    request.setAttribute("message", "Order Success! Your order has been placed.");
                    // Chuyển về danh sách đơn hàng cá nhân
                    return "OrderController?action=listOrder";
                }
            } else {
                request.setAttribute("message", "Failed to add order!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        return "checkout.jsp";
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
        model.UserDTO user = (model.UserDTO) request.getSession().getAttribute("user");
        OrderDAO dao = new OrderDAO();
        java.util.List<OrderDTO> list;
        if (user != null && !"admin".equalsIgnoreCase(user.getRole())) {
            list = dao.getOrdersByUserId(user.getUserID());
        } else {
            list = dao.getAllOrders();
        }
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
            // Xóa orderItem trước để tránh lỗi khoá ngoại
            OrderItemDAO itemDAO = new OrderItemDAO();
            itemDAO.deleteOrderItemsByOrderId(orderId);
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
        OrderDAO dao = new OrderDAO();
        List<OrderDTO> list = dao.getAllOrders();
        request.setAttribute("orderList", list);
        return ORDER_LIST_PAGE;
    }
} 