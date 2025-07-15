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
import model.InventoryDAO;
import utils.AuthUtils;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    BookDAO bdao = new BookDAO();
    CategoryDAO cdao = new CategoryDAO();
    InventoryDAO idao = new InventoryDAO();

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
        String url = "home.jsp";
        //                System.out.println("1");
        try {
            String action = request.getParameter("action");
//      Xữ lí action của user
            if (action.equals("listBook")) {
                url = handleBookListing(request, response);
            } else if (action.equals("bookDetail")) {
                url = handleBookDetail(request, response);
            } else if (action.equals("addBook")) {
                url = handleBookAdding(request, response);
            } else if (action.equals("editBook")) {
                url = handleBookEditing(request, response);
            } else if (action.equals("updateBook")) {
                url = handleBookUpdating(request, response);
            } else if (action.equals("deleteBook")) {
                url = handleBookDeleting(request, response);
            } else if (action.equals("searchBook")) {
                url = handleBookSearching(request, response);
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

    private String handleBookListing(HttpServletRequest request, HttpServletResponse response) {
        String list = request.getParameter("bookID");
        String cate = request.getParameter("categoryID");

        List<BookDTO> books = bdao.getAll();
        List<CategoryDTO> categories = cdao.getAll();
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        return "home.jsp";
    }

    private String handleBookDetail(HttpServletRequest request, HttpServletResponse response) {
        String bookID = request.getParameter("bookID");

        int book_value = 0;
        try {
            book_value = Integer.parseInt(bookID);
        } catch (Exception e) {
        }
        BookDTO book = bdao.getBookById(book_value);
        request.setAttribute("book", book);
//        lấy slg tồn kho
        int quantity = idao.getQuantityByBookId(book_value);
        String status = quantity > 0 ? "In stock" : "sold out";
        request.setAttribute("status", status);
        request.setAttribute("quantity", quantity);
        return "bookDetail.jsp";
    }

    private String handleBookAdding(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";

        if (AuthUtils.isAdmin(request)) {
//            String bId = request.getParameter("bookID");
            String cateId = request.getParameter("categoryID");
            String bTitle = request.getParameter("bookTitle");
            String auth = request.getParameter("author");
            String publisherStr = request.getParameter("publisher");
            String price = request.getParameter("price");
            String image = request.getParameter("image");
            String description = request.getParameter("description");
            String publishYear = request.getParameter("publishYear");
//          ép kiểu

            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(cateId);
            } catch (Exception e) {
            }

            double price_value = 0;
            try {
                price_value = Double.parseDouble(price);
            } catch (Exception e) {
            }

            int publishYear_value = 0;
            try {
                publishYear_value = Integer.parseInt(publishYear);
            } catch (Exception e) {
            }

//           ktr lỗi
            if (bTitle == null || bTitle.trim().isEmpty()) {
                checkError = "Title cannot be empty!";
            }
//            ktr lỗi
            if (price_value < 0) {
                checkError += "<br/>Price must be greater than zero!";
            }

            BookDTO book = new BookDTO(0, categoryId, bTitle, auth, publisherStr, price_value, image, description, publishYear_value);

            if (!bdao.create(book)) {
                checkError += "<br/> Can not add product!";
            }

            request.setAttribute("book", book);
        }
        if (checkError.isEmpty()) {
            message = "Add product successfully";
        }

        // gửi data
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        return "productForm.jsp";

    }

    private String handleBookEditing(HttpServletRequest request, HttpServletResponse response) {
        if (AuthUtils.isAdmin(request)) {
            String bookID = request.getParameter("bookID");
            String keyWord = request.getParameter("strKeyword");
            int book_value = 0;
            try {
                book_value = Integer.parseInt(bookID);
            } catch (Exception e) {
            }
//            lấy sp
            BookDTO book = bdao.getBookById(book_value);
            List<CategoryDTO> categories = cdao.getAll();
            if (book != null) {
                request.setAttribute("book", book);
                request.setAttribute("categories", categories);
                request.setAttribute("isEdit", true);
                return "bookForm.jsp";
            } else {
                request.setAttribute("checkError", "Book not found!");
            }
        }
        return handleBookSearching(request, response);
    }

    private String handleBookUpdating(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";
        String keyWord = request.getParameter("strKeyword");

        if (AuthUtils.isAdmin(request)) {
            String bId = request.getParameter("bookID");
            String cateId = request.getParameter("categoryID");
            String bTitle = request.getParameter("bookTitle");
            String auth = request.getParameter("author");
            String publisherStr = request.getParameter("publisher");
            String price = request.getParameter("price");
            String image = request.getParameter("image");
            String description = request.getParameter("description");
            String publishYear = request.getParameter("publishYear");
//          ép kiểu
            int bookID = 0;
            try {
                bookID = Integer.parseInt(bId);
            } catch (Exception e) {
            }
            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(cateId);
            } catch (Exception e) {
            }

            double price_value = 0;
            try {
                price_value = Double.parseDouble(price);
            } catch (Exception e) {
            }

            int publishYear_value = 0;
            try {
                publishYear_value = Integer.parseInt(publishYear);
            } catch (Exception e) {
            }

//           ktr lỗi
            if (bTitle == null || bTitle.trim().isEmpty()) {
                checkError = "Title cannot be empty!";
            }
            if (price_value < 0) {
                checkError += "<br/>Price must be greater than zero!";
            }

            if (checkError.isEmpty()) {
                BookDTO book = new BookDTO(bookID, categoryId, bTitle, auth, publishYear, price_value, image, description, publishYear_value);
                if (bdao.update(book)) {
                    message = "Update book successfully!";
//                        request.setAttribute("message", message);
                    return handleBookSearching(request, response);
                } else {
                    checkError = "Cannot update book!";
                }
            }
            BookDTO book = new BookDTO(bookID, categoryId, bTitle, auth, publishYear, price_value, image, description, publishYear_value);
            request.setAttribute("book", book);
            request.setAttribute("isEdit", true);
        }

        // gửi data
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        request.setAttribute("keyword", keyWord);
        return "productForm.jsp";
    }

    private String handleBookDeleting(HttpServletRequest request, HttpServletResponse response) {
        if (AuthUtils.isAdmin(request)) {
            String bookID = request.getParameter("bookID");
            int book_value = 0;
            try {
                book_value = Integer.parseInt(bookID);
            } catch (Exception e) {
            }
//           xóa
            bdao.delete(book_value);

        }
        return handleBookSearching(request, response);
    }

    private String handleBookSearching(HttpServletRequest request, HttpServletResponse response) {
        String keyWord = request.getParameter("strKeyword");
        List<BookDTO> books = bdao.getBooksByName(keyWord);
        List<CategoryDTO> categories = cdao.getAll();
        request.setAttribute("books", books);
        request.setAttribute("keyWord", keyWord);
        request.setAttribute("categories", categories);
        return "home.jsp";
    }

}
