package utils;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.UserDTO;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author ASUS
 */
//ktr user có login hay chưa, có quyền hạng nào đó hay lko?
public class AuthUtils {
//    lấy ra user hiện tại đang login
    public static UserDTO getCurrentUser(HttpServletRequest request) {
//        ktr xem có user nào đang login hay ko?
        HttpSession session = request.getSession();
        if (session != null) {
            return (UserDTO) session.getAttribute("user");
        }
        return null;
    }
// ktr xem nó có login hay chưa
    public static boolean isLoggedIn(HttpServletRequest request) {
        return AuthUtils.getCurrentUser(request) != null;// biến null thì user chưa login
    }
//
    public static boolean hasRole(HttpServletRequest request, String role) {
//        lấy user đang đăng nhập
        UserDTO user = getCurrentUser(request);
        if (user != null) {
            String userRole = user.getRoleID();// đảm bảo rằng hàm này luôn tồn tại
            return userRole.equals(role);
        }
        return false;
    }
// ktr phân quyền
    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, "AD");
    }

    public static boolean isManager(HttpServletRequest request) {
        return hasRole(request, "MA");
    }

    public static boolean isUser(HttpServletRequest request) {
        return hasRole(request, "MB");
    }
//    thêm thôpng báo và url
    public static String getLoginURL(){
        return "MainController?action=login";
    }
    
    public static String getAccessDeniedMessage(String action){
        return "You don't have permission to "+action+". Please contact administrator.";
    }
}
