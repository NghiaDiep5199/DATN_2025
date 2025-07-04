import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_store/provider/cart_provider.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/checkout_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cartProvider.removeAllItem();
            },
            icon: const Icon(CupertinoIcons.delete, color: Colors.black),
          ),
        ],
      ),
      body:
          _cartProvider.getCartItem.isNotEmpty
              ? Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: _cartProvider.getCartItem.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final cartData =
                            _cartProvider.getCartItem.values.toList()[index];

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: cartData.isSelected,
                                onChanged: (value) {
                                  _cartProvider.toggleProductSelection(
                                    cartData.productId,
                                  );
                                },
                              ),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.white,
                                  child: Image.network(
                                    cartData.imageUrl[0],
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartData.productName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${cartData.discountPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.yellow.shade900,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '\$${cartData.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed:
                                                    cartData.quantity == 1
                                                        ? null
                                                        : () => _cartProvider
                                                            .decreament(
                                                              cartData,
                                                            ),
                                                icon: const Icon(
                                                  CupertinoIcons.minus,
                                                ),
                                              ),
                                              Text(
                                                cartData.quantity.toString(),
                                              ),
                                              IconButton(
                                                onPressed:
                                                    cartData.productQuantity ==
                                                            cartData.quantity
                                                        ? null
                                                        : () => _cartProvider
                                                            .increament(
                                                              cartData,
                                                            ),
                                                icon: const Icon(
                                                  CupertinoIcons.plus,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:
                                              () => _cartProvider.removeItem(
                                                cartData.productId,
                                              ),
                                          icon: const Icon(
                                            CupertinoIcons.cart_badge_minus,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Subtotal (${_cartProvider.selectedItems.length} items): \$${_cartProvider.totalSelectedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Text(
                        //   'Shipping: \$${_cartProvider.totalSelectedShippingCharge.toStringAsFixed(0)}',
                        //   style: const TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed:
                              _cartProvider.selectedItems.isEmpty
                                  ? null
                                  : () {
                                    final selectedItems =
                                        _cartProvider.selectedItems;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => CheckoutScreen(
                                              selectedItems: selectedItems,
                                            ),
                                      ),
                                    );
                                  },
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your shopping cart is empty',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                      ),
                      child: const Text(
                        'Continue shopping',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
