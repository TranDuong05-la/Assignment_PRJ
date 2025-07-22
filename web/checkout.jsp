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
    int totalQuantity = 0;
    double totalProduct = 0;
    for (CartItemDTO item : cartItems) {
        totalQuantity += item.getQuantity();
        totalProduct += item.getBook().getPrice() * item.getQuantity();
    }
    double shippingFee = 30000;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <style>
        body { background: #faf9f8; font-family: 'Segoe UI', Arial, sans-serif; margin: 0; }
        .container-checkout { max-width: 700px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 4px 32px #0001; padding: 32px 36px; }
        .section-title { font-size: 1.3em; font-weight: bold; color: #ea2222; margin-bottom: 22px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 18px; }
        th, td { border: 1px solid #eee; padding: 10px 8px; text-align: left; }
        th { background: #f7fafd; color: #1d82d2; }
        .checkout-total-box { display: flex; flex-direction: column; align-items: flex-end; margin-top: 32px; margin-bottom: 0; position: relative; }
        .checkout-total-inner { min-width: 340px; padding: 0; margin-right: 0; margin-bottom: 0; text-align: right; }
        @media (max-width: 700px) { .checkout-total-inner { min-width: 0; padding: 16px; } }
        .checkout-btn { background: #ea2222; color: #fff; border: none; border-radius: 6px; padding: 12px 36px; font-size: 1.1em; font-weight: bold; cursor: pointer; float: right; margin-top: 18px; }
        .checkout-btn:hover { background: #b71c1c; }
    </style>
</head>
<body>
<div class="container-checkout">
    <a href="cartList.jsp" style="position:absolute;top:24px;left:32px;font-weight:bold;color:#ea2222;text-decoration:none;font-size:1.08em;"><i class="fa fa-arrow-left" style="margin-right:6px;"></i>Back to Cart</a>
    <div class="section-title">Shipping Address</div>
<% if (addressList != null && !addressList.isEmpty()) { %>
    <form id="addressSelectForm" method="get" action="checkout.jsp" style="margin-bottom:24px;">
        <label for="selectedAddressId" style="font-weight:bold;color:#ea2222;">Choose your shipping address:</label>
        <select name="selectedAddressId" id="selectedAddressId" onchange="document.getElementById('addressSelectForm').submit();" style="margin-left:12px;padding:6px 12px;border-radius:6px;">
            <% String selectedId = request.getParameter("selectedAddressId");
               if (selectedId == null && addressList.size() > 0) selectedId = String.valueOf(addressList.get(0).getAddressID());
               for (AddressDTO addr : addressList) { %>
                <option value="<%=addr.getAddressID()%>" <%=String.valueOf(addr.getAddressID()).equals(selectedId)?"selected":""%>>
                    <%=addr.getRecipientName()%> (<%=addr.getPhone()%>) - <%=addr.getAddressDetail()%>, <%=addr.getDistrict()%>, <%=addr.getCity()%>
                </option>
            <% } %>
        </select>
    </form>
    <% AddressDTO selectedAddr = null;
       for (AddressDTO addr : addressList) {
           if (String.valueOf(addr.getAddressID()).equals(selectedId)) { selectedAddr = addr; break; }
       }
    %>
    <div style="background:#f7fafd; border-radius:10px; padding:18px 24px; margin-bottom:24px;">
        <span style="color:#ea2222;font-weight:bold;"><i class="fa fa-map-marker-alt"></i> Shipping Address</span><br>
        <% if (selectedAddr != null) { %>
            <b><%=selectedAddr.getRecipientName()%> (<%=selectedAddr.getPhone()%>)</b>
            <span style="margin-left:12px;"><%=selectedAddr.getAddressDetail()%>, <%=selectedAddr.getDistrict()%>, <%=selectedAddr.getCity()%></span>
        <% } %>
    </div>
<% } else { %>
    <div style="color:#888;">No address found for this user.</div>
<% } %>
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
        <% for (CartItemDTO item : cartItems) {
            BookDTO book = item.getBook();
            double total = book.getPrice() * item.getQuantity();
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
        <% if (cartItems.size() == 0) { %>
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
        <div style="display:flex;align-items:center;gap:32px;justify-content:flex-end;margin-bottom:10px;">
            <div style="font-size:1.25em;font-weight:bold;color:#ea2222;">
                <span id="totalPayment">₫<%=String.format("%,.0f", totalProduct + shippingFee)%></span>
            </div>
            <div style="color:#888;font-size:1.05em;">(
                <span id="productCount"><%=totalQuantity%></span> product<%=totalQuantity==1?"":"s"%> in order)
            </div>
        </div>
        <form id="placeOrderForm" method="post" action="OrderController">
            <% for (CartItemDTO item : cartItems) { %>
                <input type="hidden" name="selectedItems" value="<%=item.getCartItemID()%>" />
            <% } %>
            <input type="hidden" name="userId" value="<%=user != null ? user.getUserID() : ""%>" />
            <input type="hidden" name="totalAmount" value="<%=totalProduct + shippingFee%>" />
            <input type="hidden" name="addressId" value="<%=request.getParameter("selectedAddressId") != null ? request.getParameter("selectedAddressId") : (addressList.size() > 0 ? addressList.get(0).getAddressID() : "")%>" />
            <input type="hidden" name="action" value="addOrder" />
            <input type="hidden" name="orderDate" value="<%=orderDate%>" />
            <input type="hidden" name="status" value="Pending" />
            <input type="hidden" id="paymentMethodInput" name="paymentMethod" value="cod" />
            <button id="placeOrderBtn" type="submit" class="checkout-btn">Place Order</button>
        </form>
        <script>
            const form = document.getElementById('placeOrderForm');
            const radios = document.getElementsByName('paymentMethod');
            const paymentInput = document.getElementById('paymentMethodInput');
            radios.forEach(radio => {
                radio.addEventListener('change', function() {
                    paymentInput.value = this.value;
                    if (this.value === 'online') {
                        form.action = 'PaymentController';
                    } else {
                        form.action = 'OrderController';
                    }
                });
            });
        </script>
      </div>
    </div>
</div>
</body>
</html> 