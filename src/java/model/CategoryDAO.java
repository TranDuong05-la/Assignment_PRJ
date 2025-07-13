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
public class CategoryDAO {

    private static final String GET_ALL_CATEGORY = "SELECT * FROM Category";
    private static final String GET_CATEGORY_BY_ID = "SELECT * FROM Category WHERE CategoryID=?";
    private static final String CREATE_CATEGORY = "INSERT INTO Category (CategoryName) VALUES (?)";
    private static final String UPDATE_CATEGORY = "UPDATE Category SET CategoryName=? WHERE CategoryID=?";
    private static final String DETELE_CATEGORY = "DELETE FROM Category WHERE CategoryID=?";

    public List<CategoryDTO> getAll() {
        List<CategoryDTO> categorys = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ALL_CATEGORY);
            rs = ps.executeQuery();
            while (rs.next()) {
                CategoryDTO category = new CategoryDTO();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));

                categorys.add(category);
            }
        } catch (Exception e) {
            System.err.println("Error in getAll()" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return categorys;
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

    public CategoryDTO getCategoryById(int CategoryID) {
        CategoryDTO category = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ALL_CATEGORY);
            ps.setInt(1, CategoryID);
            rs = ps.executeQuery();
            if (rs.next()) {
                category = new CategoryDTO();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));

            }
        } catch (Exception e) {
            System.err.println("Error in getAll()" + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return category;
    }

    public boolean create(CategoryDTO category) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(CREATE_CATEGORY);

            ps.setInt(1, category.getCategoryID());
            ps.setString(2, category.getCategoryName());

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

    public boolean update(CategoryDTO category) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(UPDATE_CATEGORY);

            ps.setString(1, category.getCategoryName());
            ps.setInt(2, category.getCategoryID());
            

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

    public boolean delete(int category) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(DETELE_CATEGORY);
            ps.setInt(1, category);

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
    
    

}
