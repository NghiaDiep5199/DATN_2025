import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '\OrderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
              'Orders',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
            ),
          ),
          Row(
            children: [
              _rowHeader(1, 'IMAGE'),
              _rowHeader(3, 'FULL NAME'),
              _rowHeader(2, 'ADDRESS'),
              _rowHeader(1, 'ACTION'),
              _rowHeader(1, 'VIEW MORE'),
            ],
          ),
        ],
      ),
    );
  }
}
