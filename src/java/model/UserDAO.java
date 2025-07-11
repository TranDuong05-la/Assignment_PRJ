
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;
import utils.PasswordUtils;

/**
 *
 * @author Admin
 */
public class UserDAO {

    public UserDAO() {
        
    }
    
    public boolean login(String userID,String password){
        try{
            UserDTO user = getUserById(userID);
            password = PasswordUtils.encryptSHA256(password);
            if(user.getPassword().equals(password)){
                if(user.isStatus()){
                    return true;
                }
            }
        } catch (Exception e) {
            return false;
        }
        return false;
    }
    
    public UserDTO getUserById(String userID){
        String sql = "SELECT * FROM tblUsers WHERE userID=?";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement pr = conn.prepareStatement(sql);
            pr.setString(1, userID);
            ResultSet rs = pr.executeQuery();
            
            while(rs.next()){
                String userId = rs.getString("userID");
                String fullName = rs.getString("fullName");
                String password = rs.getString("password");
                String roleID = rs.getString("roleID");
                boolean status = rs.getBoolean("status");
                
                UserDTO userDTO = new UserDTO(userId, fullName, password, roleID, status);
                return userDTO;
            }   
        } catch (Exception e) {
            return null;
        }
        return null;
        
    }
     public List<UserDTO> getAllUsers() {
        List<UserDTO> userList = new ArrayList<>();
        String sql = "SELECT userID, fullName, password, roleID, status FROM tblUsers ORDER BY userID";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUserID(rs.getString("userID"));
                user.setFullName(rs.getString("fullName"));
                user.setPassword(rs.getString("password"));
                user.setRoleID(rs.getString("roleID"));
                user.setStatus(rs.getBoolean("status"));
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }
     
     public boolean updatePassword(String userID, String newPassword) {
        String sql = "UPDATE tblUsers SET password = ? WHERE userID = ?";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, userID);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
     
     public boolean isUserIDExists(String userID) {
        String sql = "SELECT COUNT(*) FROM tblUsers WHERE userID = ?";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
     
     public boolean signup(UserDTO user) {
    String sql = "INSERT INTO tblUsers(userID, fullName, password, roleID, status) VALUES (?, ?, ?, ?, 1)";
    try (Connection conn = DbUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user.getUserID());
        ps.setString(2, user.getFullName());
        ps.setString(3, PasswordUtils.encryptSHA256(user.getPassword()));
        ps.setString(4, user.getRoleID());
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

     
     
}


