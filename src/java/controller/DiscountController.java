package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import model.DiscountDAO;
import model.DiscountDTO;

@WebServlet(name = "DiscountController", urlPatterns = {"/DiscountController"})
public class DiscountController extends HttpServlet {

    private static final String CREATE_PAGE = "createDiscount.jsp";
    private static final String VIEW_PAGE = "viewDiscounts.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = VIEW_PAGE;

        try {
            String action = request.getParameter("action");
            if ("create".equals(action)) {
                handleCreate(request,response);
            } else if ("viewAll".equals(action)) {
                handleViewAll(request,response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error occurred.");
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

 private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String code = request.getParameter("code");
            String type = request.getParameter("type");
            double value = Double.parseDouble(request.getParameter("value"));
            double minOrderAmount = Double.parseDouble(request.getParameter("minOrderAmount"));
            Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));

            DiscountDTO discount = new DiscountDTO();
            discount.setCode(code);
            discount.setType(type);
            discount.setValue(value);
            discount.setMinOrderAmount(minOrderAmount);
            discount.setExpiryDate(expiryDate);

            DiscountDAO dao = new DiscountDAO();
            boolean success = dao.addDiscount(discount);

            if (success) {
                request.setAttribute("message", "Discount created successfully!");
            } else {
                request.setAttribute("message", "Failed to create discount. Code might be duplicated.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Invalid input. Please check your data.");
        }finally {
            request.getRequestDispatcher(CREATE_PAGE).forward(request, response);
        }
    }

    private void handleViewAll(HttpServletRequest request, HttpServletResponse response){
        DiscountDAO dao = new DiscountDAO();
        List<DiscountDTO> discounts = dao.getAllDiscounts();
        request.setAttribute("discounts", discounts);
        
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

    @Override
    public String getServletInfo() {
        return "Discount Controller";
    }
}
