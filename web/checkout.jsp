<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserDTO" %>
<%@ page import="model.AddressDAO" %>
<%@ page import="model.AddressDTO" %>
<%@ page import="model.CartDAO" %>
<%@ page import="model.CartDTO" %>
<%@ page import="model.CartItemDTO" %>
<%@ page import="model.BookDTO" %>
<%@ page import="model.DiscountDAO" %>
<%@ page import="model.DiscountDTO" %>
<%@ page import="java.util.List" %>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    AddressDAO addressDAO = new AddressDAO();
    java.util.List<AddressDTO> addressList = user != null ? addressDAO.getAddressesByUser(user.getUserID()) : new java.util.ArrayList<>();
    CartDAO cartDAO = new CartDAO();
    CartDTO cart = user != null ? cartDAO.getCartByUserId(user.getUserID()) : null;
    java.util.List<CartItemDTO> cartItems = (cart != null && cart.getItems() != null) ? cart.getItems() : new java.util.ArrayList<>();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy");
    java.util.Calendar cal = java.util.Calendar.getInstance();
    String orderDate = sdf.format(cal.getTime());
    cal.add(java.util.Calendar.DATE, 3);
    String deliveryDate = sdf.format(cal.getTime());
    double shippingFee = 30000;
    DiscountDAO discountDAO = new DiscountDAO();
    java.util.List<DiscountDTO> discountList = discountDAO.getAllDiscounts();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <style>
        body { background: #faf9f8; font-family: 'Segoe UI', Arial, sans-serif; margin: 0; }
        .container-checkout { max-width: 700px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 4px 32px #0001; padding: 32px 36px; }
        .section-title { font-size: 1.3em; font-weight: bold; color: #ea2222; margin-bottom: 12px; margin-top: 24px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 18px; }
        th, td { border: 1px solid #eee; padding: 10px 8px; text-align: left; }
        th { background: #f7fafd; color: #1d82d2; }
        .checkout-total-box { display: flex; flex-direction: column; align-items: flex-end; margin-top: 32px; margin-bottom: 0; position: relative; }
        .checkout-total-inner { min-width: 340px; padding: 0; margin-right: 0; margin-bottom: 0; text-align: right; }
        @media (max-width: 700px) { .checkout-total-inner { min-width: 0; padding: 16px; } }
        .checkout-btn { background: #ea2222; color: #fff; border: none; border-radius: 6px; padding: 12px 36px; font-size: 1.1em; font-weight: bold; cursor: pointer; float: right; margin-top: 18px; }
        .checkout-btn:hover { background: #b71c1c; }
        .form-select, select.form-control, select {
            border-radius: 8px;
            padding: 10px 16px;
            font-size: 1.08em;
            border: 1.5px solid #e0e0e0;
            background: #f7fafd;
            margin-bottom: 18px;
            transition: border 0.18s;
        }
        .form-select:focus, select.form-control:focus, select:focus {
            border-color: #ea2222;
            outline: none;
            background: #fff;
        }
        label[for="discountSelect"], label[for="addressSelect"] {
            font-weight: 500;
            color: #ea2222;
            margin-bottom: 6px;
            display: block;
        }
        #discountSelect option, #addressSelect option {
            padding: 8px 12px;
            font-size: 1.07em;
        }
        #discountSelect:hover, #addressSelect:hover {
            border-color: #b71c1c;
            background: #fff3f3;
        }
    </style>
</head>
<body>
<div class="container-checkout">
    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null && !message.isEmpty()) { %>
        <div style="color:green;font-weight:bold;margin-top:32px;margin-bottom:12px;text-align:center;font-size:1.18em;">
            <%= message %>
        </div>
    <% } %>
    <a href="cartList.jsp" style="position:absolute;top:24px;left:32px;font-weight:bold;color:#ea2222;text-decoration:none;font-size:1.08em;"><i class="fa fa-arrow-left" style="margin-right:6px;"></i>Back to Cart</a>
    <% AddressDTO selectedAddr = null;
       for (AddressDTO addr : addressList) { if (addr.isDefault()) { selectedAddr = addr; break; } }
       if (selectedAddr == null && addressList.size() > 0) selectedAddr = addressList.get(0);
    %>
    <form id="checkoutForm" method="post" action="OrderController">
    <input type="hidden" name="action" value="addOrder"/>
    <div class="section-title">Shipping Address</div>
    <label for="addressSelect">Choose your shipping address:</label>
    <% if (addressList.size() > 1) { %>
        <select id="addressSelect" name="selectedAddressId" class="form-select" required>
            <% for (AddressDTO addr : addressList) { %>
                <option value="<%=addr.getAddressID()%>" <%= (selectedAddr != null && addr.getAddressID() == selectedAddr.getAddressID()) ? "selected" : "" %>>
                    <%=addr.getRecipientName()%> - <%=addr.getAddressDetail()%>, <%=addr.getDistrict()%>, <%=addr.getCity()%> (<%=addr.getPhone()%>)
                </option>
            <% } %>
        </select>
    <% } else if (selectedAddr != null) { %>
        <div style="background:#f7fafd; border-radius:10px; padding:18px 24px; margin-bottom:24px;">
            <span style="color:#ea2222;font-weight:bold;"><i class="fa fa-map-marker-alt"></i> Shipping Address</span><br>
            <b><%=selectedAddr.getRecipientName()%> (<%=selectedAddr.getPhone()%>)</b>
            <span style="margin-left:12px;"><%=selectedAddr.getAddressDetail()%>, <%=selectedAddr.getDistrict()%>, <%=selectedAddr.getCity()%></span>
            <input type="hidden" name="selectedAddressId" value="<%=selectedAddr.getAddressID()%>" />
        </div>
    <% } else { %>
        <div style="color:#888;">No address found for this user.</div>
    <% } %>
    <%-- Product List: chỉ hiển thị selectedItems nếu có, nếu không thì hiển thị toàn bộ giỏ hàng --%>
    <div class="section-title">Product List</div>
    <table>
        <tr>
            <th>Product</th>
            <th>Title</th>
            <th>Author</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
        </tr>
        <% String[] selectedItems = request.getParameterValues("selectedItems");
           java.util.Set<Integer> selectedSet = new java.util.HashSet<>();
           if (selectedItems != null) {
               for (String s : selectedItems) selectedSet.add(Integer.parseInt(s));
           }
           int totalQuantity = 0;
           double totalProduct = 0;
           boolean hasSelected = (selectedSet.size() > 0);
           for (CartItemDTO item : cartItems) {
               if (hasSelected && !selectedSet.contains(item.getCartItemID())) continue;
               BookDTO book = item.getBook();
               double total = book.getPrice() * item.getQuantity();
               totalQuantity += item.getQuantity();
               totalProduct += total;
        %>
        <tr>
            <td><img src="<%=book.getImage()%>" alt="img" style="width:48px;height:64px;object-fit:cover;border-radius:6px;box-shadow:0 2px 8px #0001;" /></td>
            <td><%=book.getBookTitle()%></td>
            <td><%=book.getAuthor()%></td>
            <td>₫<%=String.format("%,.0f", book.getPrice())%></td>
            <td><%=item.getQuantity()%></td>
            <td>₫<%=String.format("%,.0f", total)%></td>
        </tr>
        <% } %>
        <% if (totalQuantity == 0) { %>
        <tr><td colspan="6" style="text-align:center;color:#888;">No products selected.</td></tr>
        <% } %>
    </table>
    <div class="section-title"><i class="fa fa-comment-dots" style="color:#ea2222;margin-right:8px;"></i>Order Note</div>
    <textarea class="form-control" rows="2" style="width:100%;min-height:60px;resize:vertical;" placeholder="Leave a note for the admin..."></textarea>
    <div class="section-title"><i class="fa fa-shipping-fast" style="color:#ea2222;margin-right:8px;"></i>Shipping Method</div>
    <div style="background:#f7fafd; border-radius:8px; padding:18px 24px; margin-bottom:18px;">
        <b>Express</b> (30,000 VND) <br>
        <span style="color:#888;font-size:0.98em;">Order date: <%=orderDate%></span><br>
        <span style="color:#888;font-size:0.98em;">Estimated delivery: <%=deliveryDate%></span>
        <div style="color:#888; font-size:0.97em; margin-top:8px;">
            Delivery is guaranteed within 3 days from your order date. If your order is not delivered by the estimated date, you will receive a compensation voucher. Please make sure your shipping address is correct before placing the order.
        </div>
    </div>
    <%-- Discount/Voucher select --%>
    <div class="section-title">Voucher (Discount)</div>
    <label for="discountSelect">Choose a voucher:</label>
    <select id="discountSelect" name="discountId" class="form-select">
        <option value="">-- No voucher --</option>
        <% for (DiscountDTO d : discountList) { %>
            <option value="<%=d.getDiscountID()%>" data-type="<%=d.getType()%>" data-value="<%=d.getValue()%>" data-min="<%=d.getMinOrderAmount()%>">
                <%=d.getCode()%> - <%=d.getType().equals("percent") ? (d.getValue() + "% off") : (String.format("₫%,.0f off", d.getValue()))%> (min ₫<%=String.format("%,.0f", d.getMinOrderAmount())%>)
            </option>
        <% } %>
    </select>
    <div class="section-title" style="margin-top:24px;"><i class="fa fa-credit-card" style="color:#ea2222;margin-right:8px;"></i>Payment Method</div>
    <div style="margin-bottom:18px;">
      <label style="margin-right:24px;">
        <input type="radio" name="paymentMethod" value="cod" checked> Cash on Delivery
      </label>
      <label>
        <input type="radio" name="paymentMethod" value="online"> Online Payment
      </label>
    </div>
    <div style="display:flex;justify-content:flex-end;margin-top:18px;">
      <div class="checkout-total-inner">
        <div class="section-title" style="text-align:right;"><i class="fa fa-money-bill-wave" style="color:#ea2222;margin-right:8px;"></i>Total Payment</div>
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;">
            <div style="color:#888;font-size:1.05em;text-align:left;">
                (<span id="productCount"><%=totalQuantity%></span> product<%=totalQuantity==1?"":"s"%> in order)
            </div>
            <div style="font-size:1.25em;font-weight:bold;color:#ea2222;text-align:right;min-width:180px;">
                <span id="totalPayment">₫<%=String.format("%,.0f", totalProduct + shippingFee)%></span>
            </div>
        </div>
        <input type="hidden" name="userId" value="<%=user != null ? user.getUserID() : ""%>" />
        <input type="hidden" name="totalAmount" id="totalAmountInput" value="<%=totalProduct + shippingFee%>" />
        <% for (Integer id : selectedSet) { %>
            <input type="hidden" name="selectedItems" value="<%=id%>" />
        <% } %>
        
        <button id="placeOrderBtn" type="submit" class="checkout-btn">Place Order</button>
      </div>
    </div>
    </form>
<script>
// Voucher/Discount select logic
const discountSelect = document.getElementById('discountSelect');
const totalPaymentSpan = document.getElementById('totalPayment');
const totalAmountInput = document.getElementById('totalAmountInput');
var shippingFee = Number('<%=shippingFee%>');
var baseTotal = Number('<%=totalProduct%>');
function updateTotalWithDiscount() {
    let selected = discountSelect.options[discountSelect.selectedIndex];
    let type = selected.getAttribute('data-type');
    let value = parseFloat(selected.getAttribute('data-value'));
    let min = parseFloat(selected.getAttribute('data-min'));
    let total = baseTotal;
    let discount = 0;
    if (selected.value && total >= min) {
        if (type === 'percent') {
            discount = total * value / 100;
        } else {
            discount = value;
        }
    }
    let finalTotal = Math.max(0, total - discount + shippingFee);
    totalPaymentSpan.innerText = '₫' + finalTotal.toLocaleString('en-US');
    totalAmountInput.value = finalTotal;
}
discountSelect && discountSelect.addEventListener('change', updateTotalWithDiscount);
window.addEventListener('DOMContentLoaded', updateTotalWithDiscount);
</script>
</body>
</html>