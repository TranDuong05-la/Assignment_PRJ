package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.DiscountDAO;
import model.DiscountDTO;
import model.PaymentDAO;
import model.PaymentDTO;

@WebServlet(name = "PaymentController", urlPatterns = {"/PaymentController"})
public class PaymentController extends HttpServlet {

    private static final String PAYMENT_PAGE = "payment.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = PAYMENT_PAGE;
        try {
            String action = request.getParameter("action");

            if ("showQR".equals(action)) {
                handleShowQR(request, response);
            } else if ("confirm".equals(action)) {
                handleConfirm(request, response);
            } else if ("applyDiscount".equals(action)) {
                handleApplyDiscount(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An unexpected error occurred.");
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void handleShowQR(HttpServletRequest request, HttpServletResponse response) {
    int orderID = Integer.parseInt(request.getParameter("orderID"));
    double originalAmount = Double.parseDouble(request.getParameter("amount"));
    double amount = originalAmount;

    String discountCode = request.getParameter("discountCode");
    if (discountCode != null && !discountCode.trim().isEmpty()) {
        DiscountDAO discountDAO = new DiscountDAO();
        DiscountDTO discount = discountDAO.getValidDiscount(discountCode);

        if (discount != null && originalAmount >= discount.getMinOrderAmount()) {
            if (discount.getType().equalsIgnoreCase("percent")) {
                amount = originalAmount * (1 - discount.getValue() / 100);
            } else if (discount.getType().equalsIgnoreCase("fixed")) {
                amount = originalAmount - discount.getValue();
            }
            if (amount < 0) amount = 0;

            request.setAttribute("message", "Discount applied successfully!");
        } else {
            request.setAttribute("message", "Invalid or expired discount code.");
        }
    }

    String bankId = "TPB";
    String accountNo = "08080512276";
    String template = "compact2";
    String addInfo = "Order #" + orderID;
    String accountName = "Tran Anh Ngan";

    try {
        String qrUrl = "https://img.vietqr.io/image/" + bankId + "-" + accountNo + "-" + template + ".png"
                + "?amount=" + (long)amount
                + "&addInfo=" + URLEncoder.encode(addInfo, "UTF-8")
                + "&accountName=" + URLEncoder.encode(accountName, "UTF-8");
        request.setAttribute("qrUrl", qrUrl);
    } catch (Exception ex) {
        request.setAttribute("message", "Can't create QR code.");
    }

    request.setAttribute("orderID", orderID);
    request.setAttribute("amount", amount);
}

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response) {
        int orderID = Integer.parseInt(request.getParameter("orderID"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String method = "VietQR";

        PaymentDTO payment = new PaymentDTO();
        payment.setOrderID(orderID);
        payment.setAmount(amount);
        payment.setMethod(method);
        payment.setStatus("paid");
        payment.setPaymentDate(Timestamp.valueOf(LocalDateTime.now()));

        PaymentDAO dao = new PaymentDAO();
        boolean success = dao.addPayment(payment);

        if (success) {
            request.setAttribute("message", "Payment successful!");
        } else {
            request.setAttribute("message", "Payment failed. Please try again.");
        }

        request.setAttribute("orderID", orderID);
        request.setAttribute("amount", amount);
        handleShowQR(request, response);
    }

    private void handleApplyDiscount(HttpServletRequest request, HttpServletResponse response) {
        int orderID = Integer.parseInt(request.getParameter("orderID"));
        double originalAmount = Double.parseDouble(request.getParameter("amount"));
        String code = request.getParameter("discountCode");

        DiscountDAO ddao = new DiscountDAO();
        DiscountDTO discount = ddao.getValidDiscount(code);

        if (discount == null) {
            request.setAttribute("message", "Invalid or expired discount code.");
            request.setAttribute("orderID", orderID);
            request.setAttribute("amount", originalAmount);
            request.setAttribute("discountCode", code);
            handleShowQR(request, response); 
            return;
        }

        double finalAmount = originalAmount;
        if (originalAmount >= discount.getMinOrderAmount()) {
            if (discount.getType().equalsIgnoreCase("percent")) {
                finalAmount = originalAmount * (1 - discount.getValue() / 100.0);
            } else {
                finalAmount = originalAmount - discount.getValue();
            }
        }

        request.setAttribute("message", "Discount applied successfully!");
        request.setAttribute("orderID", orderID);
        request.setAttribute("amount", originalAmount);
        request.setAttribute("finalAmount", finalAmount);
        request.setAttribute("discountCode", code);
        handleShowQR(request, response);
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
