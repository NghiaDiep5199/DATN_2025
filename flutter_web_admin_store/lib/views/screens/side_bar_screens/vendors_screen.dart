import 'package:flutter/material.dart';
import 'package:flutter_web_admin_store/views/widgets/vendors_list.dart';

class VendorScreen extends StatefulWidget {
  static const String routeName = '\VendorScreen';

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
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
              'Manage Vendors',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
            ),
          ),
          // SizedBox(height: 15),
          Row(
            children: [
              _rowHeader(1, 'LOGO'),
              _rowHeader(2, 'BUSSINESS NAME'),
              _rowHeader(2, 'CITY'),
              _rowHeader(2, 'STATE'),
              _rowHeader(1, 'ACTION'),
              _rowHeader(1, 'VIEW MORE'),
            ],
          ),
          VendorsList(),
        ],
      ),
    );
  }
}
