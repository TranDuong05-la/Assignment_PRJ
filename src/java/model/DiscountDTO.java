package model;

import java.sql.Date;

public class DiscountDTO {
    private int discountID;
    private String code;
    private String type;           // "percent" or "fixed"
    private double value;
    private double minOrderAmount;
    private Date expiryDate;

    public DiscountDTO() {}

    public DiscountDTO(int discountID, String code, String type, double value, double minOrderAmount, Date expiryDate) {
        this.discountID = discountID;
        this.code = code;
        this.type = type;
        this.value = value;
        this.minOrderAmount = minOrderAmount;
        this.expiryDate = expiryDate;
    }

    public int getDiscountID() {
        return discountID;
    }

    public void setDiscountID(int discountID) {
        this.discountID = discountID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public double getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(double minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
}
