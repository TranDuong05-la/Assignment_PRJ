package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;
import model.CartItemDAO;
import model.CartItemDTO;

public class CartDAO {
    public CartDAO() {}

    public boolean insertCart(CartDTO cart) {
        String sql = "INSERT INTO Cart (userID) VALUES (?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setString(1, cart.getUserId());
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public CartDTO getCartByUserId(String userId) {
        CartDTO cart = null;
        List<CartItemDTO> items = new ArrayList<>();
        String sql = "SELECT c.cartID, ci.cartItemID, ci.quantity, ci.bookID, " +
                     "b.BookTitle, b.Price, b.Image, b.Author, b.Publisher, b.Description, b.PublishYear, b.CategoryID " +
                     "FROM Cart c LEFT JOIN CartItem ci ON c.cartID = ci.cartID " +
                     "LEFT JOIN Book b ON ci.bookID = b.BookID " +
                     "WHERE c.userID = ?";
        
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            
            pr.setString(1, userId);
            ResultSet rs = pr.executeQuery();
            
            Integer cartId = null;
            
            while (rs.next()) {
                if (cartId == null) {
                    cartId = rs.getInt("cartID");
                }
                
                if (rs.getObject("cartItemID") != null) {
                    BookDTO book = new BookDTO(
                        rs.getInt("bookID"),
                        rs.getInt("CategoryID"),
                        rs.getString("BookTitle"),
                        rs.getString("Author"),
                        rs.getString("Publisher"),
                        rs.getDouble("Price"),
                        rs.getString("Image"),
                        rs.getString("Description"),
                        rs.getInt("PublishYear")
                    );
                    CartItemDTO item = new CartItemDTO(
                        rs.getInt("cartItemID"),
                        cartId,
                        rs.getInt("bookID"),
                        rs.getInt("quantity"),
                        book
                    );
                    items.add(item);
                }
            }
            
            if (cartId != null) {
                cart = new CartDTO(cartId, userId, items);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return cart;
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
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 