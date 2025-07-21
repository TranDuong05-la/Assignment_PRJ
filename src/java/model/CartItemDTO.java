package model;

public class CartItemDTO {
    private int cartItemID;
    private int cartID;
    private int bookID;
    private int quantity;
    private BookDTO book;

    public CartItemDTO() {}

    public CartItemDTO(int cartItemID, int cartID, int bookID, int quantity, BookDTO book) {
        this.cartItemID = cartItemID;
        this.cartID = cartID;
        this.bookID = bookID;
        this.quantity = quantity;
        this.book = book;
    }

    public int getCartItemID() { return cartItemID; }
    public void setCartItemID(int cartItemID) { this.cartItemID = cartItemID; }
    public int getCartID() { return cartID; }
    public void setCartID(int cartID) { this.cartID = cartID; }
    public int getBookID() { return bookID; }
    public void setBookID(int bookID) { this.bookID = bookID; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BookDTO getBook() { return book; }
    public void setBook(BookDTO book) { this.book = book; }
} 