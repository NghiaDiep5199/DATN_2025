import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatProductProvider with ChangeNotifier {
  List<Map<String, dynamic>> productList = [];

  Future<void> fetchProductsFromFirebase() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    productList = snapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  Map<String, dynamic>? getProductWithHighestPrice() {
    if (productList.isEmpty) return null;
    return productList.reduce(
      (curr, next) =>
          (curr['productPrice'] ?? 0) > (next['productPrice'] ?? 0)
              ? curr
              : next,
    );
  }

  Map<String, dynamic>? getHighestPriceInCategory(String category) {
    final filtered =
        productList
            .where(
              (p) => p['category']?.toLowerCase() == category.toLowerCase(),
            )
            .toList();
    if (filtered.isEmpty) return null;

    filtered.sort(
      (a, b) => (b['productPrice'] ?? 0).compareTo(a['productPrice'] ?? 0),
    );
    return filtered.first;
  }

  Map<String, dynamic>? getLowestPriceInCategory(String category) {
    final filtered =
        productList
            .where(
              (p) => p['category']?.toLowerCase() == category.toLowerCase(),
            )
            .toList();
    if (filtered.isEmpty) return null;

    filtered.sort(
      (a, b) => (a['productPrice'] ?? 0).compareTo(b['productPrice'] ?? 0),
    );
    return filtered.first;
  }

  List<Map<String, dynamic>> getTopRatedProductsByCategory(
    String category, {
    int limit = 3,
  }) {
    final products =
        productList.where((product) {
          final productCategory = product['category']?.toString().toLowerCase();
          return productCategory == category.toLowerCase();
        }).toList();

    products.sort(
      (a, b) => (b['averageRating'] ?? 0).compareTo(a['averageRating'] ?? 0),
    );

    return products.take(limit).toList();
  }

  List<Map<String, dynamic>> getProductsUnderPrice(
    String category,
    double priceLimit,
  ) {
    return productList
        .where(
          (product) =>
              product['category'] == category &&
              product['productPrice'] <= priceLimit,
        )
        .toList();
  }

  Map<String, dynamic>? getHighestRatedProduct(String category) {
    final productsInCategory =
        productList
            .where(
              (p) =>
                  p['category'].toString().toLowerCase() ==
                  category.toLowerCase(),
            )
            .toList();

    if (productsInCategory.isEmpty) return null;

    productsInCategory.sort(
      (a, b) =>
          (b['averageRating'] ?? 0.0).compareTo(a['averageRating'] ?? 0.0),
    );

    return productsInCategory.first;
  }

  Future<List<Map<String, dynamic>>> fetchProductsByFilter({
    required String category,
    required double averageRating,
  }) async {
    Query query = FirebaseFirestore.instance.collection('products');

    if (category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    query = query.where('averageRating', isGreaterThanOrEqualTo: averageRating);

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
