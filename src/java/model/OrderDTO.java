
package model;

public class OrderDTO {
    private int orderId;
    private int userId;
    private String orderDate;
    private double totalAmount;
    private String status;
    private int addressId;
    private int paymentId;
    private int discountId;  

    public OrderDTO() {
    }

    public OrderDTO(int orderId, int userId, String orderDate, double totalAmount, String status, int addressId, int paymentId, int discountId) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.addressId = addressId;
        this.paymentId = paymentId;
        this.discountId = discountId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public int getAddressId() {
        return addressId;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public int getDiscountId() {
        return discountId;
    }



    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }
    
}
