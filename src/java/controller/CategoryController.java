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
import model.CategoryDAO;
import model.CategoryDTO;
import utils.AuthUtils;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "CategoryController", urlPatterns = {"/CategoryController"})
public class CategoryController extends HttpServlet {

    CategoryDAO cdao = new CategoryDAO();
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
        String url = "";
        //                System.out.println("1");
        try {
            String action = request.getParameter("action");
//      Xữ lí action của user
            if (action.equals("listCategory")) {
                url = handleCategoryListing(request, response);
            } else if (action.equals("addCategory")) {
                url = handleCategoryAdding(request, response);
            } else if (action.equals("editCategory")) {
                url = handleCategoryEditing(request, response);
            } else if (action.equals("updateCategory")) {
                url = handleCategoryUpdating(request, response);
            } else if (action.equals("deleteCategory")) {
                url = handleCategoryDeleting(request, response);
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

    private String handleCategoryListing(HttpServletRequest request, HttpServletResponse response) {
        String catIdRaw = request.getParameter("categoryID");
//        String priceMinRaw = request.getParameter("priceMin");
//        String priceMaxRaw = request.getParameter("priceMax");
//        String publisher = request.getParameter("pub");
//        String author = request.getParameter("author");
//        String ratingRaw = request.getParameter("rating");
        List<BookDTO> products;
//        Integer categoryId = (catIdRaw != null && !catIdRaw.isEmpty()) ? Integer.parseInt(catIdRaw) : null;
//        Integer priceMin = (priceMinRaw != null && !priceMinRaw.isEmpty()) ? Integer.parseInt(priceMinRaw) : null;
//
//        Integer priceMax = (priceMaxRaw != null && !priceMaxRaw.isEmpty()) ? Integer.parseInt(priceMaxRaw) : null;
//
//        Integer rating = (ratingRaw != null && !ratingRaw.isEmpty()) ? Integer.parseInt(ratingRaw) : null;
//        if ((catIdRaw == null || catIdRaw.isEmpty())
//                && (publisher == null || publisher.isEmpty())
//                && (author == null || author.isEmpty())
//                && priceMax == 500) {
//            products = bdao.getAll();
//        } else {
//            products = bdao.getFilterBooks(categoryId, priceMin, priceMax, publisher, author, rating);
//        }
        if (catIdRaw != null && !catIdRaw.isEmpty()) {
            int catId = Integer.parseInt(catIdRaw);
            products = bdao.getBooksByCategory(catId);
        } else {
            products = bdao.getAll();
        }
        List<CategoryDTO> categories = cdao.getAll();
//        request.setAttribute("selectedCategoryId", catIdRaw);
//        request.setAttribute("priceMin", priceMinRaw);
//        request.setAttribute("priceMax", priceMaxRaw);
//        request.setAttribute("selectedPub", publisher);
//        request.setAttribute("selectedAuthor", author);
//        request.setAttribute("selectedRating", ratingRaw);
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        return "category.jsp";
    }

    private String handleCategoryAdding(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";
        if (AuthUtils.isAdmin(request)) {
            String name = request.getParameter("categoryName");
//             check loi
            if (name == null || name.trim().isEmpty()) {
                checkError = "Category name cannot be empty!";
            }

            CategoryDTO category = new CategoryDTO(0, name);
            if (!cdao.create(category)) {
                checkError = "Cannot add category!";
            }
            request.setAttribute("categories", category);
        }
        if (checkError.isEmpty()) {
            message = "Add category successfully";
            return handleCategoryListing(request, response);
        }
        // gửi data
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        return "categoryForm.jsp";
    }

    private String handleCategoryEditing(HttpServletRequest request, HttpServletResponse response) {
        if (AuthUtils.isAdmin(request)) {
            int cateID = Integer.parseInt(request.getParameter("categoryID"));
            String keyWord = request.getParameter("strKeyword");
            CategoryDTO category = cdao.getCategoryById(cateID);
            if (category != null) {
                request.setAttribute("category", category);
                request.setAttribute("keyword", keyWord);
                request.setAttribute("isEdit", true);
                return "categoryForm.jsp";
            }
            request.setAttribute("checkError", "Category not found!");
        }
        return handleCategoryListing(request, response);
    }

    private String handleCategoryUpdating(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";
        String keyWord = request.getParameter("strKeyword");
        if (AuthUtils.isAdmin(request)) {
            String cId = request.getParameter("categoryID");
            String name = request.getParameter("categoryName");
//            ép kiễu/
            int cateID = 0;
            try {
                cateID = Integer.parseInt(cId);
            } catch (Exception e) {
            }
//             check loi
            if (name == null || name.trim().isEmpty()) {
                checkError = "Category name cannot be empty!";
            }

            if (checkError.isEmpty()) {
                CategoryDTO category = new CategoryDTO(cateID, name);
                if (cdao.update(category)) {
                    message = "Add category successfully";
                    return handleCategoryListing(request, response);
                } else {
                    checkError = "Cannot add category!";
                }

            }
            CategoryDTO category = new CategoryDTO(cateID, name);
            request.setAttribute("category", category);
            request.setAttribute("isEdit", true);
        }

        // gửi data
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        request.setAttribute("keyword", keyWord);
        return "categoryForm.jsp";
    }

    private String handleCategoryDeleting(HttpServletRequest request, HttpServletResponse response) {
        if (AuthUtils.isAdmin(request)) {
            String cateID = request.getParameter("categoryID");
            int cate_value = 0;
            try {
                cate_value = Integer.parseInt(cateID);
            } catch (Exception e) {
            }
//           xóa
            cdao.delete(cate_value);

        }
        return handleCategoryListing(request, response);
    }

}
