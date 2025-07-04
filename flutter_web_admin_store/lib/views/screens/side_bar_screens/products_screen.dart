import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = '\ProductsScreen';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Widget _rowHeader(int flex, String text) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Products',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
            ),
          ),
          Row(
            children: [
              _rowHeader(1, 'IMAGE'),
              _rowHeader(3, 'NAME'),
              _rowHeader(2, 'PRICE'),
              _rowHeader(2, 'QUANTITY'),
              _rowHeader(1, 'ACTION'),
              _rowHeader(1, 'VIEW MORE'),
            ],
          ),
        ],
      ),
    );
  }
}
