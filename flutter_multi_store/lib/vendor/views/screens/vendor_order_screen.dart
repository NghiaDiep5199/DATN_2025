// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:intl/intl.dart';

// class OrdersScreen extends StatelessWidget {
//   String formatedDate(date) {
//     final outPutDateFormate = DateFormat('dd/MM/yyyy');

//     final outPutDate = outPutDateFormate.format(date);

//     return outPutDate;
//   }

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _ordersStream =
//         FirebaseFirestore.instance
//             .collection('orders')
//             .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//             .snapshots();
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.black),
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.yellow.shade900, Colors.blue],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//           ),
//         ),
//         title: Text(
//           'All Orders',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _ordersStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(color: Colors.yellow.shade900),
//             );
//           }

//           return ListView(
//             children:
//                 snapshot.data!.docs.map((DocumentSnapshot document) {
//                   return Slidable(
//                     child: Column(
//                       children: [
//                         ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Colors.white,
//                             radius: 15,
//                             child:
//                                 document['accepted'] == true
//                                     ? Icon(Icons.delivery_dining)
//                                     : Icon(Icons.access_time),
//                           ),
//                           title:
//                               document['accepted'] == true
//                                   ? Text(
//                                     'Accepted',
//                                     style: TextStyle(
//                                       color: Colors.green,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )
//                                   : Text(
//                                     'Not Accepted',
//                                     style: TextStyle(
//                                       color: Colors.red,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                           trailing: Text(
//                             'Amount: ' +
//                                 document['productPrice'].toStringAsFixed(2),
//                             style: TextStyle(
//                               color: Colors.cyan,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           subtitle: Text(
//                             formatedDate(document['orderDate'].toDate()),
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         ExpansionTile(
//                           title: Text(
//                             'Order Details',
//                             style: TextStyle(
//                               color: Colors.yellow.shade900,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           subtitle: Text('View Order Details'),
//                           children: [
//                             ListTile(
//                               leading: CircleAvatar(
//                                 child: Image.network(
//                                   document['productImage'][0],
//                                 ),
//                               ),
//                               title: Text(
//                                 document['productName'],
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Text(
//                                         'Quantiy:',
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         document['quantity'].toString(),
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   document['accepted'] == true
//                                       ? Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           Text('Schedule deliver date:'),
//                                           Text(
//                                             formatedDate(
//                                               document['scheduleDate'].toDate(),
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                       : Text(''),
//                                   ListTile(
//                                     title: Text(
//                                       'Buyer Details',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     subtitle: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text('Name: ' + document['fullName']),
//                                         Text('Email: ' + document['email']),
//                                         Text('Address: ' + document['address']),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     startActionPane: ActionPane(
//                       motion: const ScrollMotion(),
//                       children: [
//                         SlidableAction(
//                           onPressed: (context) async {
//                             await _firestore
//                                 .collection('orders')
//                                 .doc(document['orderId'])
//                                 .update({'accepted': true});
//                           },
//                           backgroundColor: Colors.yellow.shade900,
//                           foregroundColor: Colors.white,
//                           icon: Icons.check,
//                           label: 'Accept',
//                         ),
//                         SlidableAction(
//                           onPressed: (context) async {
//                             await _firestore
//                                 .collection('orders')
//                                 .doc(document['orderId'])
//                                 .update({'accepted': false});
//                           },
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           icon: Icons.cancel,
//                           label: 'Reject',
//                         ),
//                       ],
//                     ),
//                     endActionPane: ActionPane(
//                       motion: ScrollMotion(),
//                       children: [
//                         SlidableAction(
//                           flex: 2,
//                           onPressed: (context) {},
//                           backgroundColor: Color(0xFF7BC043),
//                           foregroundColor: Colors.white,
//                           icon: Icons.archive,
//                           label: 'Archive',
//                         ),
//                         SlidableAction(
//                           onPressed: (context) {},
//                           backgroundColor: Color(0xFF0392CF),
//                           foregroundColor: Colors.white,
//                           icon: Icons.save,
//                           label: 'Save',
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class OrdersScreen extends StatelessWidget {
//   String formatedDate(date) {
//     final outPutDateFormate = DateFormat('dd/MM/yyyy');
//     final outPutDate = outPutDateFormate.format(date);
//     return outPutDate;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _ordersStream =
//         FirebaseFirestore.instance
//             .collection('orders')
//             .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//             .snapshots();

//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.black),
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(color: Colors.blue.shade300),
//         ),
//         title: Text(
//           'All orders',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _ordersStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Something went wrong'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(color: Colors.yellow.shade900),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final document = snapshot.data!.docs[index];
//               final accepted = document['accepted'] == true;
//               final orderId = document['orderId'];
//               final orderDate = formatedDate(document['orderDate'].toDate());
//               // final statusColor = accepted ? Colors.green : Colors.orange;

//               final statusText = document['deliverystatus'];

//               return Column(
//                 children: [
//                   SizedBox(height: 5),
//                   Card(
//                     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               CachedNetworkImage(
//                                 imageUrl: document['productImage'][0],
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Order #${orderId.substring(orderId.length - 10)}',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text('Order date: ' + orderDate),
//                                     SizedBox(height: 4),
//                                     Container(
//                                       child: Text(
//                                         statusText,
//                                         style: TextStyle(
//                                           color: Colors.blue,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     '\$' +
//                                         '${document['productPrice'].toStringAsFixed(2)}',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {},
//                                     child: Text(
//                                       'Cancel order',
//                                       style: TextStyle(color: Colors.blue),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           ExpansionTile(
//                             title: Text(
//                               'Order details',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),

//                             children: [
//                               ListTile(
//                                 title: Text(
//                                   document['productName'],
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           'Quantity:',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           'x' + document['quantity'].toString(),
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     if (accepted)
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text('Scheduled delivery date:'),
//                                           Text(
//                                             formatedDate(
//                                               document['scheduleDate'].toDate(),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ListTile(
//                                       title: Text(
//                                         '------------------Buyer details----------------',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       subtitle: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text('Name: ${document['fullName']}'),
//                                           Text('Phone: ${document['phone']}'),
//                                           Text('Email: ${document['email']}'),
//                                           Text(
//                                             'Address: ${document['address']}',
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_multi_store/vendor/views/screens/vendor_order_detail_screens/vendor_accepted_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/vendor_order_detail_screens/vendor_cancelled_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/vendor_order_detail_screens/vendor_delivered_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/vendor_order_detail_screens/vendor_pending_screen.dart';
import 'package:flutter_multi_store/vendor/views/screens/vendor_order_detail_screens/vendor_shipping_screen.dart';

class VendorOrderScreen extends StatelessWidget {
  const VendorOrderScreen({super.key});

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
          bottom: TabBar(
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
            VendorPendingScreen(),
            VendorAcceptedScreen(),
            VendorShippingScreen(),
            VendorDeliveredScreen(),
            VendorCancelledScreen(),
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
          color: Colors.white,
          fontFamily: 'Brand-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
