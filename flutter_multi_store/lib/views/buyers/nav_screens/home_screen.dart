import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import 'package:flutter_multi_store/provider/cart_provider.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/cart_screen.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/widgets/category_widget.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/widgets/main_product_widget.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/widgets/search_input_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 100, 181, 246),
            title: Image.asset('assets/images/logoshop.jpg', height: 60),
            actions: [
              IconButton(
                icon: Badge(
                  showBadge:
                      context.read<CartProvider>().getCartItem.isNotEmpty,
                  badgeStyle: const BadgeStyle(badgeColor: Colors.red),
                  position: BadgePosition.topEnd(top: -12, end: -8),
                  badgeContent: Text(
                    context.watch<CartProvider>().getCartItem.length.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(child: SearchInputWidget()),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BannerWidget(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    bottom: 10.0,
                  ),
                  child: Text('Categories', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),

          // Sticky category
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(child: CategoryWidget()),
          ),

          // Product list
          SliverToBoxAdapter(child: MainProductWidget()),
        ],
      ),
    );
  }
}

// Delegate to make CategoryWidget sticky
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 95;
  @override
  double get maxExtent => 95;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.grey.shade300, // giữ cùng màu nền
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
