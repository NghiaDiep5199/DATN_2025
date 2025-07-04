import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_store/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GeneralScreen extends StatefulWidget {
  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    _getCategories();
    super.initState();
  }

  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = Provider.of<ProductProvider>(
      context,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _productProvider.getFormData(productName: value);
                },
                decoration: InputDecoration(labelText: 'Enter Product Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Price';
                  }
                  return null;
                },
                onChanged: (value) {
                  String cleaned = value.replaceAll(',', '.').trim();
                  double? parsed = double.tryParse(cleaned);

                  if (parsed != null) {
                    _productProvider.getFormData(productPrice: parsed);
                  } else {
                    print('Invalid: $value');
                  }
                },
                decoration: InputDecoration(labelText: 'Enter Product Price'),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Quantity';
                  }
                  return null;
                },
                onChanged: (value) {
                  String cleaned = value.trim();
                  int? quantity = int.tryParse(cleaned);

                  if (quantity != null) {
                    _productProvider.getFormData(quantity: quantity);
                  } else {
                    print('Invalid: $value');
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product Quantity',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Discount %';
                  }
                  return null;
                },
                onChanged: (value) {
                  String cleaned = value.trim();
                  int? discount = int.tryParse(cleaned);

                  if (discount != null) {
                    _productProvider.getFormData(discount: discount);
                  } else {
                    print('Invalid: $value');
                  }
                },
                decoration: InputDecoration(labelText: 'Enter Discount %'),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                hint: Text('Select Category'),
                items:
                    _categoryList.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _productProvider.getFormData(category: value);
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Description';
                  }
                  return null;
                },
                onChanged: (value) {
                  _productProvider.getFormData(description: value);
                },
                maxLines: 5,
                maxLength: 1000,
                decoration: InputDecoration(
                  labelText: 'Enter Product Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(5000),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            _productProvider.getFormData(scheduleDate: value);
                          });
                        }
                      });
                    },
                    child: Text('Schedule', style: TextStyle(fontSize: 15)),
                  ),
                  if (_productProvider.productData['scheduleDate'] != null)
                    Text(
                      formatedDate(
                        _productProvider.productData['scheduleDate'],
                      ),
                      style: TextStyle(fontSize: 15),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
