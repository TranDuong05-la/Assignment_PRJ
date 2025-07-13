/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author Admin
 */
public class AddressDAO {

    public List<AddressDTO> getAddressesByUser(String userID) {
        List<AddressDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblAddresses WHERE userID = ?";
        try{ 
            Connection conn = DbUtils.getConnection();  
            PreparedStatement ps = conn.prepareStatement(sql); 
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    AddressDTO addr = new AddressDTO(
                            rs.getInt("addressID"),
                            rs.getString("userID"),
                            rs.getString("recipientName"),
                            rs.getString("phone"),
                            rs.getString("addressDetail"),
                            rs.getString("district"),
                            rs.getString("city"),
                            rs.getBoolean("isDefault")
                    );
                    list.add(addr);
                }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertAddress(AddressDTO address) {
        String sql = "INSERT INTO tblAddresses(userID, recipientName, phone, addressDetail, district, city, isDefault) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try{
            Connection conn = DbUtils.getConnection();  
            PreparedStatement ps = conn.prepareStatement(sql); 
            ps.setString(1, address.getUserID());
            ps.setString(2, address.getRecipientName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getAddressDetail());
            ps.setString(5, address.getDistrict());
            ps.setString(6, address.getCity());
            ps.setBoolean(7, address.isDefault());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteAddress(int addressID) {
        String sql = "DELETE FROM tblAddresses WHERE addressID = ?";
        try{ 
            Connection conn = DbUtils.getConnection();  
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, addressID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAddress(AddressDTO address) {
        String sql = "UPDATE tblAddresses SET recipientName=?, phone=?, addressDetail=?, district=?, city=?, isDefault=? "
                + "WHERE addressID=?";
        try{
            Connection conn = DbUtils.getConnection();  
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, address.getRecipientName());
            ps.setString(2, address.getPhone());
            ps.setString(3, address.getAddressDetail());
            ps.setString(4, address.getDistrict());
            ps.setString(5, address.getCity());
            ps.setBoolean(6, address.isDefault());
            ps.setInt(7, address.getAddressID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public AddressDTO getAddressByID(int addressID) {
    String sql = "SELECT * FROM tblAddresses WHERE addressID = ?";
    try{
        Connection conn = DbUtils.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, addressID);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new AddressDTO(
                    rs.getInt("addressID"),
                    rs.getString("userID"),
                    rs.getString("recipientName"),
                    rs.getString("phone"),
                    rs.getString("addressDetail"),
                    rs.getString("district"),
                    rs.getString("city"),
                    rs.getBoolean("isDefault")
                );
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

public boolean unsetDefaultAddress(String userID) {
    String sql = "UPDATE tblAddresses SET isDefault = 0 WHERE userID = ?";
    try (Connection conn = DbUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, userID);
        int affected = ps.executeUpdate();
        return affected > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}


public boolean setDefaultAddress(int addressID) {
    String sql = "UPDATE tblAddresses SET isDefault = 1 WHERE addressID = ?";
    try (Connection conn = DbUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, addressID);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}


}
