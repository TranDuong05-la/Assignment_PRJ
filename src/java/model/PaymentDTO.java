package model;

import java.sql.Timestamp;

public class PaymentDTO {
    private int paymentID;
    private int orderID;
    private String method;
    private double amount;
    private String status;
    private Timestamp paymentDate;

    public PaymentDTO() {}

    public PaymentDTO(int paymentID, int orderID, String method, double amount, String status, Timestamp paymentDate) {
        this.paymentID = paymentID;
        this.orderID = orderID;
        this.method = method;
        this.amount = amount;
        this.status = status;
        this.paymentDate = paymentDate;
    }

    // Getters and Setters
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }
}
