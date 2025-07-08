
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DbUtils;

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
}


