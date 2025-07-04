// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';

// class BannerWidget extends StatefulWidget {
//   @override
//   State<BannerWidget> createState() => _BannerWidgetState();
// }

// class _BannerWidgetState extends State<BannerWidget> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final List<String> _bannerImage = [];

//   late PageController _pageController;
//   int _currentPage = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//     getBanners();
//   }

//   getBanners() async {
//     final querySnapshot = await _firestore.collection('banners').get();
//     if (mounted) {
//       setState(() {
//         _bannerImage.addAll(
//           querySnapshot.docs.map((doc) => doc['image'].toString()).toList(),
//         );
//       });
//       _startAutoScroll();
//     }
//   }

//   void _startAutoScroll() {
//     _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
//       if (_bannerImage.isNotEmpty && _pageController.hasClients) {
//         _currentPage++;
//         if (_currentPage >= _bannerImage.length) {
//           _currentPage = 0;
//         }
//         _pageController.animateToPage(
//           _currentPage,
//           duration: Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3),
//       child: Container(
//         height: 140,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.blue.shade100,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child:
//             _bannerImage.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : PageView.builder(
//                   controller: _pageController,
//                   itemCount: _bannerImage.length,
//                   itemBuilder: (context, index) {
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: CachedNetworkImage(
//                         imageUrl: _bannerImage[index],
//                         fit: BoxFit.cover,
//                         progressIndicatorBuilder:
//                             (context, url, downloadProgress) => Shimmer(
//                               duration: Duration(seconds: 3),
//                               interval: Duration(seconds: 5),
//                               color: Colors.white,
//                               colorOpacity: 0,
//                               enabled: true,
//                               direction: ShimmerDirection.fromLTRB(),
//                               child: Container(color: Colors.blue.shade100),
//                             ),
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                       ),
//                     );
//                   },
//                 ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _bannerImage = [];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    getBanners();
  }

  getBanners() async {
    final querySnapshot = await _firestore.collection('banners').get();
    if (mounted) {
      setState(() {
        _bannerImage.addAll(
          querySnapshot.docs.map((doc) => doc['image'].toString()).toList(),
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            _bannerImage.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _bannerImage.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: _bannerImage[index],
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Shimmer(
                              duration: Duration(seconds: 0),
                              interval: Duration(seconds: 0),
                              color: Colors.white,
                              colorOpacity: 0,
                              enabled: true,
                              direction: ShimmerDirection.fromLTRB(),
                              child: Container(color: Colors.blue.shade100),
                            ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
