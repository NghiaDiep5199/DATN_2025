import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_store/models/cart_attributes.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.00;

    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void toggleProductSelection(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!.isSelected = !_cartItems[productId]!.isSelected;
      notifyListeners();
    }
  }

  double get totalSelectedPrice {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      if (value.isSelected) {
        total += value.discountPrice * value.quantity;
      }
    });
    return total;
  }

  double get totalSelectedShippingCharge {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      if (value.isSelected) {
        total += value.shippingCharge;
      }
    });
    return total;
  }

  List<CartAttr> get selectedItems {
    return _cartItems.values.where((item) => item.isSelected).toList();
  }

  void addProductToCart(
    String productName,
    String productId,
    List imageUrl,
    int quantity,
    int productQuantity,
    double discountPrice,
    double price,
    double shippingCharge,
    String vendorId,
    String productSize,
    Timestamp scheduleDate,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (exitingCart) => CartAttr(
          productName: exitingCart.productName,
          productId: exitingCart.productId,
          imageUrl: exitingCart.imageUrl,
          quantity: exitingCart.quantity + 1,
          productQuantity: exitingCart.productQuantity,
          discountPrice: exitingCart.discountPrice,
          price: exitingCart.price,
          shippingCharge: exitingCart.shippingCharge,
          vendorId: exitingCart.vendorId,
          productSize: exitingCart.productSize,
          scheduleDate: exitingCart.scheduleDate,
        ),
      );

      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartAttr(
          productName: productName,
          productId: productId,
          imageUrl: imageUrl,
          quantity: quantity,
          productQuantity: productQuantity,
          discountPrice: discountPrice,
          price: price,
          shippingCharge: shippingCharge,
          vendorId: vendorId,
          productSize: productSize,
          scheduleDate: scheduleDate,
        ),
      );

      notifyListeners();
    }
  }

  void increament(CartAttr cartAttr) {
    cartAttr.increase();

    notifyListeners();
  }

  void decreament(CartAttr cartAttr) {
    cartAttr.decrease();

    notifyListeners();
  }

  removeItem(productId) {
    _cartItems.remove(productId);

    notifyListeners();
  }

  removeAllItemPlace(productId) {
    _cartItems.clear();

    notifyListeners();
  }

  removeAllItem() {
    _cartItems.clear();

    notifyListeners();
  }
}
