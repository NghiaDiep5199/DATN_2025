// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_multi_store/views/buyers/productDetail/product_detail_screen.dart';
// import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
// import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

// class HomeProductWidget extends StatelessWidget {
//   final String categoryName;

//   const HomeProductWidget({super.key, required this.categoryName});

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _productsStream =
//         FirebaseFirestore.instance
//             .collection('products')
//             .where('category', isEqualTo: categoryName)
//             .where('approved', isEqualTo: true)
//             .snapshots();

//     return Column(
//       children: [
//         Text('Popular', style: TextStyle(fontSize: 20)),

//         StreamBuilder<QuerySnapshot>(
//           stream: _productsStream,
//           builder: (
//             BuildContext context,
//             AsyncSnapshot<QuerySnapshot> snapshot,
//           ) {
//             if (snapshot.hasError) {
//               return Text('Something went wrong');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Container();
//             }

//             // return Container(
//             //   height: 290,
//             //   child: ListView.separated(
//             //     scrollDirection: Axis.horizontal,
//             //     itemBuilder: (context, index) {
//             //       final productData = snapshot.data!.docs[index];
//             //       return GestureDetector(
//             //         onTap: () {
//             //           Navigator.push(
//             //             context,
//             //             MaterialPageRoute(
//             //               builder: (context) {
//             //                 return ProductDetailScreen(productData: productData);
//             //               },
//             //             ),
//             //           );
//             //         },
//             //         child: Card(
//             //           child: Column(
//             //             children: [
//             //               ClipRRect(
//             //                 borderRadius: BorderRadius.only(
//             //                   topLeft: Radius.circular(15),
//             //                   topRight: Radius.circular(15),
//             //                 ),
//             //                 child: Container(
//             //                   height: 170,
//             //                   width: 200,
//             //                   decoration: BoxDecoration(
//             //                     image: DecorationImage(
//             //                       image: NetworkImage(productData['imageUrl'][0]),
//             //                       fit: BoxFit.cover,
//             //                     ),
//             //                   ),
//             //                 ),
//             //               ),
//             //               Padding(
//             //                 padding: const EdgeInsets.all(4.0),
//             //                 child: Text(
//             //                   productData['productName'],
//             //                   style: TextStyle(
//             //                     fontSize: 18,
//             //                     fontWeight: FontWeight.bold,
//             //                   ),
//             //                 ),
//             //               ),
//             //               Text(
//             //                 '\$ ' + productData['productPrice'].toStringAsFixed(2),
//             //                 style: TextStyle(
//             //                   fontSize: 18,
//             //                   fontWeight: FontWeight.bold,
//             //                   color: Colors.yellow.shade900,
//             //                 ),
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //       );
//             //     },
//             //     separatorBuilder: (context, _) => SizedBox(width: 15),
//             //     itemCount: snapshot.data!.docs.length,
//             //   ),
//             // );

//             return SingleChildScrollView(
//               child: StaggeredGridView.countBuilder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.docs.length,
//                 crossAxisCount: 2,
//                 itemBuilder: (context, index) {
//                   final productData = snapshot.data!.docs[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) {
//                             return ProductDetailScreen(
//                               productData: productData,
//                             );
//                           },
//                         ),
//                       );
//                     },
//                     child: Card(
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                               topRight: Radius.circular(10),
//                             ),
//                             child: Container(
//                               height: 200,
//                               width: 190,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                     productData['imageUrl'][0],
//                                   ),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text(
//                               productData['productName'],
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '\$ ' +
//                                 productData['productPrice'].toStringAsFixed(2),
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.yellow.shade900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
