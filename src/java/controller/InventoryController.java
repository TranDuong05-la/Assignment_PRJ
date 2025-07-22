/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.BookDAO;
import model.BookDTO;
import model.InventoryDAO;
import model.InventoryDTO;
import utils.AuthUtils;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "InventoryController", urlPatterns = {"/InventoryController"})
public class InventoryController extends HttpServlet {

    InventoryDAO idao = new InventoryDAO();
    BookDAO bdao = new BookDAO();

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
        String url = "inventory.jsp";
        //                System.out.println("1");
        try {
            String action = request.getParameter("action");
//      Xữ lí action của user
            if (action.equals("showInventory")) {
                url = handleInventoryShowing(request, response);
            } else if (action.equals("createInventory")) {
                url = handleInventoryCreating(request, response);
            } else if (action.equals("editInventory")) {
                url = handleInventoryEditing(request, response);
            } else if (action.equals("updateInventory")) {
                url = handleInventoryUpdating(request, response);
            }
        } catch (Exception e) {
        } finally {
            System.out.println(url);
//            chuyển trang sang url mới ( request dựa trên url ở bên trên)
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

    private String handleInventoryShowing(HttpServletRequest request, HttpServletResponse response) {
        List<InventoryDTO> inventories = idao.getAll();
        List<BookDTO> books = bdao.getAll();
        request.setAttribute("inventories", inventories);
        request.setAttribute("books", books);
        return "inventory.jsp";
    }

    private String handleInventoryUpdating(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";
        String keyWord = request.getParameter("strKeyword");
        if (AuthUtils.isAdmin(request)) {
            String inId = request.getParameter("inventoryID");
            System.out.println("Inventory ID = " + inId); // debug
            String bId = request.getParameter("bookID");
            String quantity = request.getParameter("quantity");
            int inventoryID = 0;
            try {
                inventoryID = Integer.parseInt(inId);
            } catch (Exception e) {
            }

            int bookID = 0;
            try {
                bookID = Integer.parseInt(bId);
            } catch (Exception e) {
            }
            int quantity_value = 0;
            try {
                quantity_value = Integer.parseInt(quantity);
            } catch (Exception e) {
            }
//          check loi
            if (quantity_value < 0) {
                checkError = "Quantity must be >= 0";
            }

            if (checkError.isEmpty()) {
                InventoryDTO inventory = new InventoryDTO(inventoryID, bookID, quantity_value, null);
                if (idao.update(inventory)) {
                    message = "Update inventory successfully!";
                    return handleInventoryShowing(request, response);
                } else {
                    checkError = "Cannot update inventory!";
                }
            }
            InventoryDTO inventory = new InventoryDTO(inventoryID, bookID, quantity_value, null);
            request.setAttribute("inventory", inventory);
            request.setAttribute("isEdit", true);
        }
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        request.setAttribute("keyword", keyWord);
        return "inventoryForm.jsp";
    }

    private String handleInventoryEditing(HttpServletRequest request, HttpServletResponse response) {
        if (AuthUtils.isAdmin(request)) {
            String inId = request.getParameter("inventoryID");
            String keyWord = request.getParameter("strKeyword");

            int inventoryID = 0;
            try {
                inventoryID = Integer.parseInt(inId);
            } catch (Exception e) {
            }

            InventoryDTO inventory = idao.getInventoryById(inventoryID);
            List<BookDTO> books = bdao.getAll();
            request.setAttribute("inventory", inventory);
            request.setAttribute("books", books);
            request.setAttribute("keyword", keyWord);
            request.setAttribute("isEdit", true);
            return "inventoryForm.jsp";

        } else {
            request.setAttribute("checkError", "Invalid inventory ID!");
        }
        return handleInventoryShowing(request, response);
    }

    private String handleInventoryCreating(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";
        String keyWord = request.getParameter("strKeyword");
        List<BookDTO> books = bdao.getAll();
        request.setAttribute("books", books);
        if (AuthUtils.isAdmin(request)) {
            try {
                String bId = request.getParameter("bookID");
                String quantity = request.getParameter("quantity");
                int bookID = 0;
                int quantity_value = 0;
                try {
                    bookID = Integer.parseInt(bId);
                } catch (Exception e) {
                    checkError = "Invalid Book ID!";
                }
                try {
                    quantity_value = Integer.parseInt(quantity);
                } catch (Exception e) {
                    checkError = "Invalid Quantity!";
                }
                if (quantity_value < 0) {
                    checkError = "Quantity must be >= 0";
                }
                if (checkError.isEmpty()) {
                    InventoryDTO inventory = new InventoryDTO(0, bookID, quantity_value, null);
                    boolean success = idao.create(inventory);
                    if (success) {
                        message = "Created inventory successfully!";
                        return handleInventoryShowing(request, response);
                    } else {
                        checkError = "Cannot create inventory!";
                    }
                }
                InventoryDTO inventory = new InventoryDTO(0, bookID, quantity_value, null);
                request.setAttribute("inventory", inventory);

            } catch (Exception e) {
                checkError = "Error: " + e.getMessage();
                e.printStackTrace();
            }
            request.setAttribute("isEdit", false);
        }
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        request.setAttribute("keyword", keyWord);
        return "inventoryForm.jsp";
    }

}
