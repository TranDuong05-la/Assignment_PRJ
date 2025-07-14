package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import utils.DbUtils;
import utils.PasswordUtils;

/**
 *
 * @author Admin
 */
public class UserDAO {

    public UserDAO() {

    }

    public boolean login(String userID, String password) {
        try {
            UserDTO user = getUserById(userID);
            password = PasswordUtils.encryptSHA256(password);
            if (user.getPassword().equals(password)) {
                if (user.isStatus()) {
                    return true;
                }
            }
        } catch (Exception e) {
            return false;
        }
        return false;
    }

    public UserDTO getUserById(String userID) {
        String sql = "SELECT * FROM tblUsers WHERE userID = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUserID(rs.getString("userID"));
                user.setFullName(rs.getString("fullName"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setRoleID(rs.getString("roleID"));
                user.setStatus(rs.getBoolean("status"));
                user.setResetToken(rs.getString("resetToken"));
                user.setTokenExpiry(rs.getTimestamp("tokenExpiry"));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<UserDTO> getAllUsers() {
        List<UserDTO> userList = new ArrayList<>();
        String sql = "SELECT * FROM tblUsers ORDER BY userID";

        try {
            Connection conn = DbUtils.getConnection();  
            PreparedStatement ps = conn.prepareStatement(sql);  
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUserID(rs.getString("userID"));
                user.setFullName(rs.getString("fullName"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setRoleID(rs.getString("roleID"));
                user.setStatus(rs.getBoolean("status"));
                user.setResetToken(rs.getString("resetToken"));
                user.setTokenExpiry(rs.getTimestamp("tokenExpiry"));
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

            ps.setString(1, PasswordUtils.encryptSHA256(newPassword));
            ps.setString(2, userID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
    
    public boolean isEmailExists(String Email) {
        String sql = "SELECT COUNT(*) FROM tblUsers WHERE email = ?";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, Email);
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
    String sql = "INSERT INTO tblUsers(userID, fullName, password, email, roleID, status, resetToken, tokenExpiry) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    try {
         Connection conn = DbUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);

        ps.setString(1, user.getUserID());
        ps.setString(2, user.getFullName());
        ps.setString(3, PasswordUtils.encryptSHA256(user.getPassword()));
        ps.setString(4, user.getEmail());
        ps.setString(5, user.getRoleID());
        ps.setBoolean(6, user.isStatus());
        ps.setString(7, null);
        ps.setTimestamp(8, null);

        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}


    public String generateResetToken(String email) {
        String sql = "UPDATE tblUsers SET resetToken = ?, tokenExpiry = ? WHERE email = ?";
        String token = UUID.randomUUID().toString();
        Timestamp expiry = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000);

        try {
            Connection conn = DbUtils.getConnection();  
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, token);
            ps.setTimestamp(2, expiry);
            ps.setString(3, email);

            if (ps.executeUpdate() > 0) {
                return token;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean resetPassword(String token, String newPassword) {
        String getUserSql = "SELECT userID FROM tblUsers WHERE resetToken = ? AND tokenExpiry > GETDATE()";
        String updateSql = "UPDATE tblUsers SET password = ?, resetToken = NULL, tokenExpiry = NULL WHERE userID = ?";

        try {
            Connection conn = DbUtils.getConnection();  
            PreparedStatement ps = conn.prepareStatement(getUserSql);

            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String userID = rs.getString("userID");
                newPassword = PasswordUtils.encryptSHA256(newPassword);
                try ( PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setString(1, newPassword);
                    updateStmt.setString(2, userID);
                    return updateStmt.executeUpdate() > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
