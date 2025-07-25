package model;

public class OrderItemDTO {
    private int orderId;
    private int productId;
    private int quantity;
    private double price;
    private BookDTO book;

    public OrderItemDTO() {}

    public OrderItemDTO(int orderId, int productId, int quantity, double price, BookDTO book) {
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.book = book;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return price;
    }

    public void setUnitPrice(double price) {
        this.price = price;
    }
    
    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public BookDTO getBook() { return book; }
    public void setBook(BookDTO book) { this.book = book; }
} 