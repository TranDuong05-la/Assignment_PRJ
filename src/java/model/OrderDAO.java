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
 * @author nguye
 */
public class OrderDAO {
    public OrderDAO() {
    }

    public boolean insertOrder(OrderDTO order) {
        String sql = "INSERT INTO tblOrders (userID, orderDate, totalAmount, status, shippingAddress, phone, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setString(1, order.getUserID());
            pr.setString(2, order.getOrderDate());
            pr.setDouble(3, order.getTotalAmount());
            pr.setString(4, order.getStatus());
            pr.setString(5, order.getShippingAddress());
            pr.setString(6, order.getPhone());
            pr.setString(7, order.getNote());
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public OrderDTO getOrderById(int orderId) {
        String sql = "SELECT * FROM tblOrders WHERE orderID=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, orderId);
            ResultSet rs = pr.executeQuery();
            if (rs.next()) {
                return new OrderDTO(
                    rs.getInt("orderID"),
                    rs.getString("userID"),
                    rs.getString("orderDate"),
                    rs.getDouble("totalAmount"),
                    rs.getString("status"),
                    rs.getString("shippingAddress"),
                    rs.getString("phone"),
                    rs.getString("note")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderDTO> getAllOrders() {
        List<OrderDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblOrders";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            ResultSet rs = pr.executeQuery();
            while (rs.next()) {
                list.add(new OrderDTO(
                    rs.getInt("orderID"),
                    rs.getString("userID"),
                    rs.getString("orderDate"),
                    rs.getDouble("totalAmount"),
                    rs.getString("status"),
                    rs.getString("shippingAddress"),
                    rs.getString("phone"),
                    rs.getString("note")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE tblOrders SET status=? WHERE orderID=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setString(1, status);
            pr.setInt(2, orderId);
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM tblOrders WHERE orderID=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, orderId);
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<OrderDTO> getOrdersByUserId(String userId) {
        List<OrderDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblOrders WHERE userID = ? ORDER BY orderID DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setString(1, userId);
            ResultSet rs = pr.executeQuery();
            while (rs.next()) {
                list.add(new OrderDTO(
                    rs.getInt("orderID"),
                    rs.getString("userID"),
                    rs.getString("orderDate"),
                    rs.getDouble("totalAmount"),
                    rs.getString("status"),
                    rs.getString("shippingAddress"),
                    rs.getString("phone"),
                    rs.getString("note")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Integer getLatestOrderIdByUser(String userId) {
        String sql = "SELECT TOP 1 orderID FROM tblOrders WHERE userID = ? ORDER BY orderID DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setString(1, userId);
            ResultSet rs = pr.executeQuery();
            if (rs.next()) {
                return rs.getInt("orderID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
