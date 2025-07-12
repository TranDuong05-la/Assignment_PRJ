package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class PaymentDAO {

    public boolean addPayment(PaymentDTO payment) {
        String sql = "INSERT INTO tblPayments (orderID, method, amount, status, paymentDate) VALUES (?, ?, ?, 1, ?)";
        try (Connection con = DbUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, payment.getOrderID());
            ps.setString(2, payment.getMethod());
            ps.setDouble(3, payment.getAmount());
            ps.setTimestamp(4, payment.getPaymentDate());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public PaymentDTO getPaymentByOrderID(int orderID) {
        String sql = "SELECT * FROM tblPayments WHERE orderID = ?";
        try (Connection con = DbUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new PaymentDTO(
                    rs.getInt("paymentID"),
                    rs.getInt("orderID"),
                    rs.getString("method"),
                    rs.getDouble("amount"),
                    rs.getString("status"),
                    rs.getTimestamp("paymentDate")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PaymentDTO> getAllPayments() {
        List<PaymentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblPayments";
        try (Connection con = DbUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new PaymentDTO(
                    rs.getInt("paymentID"),
                    rs.getInt("orderID"),
                    rs.getString("method"),
                    rs.getDouble("amount"),
                    rs.getString("status"),
                    rs.getTimestamp("paymentDate")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
