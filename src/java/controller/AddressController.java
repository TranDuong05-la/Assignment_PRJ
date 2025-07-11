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
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.AddressDAO;
import model.AddressDTO;
import model.UserDTO;

/**
 *
 * @author Admin
 */
@WebServlet(name = "AddressController", urlPatterns = {"/AddressController"})
public class AddressController extends HttpServlet {
    private static final String LIST_PAGE = "addressList.jsp";
    private static final String FORM_PAGE = "addressForm.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        try {
            String action = request.getParameter("action");
            if (action.equals("list")) {
                url = handleList(request, response);
            } else if (action.equals("add")) {
                url = handleAddressAdding(request, response);
            } else if (action.equals("edit")) {
                url = handleEdit(request, response);
            } else if (action.equals("delete")) {
                url = handleDelete(request, response);
            } else if (action.equals("setDefault")) {
                url = handleSetDefault(request, response);
            } else {
                request.setAttribute("message", "Invalid action:" + action + "!");
                url = "";
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    private String handleList(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        request.setAttribute("message", "Please log in first.");
        return "login.jsp";
    }

    String userID = user.getUserID(); 

    AddressDAO dao = new AddressDAO();
    List<AddressDTO> list = dao.getAddressesByUser(userID);
    request.setAttribute("addresses", list);

    String msg = request.getParameter("message");
    if (msg != null) request.setAttribute("message", msg);

    return LIST_PAGE;
    }

    private String handleAddressAdding(HttpServletRequest request, HttpServletResponse response) {
    HttpSession session = request.getSession();
    UserDTO user = (UserDTO) session.getAttribute("user");

    if (user == null) {
        request.setAttribute("message", "Please log in first.");
        return "login.jsp";
    }

    if (request.getParameter("recipientName") == null) {
        request.setAttribute("isEdit", false);
        return FORM_PAGE;
    }

    String userID = user.getUserID();
    AddressDTO address = new AddressDTO();
    address.setUserID(userID);
    address.setRecipientName(request.getParameter("recipientName"));
    address.setPhone(request.getParameter("phone"));
    address.setAddressDetail(request.getParameter("addressDetail"));
    address.setDistrict(request.getParameter("district"));
    address.setCity(request.getParameter("city"));
    address.setDefault("on".equals(request.getParameter("isDefault")));

    AddressDAO dao = new AddressDAO();
    if (address.isDefault()) {
        dao.unsetDefaultAddress(userID);
    }
    
    boolean success = dao.insertAddress(address);
    request.setAttribute("message", success ? "Address added successfully." : "Failed to add address.");
    return FORM_PAGE;
    
}


    private String handleEdit(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            request.setAttribute("message", "Please log in first.");
            return "login.jsp";
        }

        String userID = user.getUserID();

        if (request.getParameter("recipientName") == null) {
            int addressID = Integer.parseInt(request.getParameter("addressID"));
            AddressDTO addr = new AddressDAO().getAddressByID(addressID);
            request.setAttribute("address", addr);
            return FORM_PAGE;
        }

        AddressDTO addr = new AddressDTO();
        addr.setAddressID(Integer.parseInt(request.getParameter("addressID")));
        addr.setUserID(userID);
        addr.setRecipientName(request.getParameter("recipientName"));
        addr.setPhone(request.getParameter("phone"));
        addr.setAddressDetail(request.getParameter("addressDetail"));
        addr.setDistrict(request.getParameter("district"));
        addr.setCity(request.getParameter("city"));
        addr.setDefault("on".equals(request.getParameter("isDefault")));

        AddressDAO dao = new AddressDAO();
        if (addr.isDefault()) {
            dao.unsetDefaultAddress(userID);
        }

        boolean success = dao.updateAddress(addr);
        request.setAttribute("message", success ? "Address updated." : "Failed to update.");
        request.setAttribute("isEdit", true);
        return FORM_PAGE;
    }

    private String handleDelete(HttpServletRequest request, HttpServletResponse response) {
        int id = Integer.parseInt(request.getParameter("addressID"));
        AddressDAO dao = new AddressDAO();
        boolean success = dao.deleteAddress(id);
        request.setAttribute("message", success ? "Address deleted." : "Failed to delete.");
        return handleList(request, response);
    }

    private String handleSetDefault(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String userID = (String) session.getAttribute("userID");
        int addressID = Integer.parseInt(request.getParameter("addressID"));

        AddressDAO dao = new AddressDAO();
        dao.unsetDefaultAddress(userID);
        dao.setDefaultAddress(addressID);

        return handleList(request, response);
    }

}
