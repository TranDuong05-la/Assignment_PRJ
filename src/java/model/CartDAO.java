package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DbUtils;

public class CartDAO {
    public CartDAO() {}

    public boolean insertCart(CartDTO cart) {
        String sql = "INSERT INTO Cart (userId, createdTime) VALUES (?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, cart.getUserId());
            pr.setString(2, cart.getCreatedTime());
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public CartDTO getCartByUserId(int userId) {
        String sql = "SELECT * FROM Cart WHERE userId=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, userId);
            ResultSet rs = pr.executeQuery();
            if (rs.next()) {
                return new CartDTO(
                    rs.getInt("cartId"),
                    rs.getInt("userId"),
                    rs.getString("createdTime")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteCart(int cartId) {
        String sql = "DELETE FROM Cart WHERE cartId=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, cartId);
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
} 