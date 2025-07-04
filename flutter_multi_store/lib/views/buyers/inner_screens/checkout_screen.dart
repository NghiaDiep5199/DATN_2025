import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_store/models/cart_attributes.dart';
import 'package:flutter_multi_store/provider/cart_provider.dart';
import 'package:flutter_multi_store/provider/stripe_id.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/edit_profile.dart';
import 'package:flutter_multi_store/views/buyers/main_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartAttr> selectedItems;
  const CheckoutScreen({super.key, required this.selectedItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedValue = 1;
  late CartProvider _cartProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = Provider.of<CartProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot,
      ) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // ignore: unused_local_variable
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.black),
              flexibleSpace: Container(
                decoration: BoxDecoration(color: Colors.blue.shade300),
              ),
              title: Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Column(
              children: [
                data['address'] == ''
                    ? SizedBox()
                    : Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: data['fullName'] + '  ',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '(${data['phoneNumber']})' + '\n',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: data['address'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                data['address'] == ''
                    ? SizedBox()
                    : Divider(color: Colors.blueAccent),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartProvider.selectedItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index < _cartProvider.selectedItems.length) {
                        final cartData =
                            _cartProvider.selectedItems.toList()[index];
                        // final priceDiscount =
                        //     cartData.price * (1 - cartData.discount / 100);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartData.productName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
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
                                            const SizedBox(width: 8),
                                            Text(
                                              '\$${cartData.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Quantity: ${cartData.quantity.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        if (cartData.productSize.isNotEmpty)
                                          OutlinedButton(
                                            onPressed: null,
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                            child: Text(
                                              cartData.productSize,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Payment method section
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Choose payment method',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RadioListTile(
                                value: 1,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Cash on Delivery'),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Cash on Stripe'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),

                data['address'] == ''
                    ? TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditProfileScreen(userData: data);
                            },
                          ),
                        ).whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        'Enter billing address',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    )
                    : Container(
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
                          Text(
                            'Shipping: \$${_cartProvider.totalSelectedShippingCharge.toStringAsFixed(0)}',
                            // 'sadasd',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              if (selectedValue == 1) {
                                EasyLoading.show(status: 'Placing Order');

                                for (final item
                                    in _cartProvider.selectedItems) {
                                  final orderId = Uuid().v4();
                                  await _firestore
                                      .collection('orders')
                                      .doc(orderId)
                                      .set({
                                        'orderId': orderId,
                                        'vendorId': item.vendorId,
                                        'email': data['email'],
                                        'phone': data['phoneNumber'],
                                        'address': data['address'],
                                        'buyerId': data['buyerId'],
                                        'fullName': data['fullName'],
                                        'buyerPhoto': data['profileImage'],
                                        'productName': item.productName,
                                        'productPrice': item.price,
                                        'productTotalPrice':
                                            (item.discountPrice *
                                                item.quantity) +
                                            (item.shippingCharge *
                                                item.quantity),
                                        'productId': item.productId,
                                        'productImage': item.imageUrl,
                                        'quantity': item.quantity,
                                        'productSize': item.productSize,
                                        'deliverystatus': 'pending',
                                        'scheduleDate': item.scheduleDate,
                                        'orderDate': DateTime.now(),
                                        'paymentStatus': 'Cash on Delivery',
                                        'accepted': false,
                                      });

                                  await FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                        final docRef = FirebaseFirestore
                                            .instance
                                            .collection('products')
                                            .doc(item.productId);
                                        final snapshot = await transaction.get(
                                          docRef,
                                        );
                                        transaction.update(docRef, {
                                          'quantity':
                                              snapshot['quantity'] -
                                              item.quantity,
                                        });
                                      });

                                  _cartProvider.removeAllItemPlace(
                                    item.productId,
                                  );
                                }
                                EasyLoading.dismiss();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );

                                // showSnackDialog(
                                //   context,
                                //   'Order Placed Successfully',
                                // );

                                // _cartProvider.selectedItems.forEach((item) {
                                //   final orderId = Uuid().v4();
                                //   _firestore
                                //       .collection('orders')
                                //       .doc(orderId)
                                //       .set({
                                //         'orderId': orderId,
                                //         'vendorId': item.vendorId,
                                //         'email': data['email'],
                                //         'phone': data['phoneNumber'],
                                //         'address': data['address'],
                                //         'buyerId': data['buyerId'],
                                //         'fullName': data['fullName'],
                                //         'buyerPhoto': data['profileImage'],
                                //         'productName': item.productName,
                                //         'productPrice': item.price,
                                //         'productTotalPrice':
                                //             (item.discountPrice *
                                //                 item.quantity) +
                                //             (item.shippingCharge *
                                //                 item.quantity),
                                //         'productId': item.productId,
                                //         'productImage': item.imageUrl,
                                //         'quantity': item.quantity,
                                //         'productSize': item.productSize,
                                //         'deliverystatus': 'pending',
                                //         'scheduleDate': item.scheduleDate,
                                //         'orderDate': DateTime.now(),
                                //         'paymentStatus': 'Cash on Delivery',
                                //         'accepted': false,
                                //       })
                                //       .whenComplete(() async {
                                //         setState(() {
                                //           _cartProvider.removeItem(
                                //             item.productId,
                                //           );
                                //         });
                                //         EasyLoading.dismiss();

                                //         // showSnackDialog(
                                //         //   context,
                                //         //   'Order Placed Successfully',
                                //         // );

                                //         await FirebaseFirestore.instance
                                //             .runTransaction((
                                //               transaction,
                                //             ) async {
                                //               DocumentReference
                                //               documentReference =
                                //                   FirebaseFirestore.instance
                                //                       .collection('products')
                                //                       .doc(item.productId);
                                //               DocumentSnapshot snapshot =
                                //                   await transaction.get(
                                //                     documentReference,
                                //                   );
                                //               transaction
                                //                   .update(documentReference, {
                                //                     'quantity':
                                //                         snapshot['quantity'] -
                                //                         item.quantity,
                                //                   });
                                //             });

                                //         Navigator.pushAndRemoveUntil(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) => MainScreen(),
                                //           ),
                                //           (Route<dynamic> route) => false,
                                //         );
                                //       });
                                // });
                              } else if (selectedValue == 2) {
                                print('stripe');
                                final total =
                                    _cartProvider.totalSelectedPrice +
                                    _cartProvider.totalSelectedShippingCharge;
                                final int pay = (total * 100).round();

                                await makePayment(data, pay.toString());
                              }
                            },
                            child: const Text(
                              'Place order',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(color: Colors.blue.shade300),
        );
      },
    );
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment(dynamic data, String total) async {
    try {
      paymentIntentData = await createPaymentIntent(total, 'USD');
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'ANNIE',
        ),
      );

      await displayPaymentSheet(data);
    } catch (e) {
      print('exception:$e');
    }
  }

  displayPaymentSheet(dynamic data) async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet().then((value) async {
        paymentIntentData = null;
        print('paid stripe');

        EasyLoading.show(status: 'Placing Order');
        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        for (final item in _cartProvider.selectedItems) {
          final orderId = Uuid().v4();
          await _firestore.collection('orders').doc(orderId).set({
            'orderId': orderId,
            'vendorId': item.vendorId,
            'email': data['email'],
            'phone': data['phoneNumber'],
            'address': data['address'],
            'buyerId': data['buyerId'],
            'fullName': data['fullName'],
            'buyerPhoto': data['profileImage'],
            'productName': item.productName,
            'productPrice': item.price,
            'productTotalPrice':
                (item.discountPrice * item.quantity) +
                (item.shippingCharge * item.quantity),
            'productId': item.productId,
            'productImage': item.imageUrl,
            'quantity': item.quantity,
            'productSize': item.productSize,
            'deliverystatus': 'pending',
            'scheduleDate': item.scheduleDate,
            'orderDate': DateTime.now(),
            'paymentStatus': 'Cash on Stripe',
            'accepted': false,
          });

          await FirebaseFirestore.instance.runTransaction((transaction) async {
            final docRef = FirebaseFirestore.instance
                .collection('products')
                .doc(item.productId);
            final snapshot = await transaction.get(docRef);
            transaction.update(docRef, {
              'quantity': snapshot['quantity'] - item.quantity,
            });
          });

          _cartProvider.removeAllItemPlace(item.productId);
        }
        EasyLoading.dismiss();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (Route<dynamic> route) => false,
        );

        // showSnackDialog(
        //   context,
        //   'Order Placed Successfully',
        // );

        // _cartProvider.selectedItems.forEach((item) {
        //   FirebaseFirestore _firestore = FirebaseFirestore.instance;
        //   final orderId = Uuid().v4();
        //   _firestore
        //       .collection('orders')
        //       .doc(orderId)
        //       .set({
        //         'orderId': orderId,
        //         'vendorId': item.vendorId,
        //         'email': data['email'],
        //         'phone': data['phoneNumber'],
        //         'address': data['address'],
        //         'buyerId': data['buyerId'],
        //         'fullName': data['fullName'],
        //         'buyerPhoto': data['profileImage'],
        //         'productName': item.productName,
        //         'productPrice': item.price,
        //         'productTotalPrice':
        //             (item.discountPrice * item.quantity) +
        //             (item.shippingCharge * item.quantity),
        //         'productId': item.productId,
        //         'productImage': item.imageUrl,
        //         'quantity': item.quantity,
        //         'productSize': item.productSize,
        //         'deliverystatus': 'pending',
        //         'scheduleDate': item.scheduleDate,
        //         'orderDate': DateTime.now(),
        //         'paymentStatus': 'Cash on Stripe',
        //         'accepted': false,
        //       })
        //       .whenComplete(() async {
        //         setState(() {
        //           _cartProvider.removeItem(item.productId);
        //           ;
        //         });
        //         EasyLoading.dismiss();

        //         // showSnackDialog(
        //         //   context,
        //         //   'Order Placed Successfully',
        //         // );

        //         await FirebaseFirestore.instance.runTransaction((
        //           transaction,
        //         ) async {
        //           DocumentReference documentReference = FirebaseFirestore
        //               .instance
        //               .collection('products')
        //               .doc(item.productId);
        //           DocumentSnapshot snapshot = await transaction.get(
        //             documentReference,
        //           );
        //           transaction.update(documentReference, {
        //             'quantity': snapshot['quantity'] - item.quantity,
        //           });
        //         });

        //         Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (context) => MainScreen()),
        //           (Route<dynamic> route) => false,
        //         );
        //       });
        // });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  createPaymentIntent(String total, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': total,
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print(body);

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
    }
  }
}
