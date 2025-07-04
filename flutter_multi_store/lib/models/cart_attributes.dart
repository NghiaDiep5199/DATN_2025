import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CartAttr with ChangeNotifier {
  final String productName;

  final String productId;

  final List imageUrl;

  int quantity;

  int productQuantity;

  final double discountPrice;

  final double price;
  final double shippingCharge;

  final String vendorId;

  final String productSize;

  Timestamp scheduleDate;

  bool isSelected;

  CartAttr({
    required this.productName,
    required this.productId,
    required this.imageUrl,
    required this.quantity,
    required this.productQuantity,
    required this.discountPrice,
    required this.price,
    required this.shippingCharge,
    required this.vendorId,
    required this.productSize,
    required this.scheduleDate,
    this.isSelected = false,
  });

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}
