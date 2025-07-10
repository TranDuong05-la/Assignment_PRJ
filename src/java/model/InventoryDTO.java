/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author ASUS
 */
public class InventoryDTO {
    private int inventoryID;
    private int bookID;
    private int quantity;
    private java.sql.Timestamp lastUpdate;

    public InventoryDTO() {
        
    }
    

    public InventoryDTO(int inventoryID, int bookID, int quantity, Timestamp lastUpdate) {
        this.inventoryID = inventoryID;
        this.bookID = bookID;
        this.quantity = quantity;
        this.lastUpdate = lastUpdate;
    }

    public int getInventoryID() {
        return inventoryID;
    }

    public void setInventoryID(int inventoryID) {
        this.inventoryID = inventoryID;
    }

    public int getBookID() {
        return bookID;
    }

    public void setBookID(int bookID) {
        this.bookID = bookID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Timestamp lastUpdate) {
        this.lastUpdate = lastUpdate;
    }
    
    
    

}
