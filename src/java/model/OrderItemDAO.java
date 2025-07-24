package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class OrderItemDAO {
    public OrderItemDAO() {
    }

    public boolean insertOrderItem(OrderItemDTO orderItem) {
        String sql = "INSERT INTO orderItem (orderID, bookID, quantity, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, orderItem.getOrderId());
            pr.setInt(2, orderItem.getProductId());
            pr.setInt(3, orderItem.getQuantity());
            pr.setDouble(4, orderItem.getPrice());
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<OrderItemDTO> getOrderItemsByOrderId(int orderId) {
        List<OrderItemDTO> list = new ArrayList<>();
        String sql = "SELECT oi.orderId, oi.bookId, oi.quantity, oi.price, " +
                     "b.BookTitle, b.Author, b.Image, b.Price as BookPrice " +
                     "FROM orderItem oi JOIN Book b ON oi.bookId = b.BookID WHERE oi.orderId=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, orderId);
            ResultSet rs = pr.executeQuery();
            while (rs.next()) {
                BookDTO book = new BookDTO();
                book.setBookID(rs.getInt("bookId"));
                book.setBookTitle(rs.getString("BookTitle"));
                book.setAuthor(rs.getString("Author"));
                book.setImage(rs.getString("Image"));
                book.setPrice(rs.getDouble("BookPrice"));
                OrderItemDTO item = new OrderItemDTO(
                    rs.getInt("orderId"),
                    rs.getInt("bookId"),
                    rs.getInt("quantity"),
                    rs.getDouble("price"),
                    book
                );
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteOrderItemsByOrderId(int orderId) {
        String sql = "DELETE FROM OrderItem WHERE orderId=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement pr = conn.prepareStatement(sql)) {
            pr.setInt(1, orderId);
            return pr.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
} 