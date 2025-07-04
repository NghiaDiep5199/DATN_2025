import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_store/provider/product_provider.dart';
import 'package:flutter_multi_store/utils/show_snackBar.dart';
import 'package:flutter_multi_store/vendor/views/screens/main_vendor_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/upload_tab_screens/attributes_tab_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/upload_tab_screens/general_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/upload_tab_screens/shipping_price_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider = Provider.of<ProductProvider>(
      context,
    );
    return DefaultTabController(
      length: 4,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            flexibleSpace: Container(
              decoration: BoxDecoration(color: Colors.blue.shade300),
            ),
            title: Text(
              'Upload Products',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.blue,
              indicatorWeight: 1,
              tabs: [
                Tab(
                  child: Text(
                    'General',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Shipping',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Attributes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Images',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GeneralScreen(),
              ShippingPriceScreen(),
              AttributesTabScreen(),
              ImagesTabScreen(),
            ],
          ),
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                  ),
                  onPressed: () async {
                    // EasyLoading.show(status: 'Please wait...');
                    if (_formKey.currentState!.validate()) {
                      final productId = Uuid().v4();
                      final averageRating = 0;
                      await _firestore
                          .collection('products')
                          .doc(productId)
                          .set({
                            'productId': productId,
                            'productName':
                                _productProvider.productData['productName'],
                            'productPrice':
                                _productProvider.productData['productPrice'],
                            'quantity':
                                _productProvider.productData['quantity'],
                            'category':
                                _productProvider.productData['category'],
                            'description':
                                _productProvider.productData['description'],
                            'imageUrl':
                                _productProvider.productData['imageUrlList'],
                            'scheduleDate':
                                _productProvider.productData['scheduleDate'],
                            'chargeShipping':
                                _productProvider.productData['chargeShipping'],
                            'discount':
                                _productProvider.productData['discount'],
                            'shippingCharge':
                                _productProvider.productData['shippingCharge'],
                            'brandName':
                                _productProvider.productData['brandName'],
                            'sizeList':
                                _productProvider.productData['sizeList'],
                            'vendorId': FirebaseAuth.instance.currentUser!.uid,
                            'averageRating': averageRating,
                            'approved': false,
                          })
                          .whenComplete(() {
                            _productProvider.clearData();
                            _formKey.currentState!.reset();
                            EasyLoading.dismiss();
                            showSnackDialog(context, 'Upload successful');
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return MainVendorScreen();
                            //     },
                            //   ),
                            // );
                          });
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainVendorScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
