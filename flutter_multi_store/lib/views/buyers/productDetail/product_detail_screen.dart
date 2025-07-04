import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import 'package:flutter_multi_store/provider/cart_provider.dart';
import 'package:flutter_multi_store/utils/show_snackBar.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/cart_screen.dart';
import 'package:flutter_multi_store/views/buyers/productDetail/store_detail_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: widget.productData['category'])
          .snapshots();

  late final Stream<QuerySnapshot> reviewsStream =
      FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productData['productId'])
          .collection('reviews')
          .snapshots();

  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  int _imageIndex = 0;
  String? _selectedSize;
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final priceDiscount =
        widget.productData['productPrice'] *
        (1 - widget.productData['discount'] / 100);
    var onSale = widget.productData['discount'];
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.blue.shade300),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.productData['productName'],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: PhotoView(
                    imageProvider: NetworkImage(
                      widget.productData['imageUrl'][_imageIndex],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData['imageUrl'].length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _imageIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              height: 60,
                              width: 60,
                              child: Image.network(
                                widget.productData['imageUrl'][index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '\$${priceDiscount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(245, 127, 23, 1),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '\$${widget.productData['productPrice'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 202, 155),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '- ${widget.productData['discount'].toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.yellow.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.productData['productName'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.productData['averageRating'] != 0) ...[
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        Text(
                          widget.productData['averageRating'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '(${widget.productData['totalReviews']})',
                          style: TextStyle(letterSpacing: 1.5, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                  Text(
                    widget.productData['quantity'] == 0
                        ? 'This item is out of stock'
                        : '${widget.productData['quantity']} items available in stock',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available from:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    formatedDate(widget.productData['scheduleDate'].toDate()),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'Product Description',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Text(
                    '${widget.productData['description']}',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),

            if (widget.productData['sizeList'] != null &&
                widget.productData['sizeList'].isNotEmpty)
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'Available Sizes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 10,
                      top: 10,
                    ),
                    child:
                        widget.productData['sizeList'] != null &&
                                widget.productData['sizeList'].isNotEmpty
                            ? ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.productData['sizeList'].length,
                              separatorBuilder: (_, __) => SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final size =
                                    widget.productData['sizeList'][index];
                                final isSelected = _selectedSize == size;
                                return OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedSize = size;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        isSelected
                                            ? Colors.blue.shade300
                                            : Colors.white,
                                    side: BorderSide(
                                      color:
                                          isSelected
                                              ? Colors.blue.shade700
                                              : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            )
                            : Center(child: Text("No sizes available")),
                  ),
                ],
              ),

            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'Reviews',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: reviews(reviewsStream),
                ),
              ],
            ),

            StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LinearProgressIndicator(color: Colors.blue.shade900),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 12,
                      ),
                      child: Text(
                        'Recommended Items',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: StaggeredGridView.countBuilder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemBuilder: (context, index) {
                          final productData = snapshot.data!.docs[index];
                          final priceDiscount =
                              productData['productPrice'] *
                              (1 - productData['discount'] / 100);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductDetailScreen(
                                      productData: productData,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: Colors.black12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        color: Colors.white,
                                        child: Image.network(
                                          productData['imageUrl'][0],
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      10,
                                      10,
                                      4,
                                    ),
                                    child: Text(
                                      productData['productName'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '\$${priceDiscount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange.shade900,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '\$${productData['productPrice'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      4,
                                      10,
                                      10,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber.shade700,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          productData['averageRating'] == 0
                                              ? "0"
                                              : productData['averageRating']
                                                  .toString(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder:
                            (context) => const StaggeredTile.fit(1),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(14.0),
        child: InkWell(
          onTap:
              _cartProvider.getCartItem.containsKey(
                    widget.productData['productId'],
                  )
                  ? null
                  : () {
                    final sizeList = widget.productData['sizeList'];

                    if ((sizeList != null && sizeList.isNotEmpty) &&
                        _selectedSize == null) {
                      return showSnack(context, 'Please select a size');
                    } else {
                      _cartProvider.addProductToCart(
                        widget.productData['productName'],
                        widget.productData['productId'],
                        widget.productData['imageUrl'],
                        1,
                        widget.productData['quantity'],
                        onSale != 0
                            ? ((1 - (onSale / 100)) *
                                widget.productData['productPrice'])
                            : widget.productData['productPrice'],
                        (widget.productData['productPrice'] as num).toDouble(),
                        (widget.productData['shippingCharge'] as num)
                            .toDouble(),
                        widget.productData['vendorId'],
                        _selectedSize ?? '',
                        widget.productData['scheduleDate'],
                      );

                      return showSnackDialog(
                        context,
                        'You added ${widget.productData['productName']} to your cart',
                      );
                    }
                  },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/shop.svg', width: 24),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => StoreDetailScreen(
                              storeData: widget.productData['vendorId'],
                            ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  icon: Badge(
                    showBadge:
                        context.read<CartProvider>().getCartItem.isNotEmpty,
                    badgeStyle: const BadgeStyle(badgeColor: Colors.red),
                    position: BadgePosition.topEnd(top: -12, end: -8),
                    badgeContent: Text(
                      context
                          .watch<CartProvider>()
                          .getCartItem
                          .length
                          .toString(),
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
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:
                        _cartProvider.getCartItem.containsKey(
                              widget.productData['productId'],
                            )
                            ? Text(
                              'In cart',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                            : Text(
                              'Add to cart',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget reviews(var reviewsStream) {
  return Container(child: reviewsAll(reviewsStream));
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text(
            'This item \n has no reviews yet !',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontFamily: 'Acme',
              letterSpacing: 1.5,
            ),
          ),
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                snapshot.data!.docs[index]['buyerPhoto'],
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(snapshot.data!.docs[index]['fullName']),
                Row(
                  children: [
                    Text(
                      snapshot.data!.docs[index]['rating'].toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                  ],
                ),
              ],
            ),
            subtitle: Text(snapshot.data!.docs[index]['review']),
          );
        },
      );
    },
  );
}
