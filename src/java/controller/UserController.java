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
import java.sql.Timestamp;
import model.UserDAO;
import model.UserDTO;
import utils.MailUtils;
import utils.PasswordUtils;
import model.CartDAO;
import model.CartDTO;


/**
 *
 * @author Admin
 */
@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    private static final String WELCOME_PAGE = "home.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String RESET_PAGE = "reset.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = LOGIN_PAGE;
        try {
            String action = request.getParameter("action");
            if (action.equals("login")) {
                url = handleLogin(request, response);
            } else if (action.equals("logout")) {
                url = handleLogout(request, response);
            } else if (action.equals("signUp")) {
                url = handleSignUp(request, response);
            } else if (action.equals("reset")) {
                url = handleReset(request, response);
            } else {
                request.setAttribute("message", "Invalid action:" + action + "!");
                url = LOGIN_PAGE;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error occurred!");
        } finally {
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

    private String handleLogin(HttpServletRequest request, HttpServletResponse response) {
        String url = "";
        HttpSession session = request.getSession();
        String strUsername = request.getParameter("strUsername");
        String strPassword = request.getParameter("strPassword");
        UserDAO userDAO = new UserDAO();
        if (userDAO.login(strUsername, strPassword)) {
            UserDTO user = userDAO.getUserById(strUsername);
            url = WELCOME_PAGE;
            session.setAttribute("user", user);
            // Sau khi xác thực thành công và set user vào session:
            CartDAO cartDAO = new CartDAO();
            CartDTO cart = cartDAO.getCartByUserId(user.getUserID());
            session.setAttribute("cart", cart);
            int cartCount = (cart != null && cart.getItems() != null) ? cart.getItems().size() : 0;
            session.setAttribute("cartCount", cartCount);
        } else {
            url = LOGIN_PAGE;
            request.setAttribute("message", "Username or Password incorrect!");
        }
        return url;
    }

    private String handleLogout(HttpServletRequest request, HttpServletResponse response) {
        String url = WELCOME_PAGE;
        try {
            HttpSession session = request.getSession();
            if (session != null) {
                Object objUser = session.getAttribute("user");
                UserDTO user = (objUser != null) ? (UserDTO) objUser : null;
                if (user != null) {
                    session.invalidate();
                }
            }
        } catch (Exception e) {
        }
        return url;
    }

private String handleSignUp(HttpServletRequest request, HttpServletResponse response) {
    String url = "signUp.jsp";
    try {
        String userID = request.getParameter("userID");
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        if (!password.equals(repassword)) {
            request.setAttribute("message", "Passwords do not match!");
            return url;
        }

        UserDAO userDAO = new UserDAO();
        if(userDAO.isEmailExists(email)){
            request.setAttribute("message", "Email already exists! Please try again.");
            return url;
        }
        if (userDAO.isUserIDExists(userID)) {
            request.setAttribute("message", "Username already exists! Please try again.");
        } else {
            UserDTO newUser = new UserDTO(userID,fullName,password,email,"user",true,null,null);
            boolean success = userDAO.signup(newUser);

            if (success) {
                request.setAttribute("successMessage", "Signup successful! Please login.");
                url = LOGIN_PAGE;
            } else {
                request.setAttribute("message", "Signup failed. Please try again.");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("message", "System error during signup.");
    }
    return url;
}



private String handleReset(HttpServletRequest request, HttpServletResponse response) {
    String token = request.getParameter("token");
    UserDAO dao = new UserDAO();
    
    if (token == null) {
        String email = request.getParameter("email");
        String generatedToken = dao.generateResetToken(email);
        
        if (generatedToken != null) {
            String resetLink = "http://localhost:8080/Assignment_PRJ/reset.jsp?token=" + generatedToken;
            MailUtils.sendResetEmail(email, resetLink);
            request.setAttribute("successMessage", "A reset link has been sent to your email: " + email);
        } else {
            request.setAttribute("message", "Email not found.");
        }
    } else {
        String newPassword = request.getParameter("newPassword");
        boolean success = dao.resetPassword(token, newPassword);

        if (success) {
            request.setAttribute("successMessage", "Password reset successful. Please login.");
        } else {
            request.setAttribute("message", "Invalid or expired token.");
        }
    }

    return RESET_PAGE;
}

}
