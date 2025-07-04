// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CategoryListWidget extends StatelessWidget {
//   const CategoryListWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _categoryStream =
//         FirebaseFirestore.instance.collection('categories').snapshots();

//     return StreamBuilder<QuerySnapshot>(
//       stream: _categoryStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Material(
//             child: CircularProgressIndicator(color: Colors.yellow.shade900),
//           );
//         }

//         if (snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Text(
//               'No Categories\n Added yet',
//               style: TextStyle(color: Colors.blueGrey, fontSize: 30),
//             ),
//           );
//         }
//         return GridView.builder(
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 6,
//             mainAxisSpacing: 8,
//             crossAxisSpacing: 8,
//           ),
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             var data = snapshot.data!.docs[index];

//             return Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     SizedBox(
//                       height: 100,
//                       width: 100,
//                       child: Image.network(
//                         data['image'],
//                         width: double.infinity,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(data['categoryName']),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _bannerStream =
        FirebaseFirestore.instance.collection('categories').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _bannerStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.orange.shade800),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No categories added yet',
              style: TextStyle(color: Colors.blueGrey, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index];

            return GestureDetector(
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                          'Are you sure you want to delete this category?',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                );

                if (confirm == true) {
                  try {
                    final imageUrl = data['image'];
                    final docId = data.id;

                    // Delete image from Firebase Storage
                    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
                    await ref.delete();

                    // Delete document from Firestore
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(docId)
                        .delete();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Banner deleted successfully'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting banner: $e')),
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(data['image']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data['categoryName']),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tap to delete',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
