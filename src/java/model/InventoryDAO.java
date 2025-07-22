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
 * @author ASUS
 */
public class InventoryDAO {

    private static final String GET_QUANTITY_BY_BOOKID = "SELECT Quantity FROM Inventory WHERE BookID = ?";
    private static final String GET_All_INVENTORY = "SELECT * FROM Inventory";
    private static final String GET_INVENTORY_BY_BOOk_ID = "SELECT * FROM Inventory WHERE InventoryID=?";
    private static final String CREATE_INVENTORY = "INSERT INTO Inventory(BookID, Quantity, LastUpdate) VALUES (?, ?, GETDATE())";
    private static final String UPDATE_INVENTORY = "UPDATE Inventory SET BookID=?, Quantity=?, LastUpdate=GETDATE() WHERE InventoryID=?";
    private static final String DELETE_INVENTORY = "DELETE FROM Inventory WHERE BookID = ?";

    public List<InventoryDTO> getAll() {
        List<InventoryDTO> inventories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_All_INVENTORY);
            rs = ps.executeQuery();

            while (rs.next()) {
                InventoryDTO inventory = new InventoryDTO();
                inventory.setInventoryID(rs.getInt("InventoryID"));
                inventory.setBookID(rs.getInt("BookID"));
                inventory.setQuantity(rs.getInt("Quantity"));
                inventory.setLastUpdate(rs.getTimestamp("LastUpdate"));

                inventories.add(inventory);
            }

        } catch (Exception e) {
            System.err.println("Error in getAll" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return inventories;
    }

    public InventoryDTO getInventoryById(int inventoryID) {
        InventoryDTO inventory = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_INVENTORY_BY_BOOk_ID);
            ps.setInt(1, inventoryID);
            rs = ps.executeQuery();

            if (rs.next()) {
                inventory = new InventoryDTO();
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

    public boolean create(InventoryDTO inventory) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(CREATE_INVENTORY);
            ps.setInt(1, inventory.getBookID());
            ps.setInt(2, inventory.getQuantity());
            

            int rowAffected = ps.executeUpdate();
            success = (rowAffected > 0);
        } catch (Exception e) {
            System.err.println("Error in create(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }

    public boolean update(InventoryDTO inventory) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(UPDATE_INVENTORY);

            ps.setInt(1, inventory.getBookID());
            ps.setInt(2, inventory.getQuantity());
            ps.setInt(3, inventory.getInventoryID());

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

    public boolean delete(int bookID) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(DELETE_INVENTORY);
            ps.setInt(1, bookID);

            int rowsAffected = ps.executeUpdate();// số lượng dòng thay đổi 
            success = (rowsAffected > 0);// ít nhất có 1 dòng bị thay đổi: ko thêm đc có những lỗi như trùng Id hoặc thiếu data

        } catch (Exception e) {
            System.err.println("Error in delete(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }

        return success;

    }

//     hàng tồn(còn hàng hay hết hàng)
    public int getQuantityByBookId(int bookID) {
        int quantity = 0;
        try (
                 Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(GET_QUANTITY_BY_BOOKID)) {
            ps.setInt(1, bookID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    quantity = rs.getInt("Quantity");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return quantity;
    }
}
