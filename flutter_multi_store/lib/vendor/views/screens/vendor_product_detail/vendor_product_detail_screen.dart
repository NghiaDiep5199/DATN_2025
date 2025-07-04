import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_store/provider/product_provider.dart';
import 'package:flutter_multi_store/utils/show_snackBar.dart';
import 'package:provider/provider.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const VendorProductDetailScreen({super.key, required this.productData});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDiscountController =
      TextEditingController();
  final TextEditingController _productDescreiptionController =
      TextEditingController();

  final List<String> _categoryList = [];
  _getCategories() {
    return _firestore.collection('categories').get().then((
      QuerySnapshot querySnapshot,
    ) {
      querySnapshot.docs.forEach((doc) {
        if (mounted) {
          setState(() {
            _categoryList.add(doc['categoryName']);
          });
        }
      });
    });
  }

  @override
  void initState() {
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _brandNameController.text = widget.productData['brandName'];
      _quantityController.text = widget.productData['quantity'].toString();
      _productPriceController.text = widget.productData['productPrice']
          .toStringAsFixed(2);
      _productDiscountController.text =
          widget.productData['discount'].toString();
      _productDescreiptionController.text = widget.productData['description'];
      selectedCategory = widget.productData['category'];
    });
    _getCategories();
    super.initState();
  }

  double? productPrice;
  String? selectedCategory;
  int? productQuantity;
  int? productDiscount;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider = Provider.of<ProductProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.blue.shade300),
        ),
        title: Text(
          widget.productData['productName'],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              // Container(
              //   height: 120,
              //   width: 120,
              //   child: Image.network(widget.productData['imageUrl'][0]),
              // ),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _brandNameController,
                decoration: InputDecoration(labelText: 'Brand Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  try {
                    final cleanedValue = value.replaceAll(
                      RegExp(r'[^0-9]'),
                      '',
                    );
                    if (cleanedValue.isNotEmpty) {
                      productQuantity = int.parse(cleanedValue);
                    } else {
                      productQuantity = 0;
                    }
                  } catch (e) {
                    productQuantity = 0;
                    print('Invalid quantity input: $e');
                  }
                },
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  try {
                    final cleanedValue = value.replaceAll(
                      RegExp(r'[^0-9.]'),
                      '',
                    );
                    if (cleanedValue.isNotEmpty) {
                      productPrice = double.parse(cleanedValue);
                    } else {
                      productPrice = 0.0;
                    }
                  } catch (e) {
                    productPrice = 0.0;
                    print('Invalid price input: $e');
                  }
                },
                controller: _productPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Product Price'),
              ),

              TextFormField(
                onChanged: (value) {
                  try {
                    final cleanedValue = value.replaceAll(
                      RegExp(r'[^0-9.]'),
                      '',
                    );
                    if (cleanedValue.isNotEmpty) {
                      productDiscount = int.parse(cleanedValue);
                    } else {
                      productDiscount = 0;
                    }
                  } catch (e) {
                    productDiscount = 0;
                    print('Invalid price input: $e');
                  }
                },
                controller: _productDiscountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Product Discount %'),
              ),

              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                hint: Text('Select Category'),
                value: selectedCategory,
                items:
                    _categoryList.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    _productProvider.getFormData(
                      category: value,
                    ); // nếu bạn cần
                  });
                },
              ),
              // TextFormField(
              //   enabled: false,
              //   controller: _categoryNameController,
              //   decoration: InputDecoration(labelText: 'Category'),
              // ),
              SizedBox(height: 10),
              TextFormField(
                maxLength: 1000,
                maxLines: 5,
                controller: _productDescreiptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: InkWell(
                  onTap: () async {
                    try {
                      final quantityText = _quantityController.text.replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      );
                      productQuantity =
                          quantityText.isNotEmpty
                              ? int.parse(quantityText)
                              : widget.productData['quantity'];
                    } catch (e) {
                      productQuantity = widget.productData['quantity'];
                    }

                    try {
                      final priceText = _productPriceController.text.replaceAll(
                        RegExp(r'[^0-9.]'),
                        '',
                      );
                      productPrice =
                          priceText.isNotEmpty
                              ? double.parse(priceText)
                              : widget.productData['productPrice'];
                    } catch (e) {
                      productPrice = widget.productData['productPrice'];
                    }

                    try {
                      final discountText = _productDiscountController.text
                          .replaceAll(RegExp(r'[^0-9.]'), '');
                      productDiscount =
                          discountText.isNotEmpty
                              ? int.parse(discountText)
                              : widget.productData['discount'];
                    } catch (e) {
                      productDiscount = widget.productData['discount'];
                    }

                    await _firestore
                        .collection('products')
                        .doc(widget.productData['productId'])
                        .update({
                          'productName': _productNameController.text,
                          'brandName': _brandNameController.text,
                          'quantity': productQuantity,
                          'productPrice': productPrice,
                          'discount': productDiscount,
                          'description': _productDescreiptionController.text,
                          'category': selectedCategory,
                        })
                        .whenComplete(() {
                          EasyLoading.dismiss();
                          showSnackDialog(context, 'Update successful');
                          Navigator.pop(context);
                        });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
