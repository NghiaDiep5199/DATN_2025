import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_store/vendor/views/screens/earnings_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/edit_product_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/upload_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/vendor_profile_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/vendor_order_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  // ignore: unused_field
  int _pageIndex = 0;

  // ignore: unused_field
  List<Widget> _pages = [
    EarningsScreen(),
    UploadScreen(),
    EditProductScreen(),
    VendorOrderScreen(),
    VendorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        // type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },

        items: [
          SalomonBottomBarItem(
            icon: Icon(CupertinoIcons.money_dollar, color: Colors.black),
            title: Text('Earning'),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.upload),
            title: Text('Upload'),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.edit),
            title: Text('Edit'),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Order'),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
            selectedColor: Colors.blue,
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
