package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class CartItemDAO {
    public CartItemDAO() {}

    public boolean insertCartItem(CartItemDTO item) {
        String sql = "INSERT INTO CartItem (cartId, productId, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, item.getCartId());
            pr.setInt(2, item.getProductId());
            pr.setInt(3, item.getQuantity());
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CartItemDTO> getCartItemsByCartId(int cartId) {
        List<CartItemDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM CartItem WHERE cartId=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, cartId);
            ResultSet rs = pr.executeQuery();
            while (rs.next()) {
                list.add(new CartItemDTO(
                    rs.getInt("cartId"),
                    rs.getInt("productId"),
                    rs.getInt("quantity")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateCartItemQuantity(int cartId, int productId, int quantity) {
        String sql = "UPDATE CartItem SET quantity=? WHERE cartId=? AND productId=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, quantity);
            pr.setInt(2, cartId);
            pr.setInt(3, productId);
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCartItemsByCartId(int cartId) {
        String sql = "DELETE FROM CartItem WHERE cartId=?";
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