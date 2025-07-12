package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.time.LocalDateTime;
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
        double amount = Double.parseDouble(request.getParameter("amount"));

        String bankId = "TPB";
        String accountNo = "08080512276";
        String template = "compact2";
        String addInfo = "Order #" + orderID;
        String accountName = "Nguyen Van A";

        try {
            String qrUrl = "https://img.vietqr.io/image/" + bankId + "-" + accountNo + "-" + template + ".png"
                    + "?amount=" + amount
                    + "&addInfo=" + URLEncoder.encode(addInfo, "UTF-8")
                    + "&accountName=" + URLEncoder.encode(accountName, "UTF-8");
            request.setAttribute("qrUrl", qrUrl);
            request.setAttribute("orderID", orderID);
            request.setAttribute("amount", amount);
        } catch (Exception ex) {
            request.setAttribute("message", "Can't create QR code");
        }
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
