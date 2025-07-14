package model;

import java.sql.Timestamp;

public class UserDTO {
    private String userID;
    private String fullName;
    private String password;
    private String email;
    private String roleID;
    private boolean status;
    private String resetToken;
    private Timestamp tokenExpiry;

    public UserDTO() {
    }

    public UserDTO(String userID, String fullName, String password, String email, String roleID, boolean status, String resetToken, Timestamp tokenExpiry) {
        this.userID = userID;
        this.fullName = fullName;
        this.password = password;
        this.email = email;
        this.roleID = roleID;
        this.status = status;
        this.resetToken = resetToken;
        this.tokenExpiry = tokenExpiry;
    }


    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRoleID() {
        return roleID;
    }

    public void setRoleID(String roleID) {
        this.roleID = roleID;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public Timestamp getTokenExpiry() {
        return tokenExpiry;
    }

    public void setTokenExpiry(Timestamp tokenExpiry) {
        this.tokenExpiry = tokenExpiry;
    }
}
