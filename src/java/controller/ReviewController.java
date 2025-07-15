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
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.BookDAO;
import model.BookDTO;
import model.ReviewDAO;
import model.ReviewDTO;
import model.UserDTO;
import utils.AuthUtils;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ReviewController", urlPatterns = {"/ReviewController"})
public class ReviewController extends HttpServlet {

    ReviewDAO rdao = new ReviewDAO();
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
        String url = "review.jsp";
        //                System.out.println("1");
        try {
            String action = request.getParameter("action");
//      Xữ lí action của user
            if (action.equals("listReview")) {
                url = handleReviewListing(request, response);
            } else if (action.equals("addReview")) {
                url = handleReviewAdding(request, response);
            } else if (action.equals("deleteReview")) {
                url = handleReviewDeleting(request, response);
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

    private String handleReviewListing(HttpServletRequest request, HttpServletResponse response) {
        String bId = request.getParameter("bookID");
        int bookID = 0;
        try {
            bookID = Integer.parseInt(bId);
        } catch (Exception e) {
        }
        List<ReviewDTO> reviews = rdao.getReviewByBookId(bookID);
        BookDTO book = bdao.getBookById(bookID);
        request.setAttribute("reviews", reviews);
        request.setAttribute("book", book);
        return "review.jsp";
    }

    private String handleReviewAdding(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";
        String userID = null;
        String bookID = request.getParameter("bookID");
        String reviewID = request.getParameter("reviewID");
        String rating = request.getParameter("rating");
//        String userID = request.getParameter("userID");
        String comment = request.getParameter("comment");
        int review_value = 0;
        int book_value = 0;
        int rate_value = 0;
        try {
            review_value = Integer.parseInt(reviewID);
            book_value = Integer.parseInt(bookID);
            rate_value = Integer.parseInt(rating);

        } catch (Exception e) {
        }
        try {
            HttpSession session = request.getSession(false); // false: không tạo mới session nếu chưa có
            if (session != null) {
                Object objUser = session.getAttribute("userID"); // session nên lưu userID là String
                if (objUser != null) {
                    userID = objUser.toString();
                }
            }
        } catch (Exception e) {
            // Trường hợp bất ngờ, bỏ qua, userID sẽ là null
        }
        if (!AuthUtils.isLoggedIn(request)) {
            checkError = "You must log in to rate!";
        } else if (rate_value < 1 || rate_value > 5) {
            checkError = "Rating should be from 1-5!";
        } else if (comment == null || comment.trim().isEmpty()) {
            checkError = "Comment cannot be empty!";
        }

        if (checkError.isEmpty()) {
            ReviewDTO review = new ReviewDTO(0, book_value, bookID, rate_value, comment, null);
            if (rdao.create(review)) {
                message = "Evaluate success!";

            } else {
                checkError = "Cannot add review!";
            }
        }
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        // load lại list review cho sách này
        request.setAttribute("bookID", bookID);
        return handleReviewListing(request, response);
    }
    
    private String handleReviewDeleting(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String bookID = request.getParameter("bookID");
        String reviewID = request.getParameter("reviewID");
        int review_value = 0;
        int book_value = 0;
        try {
            review_value = Integer.parseInt(reviewID);
            book_value = Integer.parseInt(bookID);
        } catch (Exception e) {
        }
        if (AuthUtils.isAdmin(request) || AuthUtils.isUser(request)) {

            if (!rdao.delete(review_value)) {
                checkError = "Cannot delete review!";
            }

        } else {
            checkError = "You do not have the right to delete this review!";
        }
        request.setAttribute("checkError", checkError);
        request.setAttribute("book_value", book_value); // truyền lại bookID để list lại đúng sách
        return handleReviewListing(request, response);
    }
}
