import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class DeliveredScreen extends StatefulWidget {
  @override
  State<DeliveredScreen> createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormate.format(date);
    return outPutDate;
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  double rating = 0;

  final TextEditingController _reviewController = TextEditingController();

  Future<void> updateProductReviewStats(String productId) async {
    final productDoc = FirebaseFirestore.instance
        .collection('products')
        .doc(productId);
    final reviewsCollection = productDoc.collection('reviews');

    final querySnapshot = await reviewsCollection.get();

    int totalReviews = querySnapshot.docs.length;
    double totalRating = 0;

    for (final doc in querySnapshot.docs) {
      final rating = doc['rating'];
      if (rating != null) {
        totalRating += rating;
      }
    }

    final averageRating = totalReviews > 0 ? totalRating / totalReviews : 0;

    await productDoc.update({
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream =
        FirebaseFirestore.instance
            .collection('orders')
            .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('deliverystatus', isEqualTo: 'delivered')
            .snapshots();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,

      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade300),
            );
          }

          return snapshot.data!.docs.isNotEmpty
              ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final document = snapshot.data!.docs[index];
                  final accepted = document['accepted'] == true;
                  final orderId = document['orderId'];
                  final orderDate = formatedDate(
                    document['orderDate'].toDate(),
                  );
                  final statusText = document['deliverystatus'];

                  return Column(
                    children: [
                      SizedBox(height: 5),
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      color: Colors.white,
                                      child: Image.network(
                                        document['productImage'][0],
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order #${orderId.substring(orderId.length - 10)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text('Order date: ' + orderDate),
                                        SizedBox(height: 4),
                                        Container(
                                          child: Text(
                                            capitalizeFirstLetter(statusText),
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$' +
                                            '${document['productTotalPrice'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow.shade900,
                                        ),
                                      ),
                                      document['deliverystatus'] == 'delivered'
                                          ? ElevatedButton(
                                            onPressed: () async {
                                              final productId =
                                                  document['productId'];

                                              showDialog(
                                                context: context,
                                                builder: (
                                                  BuildContext context,
                                                ) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Conform review',
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              _reviewController,
                                                          decoration:
                                                              InputDecoration(
                                                                labelText:
                                                                    'Your review',
                                                              ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: RatingBar.builder(
                                                            initialRating:
                                                                rating,
                                                            direction:
                                                                Axis.horizontal,
                                                            minRating: 1,
                                                            maxRating: 5,
                                                            allowHalfRating:
                                                                true,
                                                            itemSize: 25,
                                                            itemCount: 5,
                                                            itemPadding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 3,
                                                                ),
                                                            itemBuilder: (
                                                              context,
                                                              _,
                                                            ) {
                                                              return const Icon(
                                                                Icons.star,
                                                                color:
                                                                    Colors
                                                                        .amber,
                                                              );
                                                            },
                                                            onRatingUpdate: (
                                                              value,
                                                            ) {
                                                              rating = value;
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          final review =
                                                              _reviewController
                                                                  .text;

                                                          CollectionReference
                                                          collRef =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                    'products',
                                                                  )
                                                                  .doc(
                                                                    document['productId'],
                                                                  )
                                                                  .collection(
                                                                    'reviews',
                                                                  );

                                                          await collRef
                                                              .doc(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                              )
                                                              .set({
                                                                'productId':
                                                                    document['productId'],
                                                                'fullName':
                                                                    document['fullName'],
                                                                'email':
                                                                    document['email'],
                                                                'buyerId':
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid,
                                                                'rating':
                                                                    rating,
                                                                'review':
                                                                    review,
                                                                'buyerPhoto':
                                                                    document['buyerPhoto'],
                                                                'timeStamp':
                                                                    Timestamp.now(),
                                                              })
                                                              .whenComplete(
                                                                () async {
                                                                  updateProductReviewStats(
                                                                    productId,
                                                                  );
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop();
                                                                  _reviewController
                                                                      .clear();
                                                                  rating = 0;
                                                                },
                                                              );
                                                        },
                                                        child: Text(
                                                          'Submit',
                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .blue
                                                                    .shade300,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },

                                            child: Text(
                                              'Review',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              ExpansionTile(
                                title: Text(
                                  'Order details',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                children: [
                                  ListTile(
                                    title: Text(
                                      document['productName'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Quantity:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'x' +
                                                  document['quantity']
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Payment:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              document['paymentStatus']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (accepted)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Scheduled delivery date:'),
                                              Text(
                                                formatedDate(
                                                  document['scheduleDate']
                                                      .toDate(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ListTile(
                                          title: Text(
                                            '------------------Buyer details----------------',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name: ${document['fullName']}',
                                              ),
                                              Text(
                                                'Phone: ${document['phone']}',
                                              ),
                                              Text(
                                                'Email: ${document['email']}',
                                              ),
                                              Text(
                                                'Address: ${document['address']}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
        },
      ),
    );
  }
}
