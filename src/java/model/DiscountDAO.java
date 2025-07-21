package model;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import utils.DbUtils;

public class DiscountDAO {

    public boolean addDiscount(DiscountDTO discount) {
        String sql = "INSERT INTO tblDiscounts (code, type, value, minOrderAmount, expiryDate) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, discount.getCode());
            ps.setString(2, discount.getType());
            ps.setDouble(3, discount.getValue());
            ps.setDouble(4, discount.getMinOrderAmount());
            ps.setDate(5, discount.getExpiryDate());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<DiscountDTO> getAllDiscounts() {
        List<DiscountDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblDiscounts ORDER BY expiryDate DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DiscountDTO dto = new DiscountDTO(
                    rs.getInt("discountID"),
                    rs.getString("code"),
                    rs.getString("type"),
                    rs.getDouble("value"),
                    rs.getDouble("minOrderAmount"),
                    rs.getDate("expiryDate")
                );
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DiscountDTO> getDiscountByCode(String code) {
        String sql = "SELECT * FROM tblDiscounts WHERE code LIKE ?";
        List <DiscountDTO> discounts = new ArrayList<>();
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + code + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                        int discountID = rs.getInt("discountID");
                        String coDe = rs.getString("code");
                        String type = rs.getString("type");
                        double value = rs.getDouble("value");
                        double minOrder = rs.getDouble("minOrderAmount");
                        Date expiryDate = rs.getDate("expiryDate");
                    DiscountDTO dTO = new DiscountDTO(discountID, coDe, type, value, minOrder, expiryDate);
                    discounts.add(dTO);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return discounts;
    }

    public DiscountDTO getValidDiscount(String code) {
        String sql = "SELECT * FROM tblDiscounts WHERE code = ? AND expiryDate >= ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);
            ps.setDate(2, Date.valueOf(LocalDate.now()));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new DiscountDTO(
                        rs.getInt("discountID"),
                        rs.getString("code"),
                        rs.getString("type"),
                        rs.getDouble("value"),
                        rs.getDouble("minOrderAmount"),
                        rs.getDate("expiryDate")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
}
