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
import model.CategoryDTO;
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
        String url = "bookdetail.jsp";
        //                System.out.println("1");
        try {
            String action = request.getParameter("action");
//      Xữ lí action của user
            if (action.equals("listReview")) {
                url = handleReviewListing(request, response);
            } else if (action.equals("addReview")) {
                url = handleReviewAdding(request, response);
            } else if (action.equals("editReview")) {
                url = handleReviewEditing(request, response);
            } else if (action.equals("updateReview")) {
                url = handleReviewUpdating(request, response);
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
        return "bookDetail.jsp";
    }

    private String handleReviewAdding(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";
        String bookID = request.getParameter("bookID");
        String rating = request.getParameter("rating");
        String comment = request.getParameter("comment");

        // Lấy user từ session
        UserDTO user = (UserDTO) request.getSession().getAttribute("user");
        String userID = (user != null) ? user.getUserID() : null;

        int book_value = 0, rate_value = 0;
        try {
            book_value = Integer.parseInt(bookID);
            rate_value = Integer.parseInt(rating);
        } catch (Exception e) {
        }

        System.out.println("bookID khi save review: " + bookID);
        BookDTO book = bdao.getBookById(book_value);
        System.out.println("book trả về: " + (book == null ? "null" : book.getBookTitle()));

        // Validate
        if (userID == null) {
            checkError = "You must log in to rate!";
        } else if (rate_value < 1 || rate_value > 5) {
            checkError = "Rating should be from 1-5!";
        } else if (comment == null || comment.trim().isEmpty()) {
            checkError = "Comment cannot be empty!";
        }

        if (checkError.isEmpty()) {
            ReviewDTO review = new ReviewDTO(0, book_value, userID, rate_value, comment, null);
            if (rdao.create(review)) {
                message = "Review submitted successfully!";
            } else {
                checkError = "Cannot add review!";
            }
        }

//        BookDTO book = bdao.getBookById(book_value);
        List<ReviewDTO> reviews = rdao.getReviewByBookId(book_value);
        request.setAttribute("book", book);
        request.setAttribute("reviews", reviews);
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);

        return "bookDetail.jsp";
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

    private String handleReviewEditing(HttpServletRequest request, HttpServletResponse response) {
        if (AuthUtils.isAdmin(request)) {
            String reviewID = request.getParameter("reviewID");
            int reviewIdValue = 0;
            try {
                reviewIdValue = Integer.parseInt(reviewID);
            } catch (Exception e) {
            }

            // Lấy review và book tương ứng
            ReviewDTO review = rdao.getReviewById(reviewIdValue);
            if (review != null) {
                BookDTO book = bdao.getBookById(review.getBookID());
                request.setAttribute("review", review);
                request.setAttribute("book", book);
                return "reviewForm.jsp";
            } else {
                request.setAttribute("checkError", "Review not found!");
            }
        }
        // Nếu không phải admin hoặc lỗi thì quay về list review của sách
        return handleReviewListing(request, response);
    }

    private String handleReviewUpdating(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";
        String bookID = request.getParameter("bookID");
        String rating = request.getParameter("rating");
        String comment = request.getParameter("comment");

        // Lấy user từ session
        UserDTO user = (UserDTO) request.getSession().getAttribute("user");
        String userID = (user != null) ? user.getUserID() : null;

        int book_value = 0, rate_value = 0;
        try {
            book_value = Integer.parseInt(bookID);
            rate_value = Integer.parseInt(rating);
        } catch (Exception e) {
        }

        // Validate
        if (userID == null) {
            checkError = "You must log in to rate!";
        } else if (rate_value < 1 || rate_value > 5) {
            checkError = "Rating should be from 1-5!";
        } else if (comment == null || comment.trim().isEmpty()) {
            checkError = "Comment cannot be empty!";
        }

        if (checkError.isEmpty()) {
            ReviewDTO review = new ReviewDTO(0, book_value, userID, rate_value, comment, null);
            if (rdao.create(review)) {
                message = "Review submitted successfully!";
            } else {
                checkError = "Cannot add review!";
            }
        }

        BookDTO book = bdao.getBookById(book_value);
        List<ReviewDTO> reviews = rdao.getReviewByBookId(book_value);
        request.setAttribute("book", book);
        request.setAttribute("reviews", reviews);
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);

        return "bookDetail.jsp";
    }
}
