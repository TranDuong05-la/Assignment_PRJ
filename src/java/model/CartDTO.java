package model;


import java.util.List;

public class CartDTO {
    private int cartId;
    private String userId;
    private List<CartItemDTO> items;

    public CartDTO() {}

    public CartDTO(int cartId, String userId, List<CartItemDTO> items) {
        this.cartId = cartId;
        this.userId = userId;
        this.items = items;
    }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public List<CartItemDTO> getItems() { return items; }
    public void setItems(List<CartItemDTO> items) { this.items = items; }
} 