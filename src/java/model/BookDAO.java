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
            }else{
//            System.out.println("DAO: NO BOOK FOUND for BookID = " + bookID);
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
            ps.setInt(1, categoryID);
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
//            ps.setInt(1, book.getBookID());
            ps.setInt(1, book.getCategoryID());
            ps.setString(2, book.getBookTitle());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getPublisher());
            ps.setDouble(5, book.getPrice());
            ps.setString(6, book.getImage());
            ps.setString(7, book.getDescription());
            ps.setInt(8, book.getPublishYear());
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
            
            ps.setInt(1, book.getCategoryID());
            ps.setString(2, book.getBookTitle());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getPublisher());
            ps.setDouble(5, book.getPrice());
            ps.setString(6, book.getImage());
            ps.setString(7, book.getDescription());
            ps.setInt(8, book.getPublishYear());
            ps.setInt(9, book.getBookID());
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

    public boolean delete(int bookID) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(DELETE_BOOK);
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

    public boolean isBookExists(int bookID) {
        return getBookById(bookID) != null;
    }

    public List<BookDTO> getBooksByName(String name) {
        List<BookDTO> books = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String query = GET_ALL + " WHERE bookTitle LIKE ? OR author LIKE ? OR publisher LIKE ?";
        System.out.println("QUERY: " + query);
//        BookTitle
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, "%" + name + "%");
            ps.setString(2, "%" + name + "%");
            ps.setString(3, "%" + name + "%");
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

    public List<BookDTO> getFilterBooks(Integer categoryId, Integer priceMin, Integer priceMax, String publisher, String author, Integer rating) {
//        Integer categoryId, Integer priceMin, Integer priceMax, String publisher, String author, Integer rating
//  khai báo tham số có khả năng null để truyền dữ liệu/ ko truyền khi gọi hàm
        List<BookDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Book WHERE 1=1";
        if (categoryId != null) {
            sql += " AND CategoryID = ?";
        }
        if (priceMin != null) {
            sql += " AND Price >= ?";
        }
        if (priceMax != null) {
            sql += " AND Price <= ?";
        }
        if (publisher != null && !publisher.isEmpty()) {
            sql += " AND Publisher = ?";
        }
        if (author != null && !author.isEmpty()) {
            sql += " AND Author = ?";
        }
        if (rating != null) {
            sql += " AND Rating >= ?";
        }
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_CATEGORY_ID);
//            set data
            int idx = 1;
            if (categoryId != null) {
                ps.setInt(idx++, categoryId);
            }
            if (priceMin != null) {
                ps.setInt(idx++, priceMin);
            }
            if (priceMax != null) {
                ps.setInt(idx++, priceMax);
            }
            if (publisher != null && !publisher.isEmpty()) {
                ps.setString(idx++, publisher);
            }
            if (author != null && !author.isEmpty()) {
                ps.setString(idx++, author);
            }
            if (rating != null) {
                ps.setInt(idx++, rating);
            }
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

                list.add(book);
            }
        } catch (Exception e) {
            System.err.println("Error in getAll()" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;

    }
}
