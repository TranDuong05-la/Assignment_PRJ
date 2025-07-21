package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class CartItemDAO {
    public CartItemDAO() {}

    private static final String GETALL = "SELECT cartID, bookTitle, quantity, unitPrice FROM CartItem";
    
    public boolean updateCartItemQuantity(int cartItemID, int quantity) {
        String sql = "UPDATE CartItem SET quantity = ? WHERE cartItemID = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, quantity);
            pr.setInt(2, cartItemID);
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCartItem(int cartItemID) {
        String sql = "DELETE FROM CartItem WHERE cartItemID = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, cartItemID);
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insertCartItem(CartItemDTO item) {
        String sql = "INSERT INTO CartItem (cartID, bookID, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, item.getCartID());
            pr.setInt(2, item.getBookID());
            pr.setInt(3, item.getQuantity());
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CartItemDTO> getCartItemsByCartId(int cartId) {
        List<CartItemDTO> list = new ArrayList<>();
        String sql = "SELECT ci.cartItemID, ci.cartID, ci.bookID, ci.quantity, " +
                     "b.BookTitle, b.Price, b.Image, b.Author, b.Publisher, b.Description, b.PublishYear, b.CategoryID " +
                     "FROM CartItem ci " +
                     "JOIN Book b ON ci.bookID = b.BookID " +
                     "WHERE ci.cartID = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, cartId);
            ResultSet rs = pr.executeQuery();
            while (rs.next()) {
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
                    rs.getInt("cartID"),
                    rs.getInt("bookID"),
                    rs.getInt("quantity"),
                    book
                );
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteCartItemsByCartId(int cartId) {
        String sql = "DELETE FROM CartItem WHERE cartID=?"; // Corrected column name
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, cartId);
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public CartItemDTO getCartItemById(int cartItemID) {
        String sql = "SELECT ci.cartItemID, ci.cartID, ci.bookID, ci.quantity, " +
                     "b.BookTitle, b.Price, b.Image, b.Author, b.Publisher, b.Description, b.PublishYear, b.CategoryID " +
                     "FROM CartItem ci " +
                     "JOIN Book b ON ci.bookID = b.BookID " +
                     "WHERE ci.cartItemID = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, cartItemID);
            ResultSet rs = pr.executeQuery();
            if (rs.next()) {
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
                return new CartItemDTO(
                    rs.getInt("cartItemID"),
                    rs.getInt("cartID"),
                    rs.getInt("bookID"),
                    rs.getInt("quantity"),
                    book
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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