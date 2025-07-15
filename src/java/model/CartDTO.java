package model;

public class CartDTO {
    private int cartId;
    private int userId;
    private String createdTime;

    public CartDTO() {}

    public CartDTO(int cartId, int userId, String createdTime) {
        this.cartId = cartId;
        this.userId = userId;
        this.createdTime = createdTime;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(String createdTime) {
        this.createdTime = createdTime;
    }
} 