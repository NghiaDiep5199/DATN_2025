import 'package:flutter/material.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/order_detail_screens/accepted_screen.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/order_detail_screens/cancelled_screen.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/order_detail_screens/delivered_screen.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/order_detail_screens/pending_screen.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/order_detail_screens/shipping_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Colors.blue.shade300),
          ),
          title: Text(
            'All orders',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue,
            indicatorWeight: 1,
            tabAlignment: TabAlignment.start,
            tabs: [
              RepeatedTab(label: 'Pending'),
              RepeatedTab(label: 'Accepted'),
              RepeatedTab(label: 'Shippping'),
              RepeatedTab(label: 'Delivered'),
              RepeatedTab(label: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingScreen(),
            AcceptedScreen(),
            ShippingScreen(),
            DeliveredScreen(),
            CancelledScreen(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontFamily: 'Brand-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
