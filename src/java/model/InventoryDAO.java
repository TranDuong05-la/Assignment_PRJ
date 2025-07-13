/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DbUtils;

/**
 *
 * @author ASUS
 */
public class InventoryDAO {
    private static final String GET_INVENTORY_BY_BOOk_ID = "SELECT * FROM Inventory WHERE BookID=?";
    private static final String UPDATE_INVENTORY = "UPDATE Inventory SET Quantity=?, LastUpdate=NOW() WHERE BookID=?";
    
    public InventoryDTO getInventoryByBookId(int inventoryID){
        InventoryDTO inventory = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_INVENTORY_BY_BOOk_ID);
            ps.setInt(1, inventoryID);
            rs = ps.executeQuery();
            
            if(rs.next()){
                inventory= new InventoryDTO();
                inventory.setInventoryID(rs.getInt("InventoryID"));
                inventory.setBookID(rs.getInt("BookID"));
                inventory.setQuantity(rs.getInt("Quantity"));
                inventory.setLastUpdate(rs.getTimestamp("LastUpdate"));
            }
            
        } catch (Exception e) {
            System.err.println("Error in getInventoryByBookId" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return inventory;
    }
    
     private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error resources:" + e.getMessage());
            e.printStackTrace();
        } finally {
        }
    }
     
     public boolean update(InventoryDTO inventory){
         boolean success = false;
         Connection conn = null;
         PreparedStatement ps = null;
         try {
             conn = DbUtils.getConnection();
             ps = conn.prepareStatement(UPDATE_INVENTORY);
             
             ps.setInt(1, inventory.getQuantity());
             ps.setInt(2, inventory.getBookID());
             
             int rowAffected = ps.executeUpdate();
             success = (rowAffected > 0);
         } catch (Exception e) {
              System.err.println("Error in update(): " + e.getMessage());
            e.printStackTrace();
         } finally {
             closeResources(conn, ps, null);
         }
         return success;
     }
    
}
