package model;

public class AddressDTO {
    private int addressID;
    private String userID;
    private String recipientName;
    private String phone;
    private String addressDetail;
    private String district;
    private String city;
    private boolean isDefault;

    public AddressDTO() {
    }

    public AddressDTO(int addressID, String userID, String recipientName, String phone,
                      String addressDetail, String district, String city, boolean isDefault) {
        this.addressID = addressID;
        this.userID = userID;
        this.recipientName = recipientName;
        this.phone = phone;
        this.addressDetail = addressDetail;
        this.district = district;
        this.city = city;
        this.isDefault = isDefault;
    }

    // Getters and Setters
    public int getAddressID() {
        return addressID;
    }

    public void setAddressID(int addressID) {
        this.addressID = addressID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }
}
