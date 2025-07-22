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
public class ReviewDAO {

    private static final String GET_ALL_REVIEW = "SELECT * FROM Review";
    private static final String GET_REVIEW_BY_BOOK_ID = "SELECT * FROM Review WHERE BookID=?";
    private static final String CREATE_REVIEW = "INSERT INTO Review (BookID, UserID, Rating, Comment, ReviewDate) VALUES (?, ?, ?, ?, GETDATE())";
    private static final String DELETE_REVIEW = "DELETE FROM Review WHERE ReviewID=?";

    public List<ReviewDTO> getReviewByBookId(int bookID) {
        List<ReviewDTO> reviews = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_REVIEW_BY_BOOK_ID);
            ps.setInt(1, bookID);
            rs = ps.executeQuery();

            while (rs.next()) {
                ReviewDTO review = new ReviewDTO();
                review.setReviewID(rs.getInt("ReviewID"));
                review.setBookID(rs.getInt("BookID"));
                review.setUserID(rs.getString("UserID"));
                review.setRating(rs.getInt("Rating"));
                review.setComment(rs.getString("Comment"));
                review.setReviewDate(rs.getTimestamp("ReviewDate"));

                reviews.add(review);
            }
        } catch (Exception e) {
            System.err.println("Error in getReviewByBookId" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return reviews;
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

    public boolean create(ReviewDTO review) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(CREATE_REVIEW);

            ps.setInt(1, review.getReviewID());
            ps.setInt(1, review.getBookID());
            ps.setString(2, review.getUserID());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
//            ps.setTimestamp(5, review.getReviewDate());

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

    public boolean delete(int reviewID) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(DELETE_REVIEW);
            ps.setInt(1, reviewID);

            int rowAffected = ps.executeUpdate();
            success = (rowAffected > 0);

        } catch (Exception e) {
            System.err.println("Error in delete(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }

    public ReviewDTO getReviewById(int reviewID) {
        ReviewDTO review = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Review WHERE ReviewID=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewID);
            rs = ps.executeQuery();
            if (rs.next()) {
                review = new ReviewDTO();
                review.setReviewID(rs.getInt("ReviewID"));
                review.setBookID(rs.getInt("BookID"));
                review.setUserID(rs.getString("UserID"));
                review.setRating(rs.getInt("Rating"));
                review.setComment(rs.getString("Comment"));
                review.setReviewDate(rs.getTimestamp("ReviewDate"));
            }
        } catch (Exception e) {
            System.err.println("Error in getReviewById: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }
        return review;
    }

}
