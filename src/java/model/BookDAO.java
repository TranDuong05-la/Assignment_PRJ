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
public class BookDAO {

    private static final String GET_ALL = "SELECT * FROM Book";
    private static final String GET_BOOK_BY_ID = "SELECT * FROM Book WHERE BookID=?";
    private static final String GET_CATEGORY_ID = "SELECT * FROM Book WHERE CategoryID=?";
//    CHUA FIX
    private static final String CREATE_BOOK = "INSERT INTO Book (CategoryID, BookTitle, Author, Publisher, Price, Image, Description, PublishYear) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_BOOK = "UPDATE Book SET CategoryID=?, BookTitle=?, Author=?, Publisher=?, Price=?, Image=?, Description=?, PublishYear=? WHERE BookID=?";
//    private static final String UPDATE_PRODUCT_STATUS = "UPDATE tblProducts SET status = ? WHERE id = ?";
    private static final String DELETE_BOOK = "DELETE FROM Book WHERE BookID=?";

    public List<BookDTO> getAll() {
        List<BookDTO> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ALL);
            rs = ps.executeQuery();
            while (rs.next()) {
                BookDTO book = new BookDTO();
                book.setBookID(rs.getInt("BookID"));
                book.setCategoryID(rs.getInt("CategoryID"));
                book.setBookTitle(rs.getString("BookTitle"));
                book.setAuthor(rs.getString("Author"));
                book.setPublisher(rs.getString("Publisher"));
                book.setPrice(rs.getDouble("Price"));
                book.setImage(rs.getString("Image"));
                book.setDescription(rs.getString("Description"));
                book.setPublishYear(rs.getInt("PublishYear"));

                books.add(book);
            }
        } catch (Exception e) {
            System.err.println("Error in getAll()" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return books;

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

    public BookDTO getBookById(int bookID) {
        BookDTO books = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_BOOK_BY_ID);
            ps.setInt(1, bookID);
            rs = ps.executeQuery();

            if (rs.next()) {
                books = new BookDTO();
                books.setBookID(rs.getInt("BookID"));
                books.setCategoryID(rs.getInt("CategoryID"));
                books.setBookTitle(rs.getString("BookTitle"));
                books.setAuthor(rs.getString("Author"));
                books.setPublisher(rs.getString("Publisher"));
                books.setPrice(rs.getDouble("Price"));
                books.setImage(rs.getString("Image"));
                books.setDescription(rs.getString("Description"));
                books.setPublishYear(rs.getInt("PublishYear"));
            }
        } catch (Exception e) {
            System.err.println("Error in getBookById" + e.getMessage());
            e.printStackTrace();
        } finally {
        }
        return books;
    }

    public List<BookDTO> getBooksByCategory(int categoryID) {
        List<BookDTO> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_CATEGORY_ID);
            rs = ps.executeQuery();
            while (rs.next()) {
                BookDTO book = new BookDTO();
                book.setBookID(rs.getInt("BookID"));
                book.setCategoryID(rs.getInt("CategoryID"));
                book.setBookTitle(rs.getString("BookTitle"));
                book.setAuthor(rs.getString("Author"));
                book.setPublisher(rs.getString("Publisher"));
                book.setPrice(rs.getDouble("Price"));
                book.setImage(rs.getString("Image"));
                book.setDescription(rs.getString("Description"));
                book.setPublishYear(rs.getInt("PublishYear"));

                books.add(book);
            }
        } catch (Exception e) {
            System.err.println("Error in getAll()" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return books;

    }

    public boolean create(BookDTO book) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(CREATE_BOOK);
// truyền value
            ps.setInt(1, book.getBookID());
            ps.setInt(2, book.getCategoryID());
            ps.setString(3, book.getBookTitle());
            ps.setString(4, book.getAuthor());
            ps.setString(5, book.getPublisher());
            ps.setDouble(6, book.getPrice());
            ps.setString(7, book.getImage());
            ps.setString(8, book.getDescription());
            ps.setInt(9, book.getPublishYear());
// select ko lm thay đổi data, insert, update, delete sẽ lm thay đổi -> executeUpdate()
//executeQuery sẽ ko thay đỗi data
            int rowsAffected = ps.executeUpdate();// số lượng dòng thay đổi 
            success = (rowsAffected > 0);// ít nhất có 1 dòng bị thay đổi: ko thêm đc có những lỗi như trùng Id hoặc thiếu data

        } catch (Exception e) {
            System.err.println("Error in create(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }

        return success;

    }

    public boolean update(BookDTO book) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(UPDATE_BOOK);
// truyền value
            ps.setInt(1, book.getBookID());
            ps.setInt(2, book.getCategoryID());
            ps.setString(3, book.getBookTitle());
            ps.setString(4, book.getAuthor());
            ps.setString(5, book.getPublisher());
            ps.setDouble(6, book.getPrice());
            ps.setString(7, book.getImage());
            ps.setString(8, book.getDescription());
            ps.setInt(9, book.getPublishYear());
// select ko lm thay đổi data, insert, update, delete sẽ lm thay đổi -> executeUpdate()
//executeQuery sẽ ko thay đỗi data
            int rowsAffected = ps.executeUpdate();// số lượng dòng thay đổi 
            success = (rowsAffected > 0);// ít nhất có 1 dòng bị thay đổi: ko thêm đc có những lỗi như trùng Id hoặc thiếu data

        } catch (Exception e) {
            System.err.println("Error in create(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }

        return success;

    }

    public boolean isBookExists(int bookID) {
        return getBookById(bookID) != null;
    }
    
    
     public List<BookDTO> getBooksByName(String name) {
        List<BookDTO> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String query = GET_ALL + " WHERE BookTitle LIKE ?";
        System.out.println("QUERY: " + query);
//        BookTitle
        try {
            conn = DbUtils.getConnection();
            ps.setString(1, "%" + name + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                BookDTO book = new BookDTO();
                book.setBookID(rs.getInt("BookID"));
                book.setCategoryID(rs.getInt("CategoryID"));
                book.setBookTitle(rs.getString("BookTitle"));
                book.setAuthor(rs.getString("Author"));
                book.setPublisher(rs.getString("Publisher"));
                book.setPrice(rs.getDouble("Price"));
                book.setImage(rs.getString("Image"));
                book.setDescription(rs.getString("Description"));
                book.setPublishYear(rs.getInt("PublishYear"));

                books.add(book);
            }
        } catch (Exception e) {
            System.err.println("Error in getAll()" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return books;

    }
     
     
//     public List<BookDTO> getActiveBooksByName(String name) {
//        List<BookDTO> books = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        String query = GET_ALL + " WHERE BookTitle LIKE ?";
//        System.out.println("QUERY: " + query);
////        BookTitle
//        try {
//            conn = DbUtils.getConnection();
//            ps.setString(1, "%" + name + "%");
//            rs = ps.executeQuery();
//            while (rs.next()) {
//                BookDTO book = new BookDTO();
//                book.setBookID(rs.getInt("BookID"));
//                book.setCategoryID(rs.getInt("CategoryID"));
//                book.setBookTitle(rs.getString("BookTitle"));
//                book.setAuthor(rs.getString("Author"));
//                book.setPublisher(rs.getString("Publisher"));
//                book.setPrice(rs.getDouble("Price"));
//                book.setImage(rs.getString("Image"));
//                book.setDescription(rs.getString("Description"));
//                book.setPublishYear(rs.getInt("PublishYear"));
//
//                books.add(book);
//            }
//        } catch (Exception e) {
//            System.err.println("Error in getAll()" + e.getMessage());
//            e.printStackTrace();
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return books;
//
//    }
}
