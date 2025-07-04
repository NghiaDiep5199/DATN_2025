import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_store/views/buyers/productDetail/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    _fetchCategories();
    fetchBrands();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _searchValue = '';
  String _selectedCategory = 'All';
  double _minPrice = 0;
  double _maxPrice = 10000;
  RangeValues _priceRange = RangeValues(0, 10000);
  List<String> _categories = ['All'];

  List<String> _brands = ['All'];
  String _selectedBrand = 'All';
  double _minRating = 0;

  Future<void> _fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    final categorySet = <String>{};

    for (var doc in snapshot.docs) {
      final category = doc['category'];
      if (category != null && category is String && category.isNotEmpty) {
        categorySet.add(category);
      }
    }

    setState(() {
      _categories = ['All', ...categorySet.toList()..sort()];
    });
  }

  Future<void> fetchBrands() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    final brandSet = <String>{};

    for (var doc in snapshot.docs) {
      final brand = doc['brandName'];
      if (brand != null && brand is String && brand.isNotEmpty) {
        brandSet.add(brand);
      }
    }

    setState(() {
      _brands = ['All', ...brandSet.toList()..sort()];
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('products').snapshots();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.blue.shade300),
        ),
        title: TextFormField(
          controller: _searchController,
          focusNode: _focusNode,
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _searchValue = value;

              if (value.isEmpty) {
                _selectedCategory = 'All';
                _selectedBrand = 'All';
                _priceRange = RangeValues(_minPrice, _maxPrice);
                _minRating = 0;
              }
            });
          },
          decoration: InputDecoration(
            hintText: 'Search for products',
            filled: true,
            fillColor: Colors.white, // Màu nền ô search
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
            ),
          ),
        ),
      ),
      body:
          _searchValue == ''
              ? Center(
                child: Text(
                  'Search for products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text("Category: "),
                          SizedBox(width: 10),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              },
                              items:
                                  _categories.map((category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                            ),
                          ),

                          SizedBox(width: 10),
                          Text("Price:"),
                          Expanded(
                            child: RangeSlider(
                              values: _priceRange,
                              min: _minPrice,
                              max: _maxPrice,
                              divisions: 100,
                              labels: RangeLabels(
                                _priceRange.start.round().toString(),
                                _priceRange.end.round().toString(),
                              ),
                              onChanged: (values) {
                                setState(() {
                                  _priceRange = values;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text("Brand: "),
                          SizedBox(width: 15),
                          DropdownButton<String>(
                            value: _selectedBrand,
                            onChanged: (value) {
                              setState(() {
                                _selectedBrand = value!;
                              });
                            },
                            items:
                                _brands.map((brand) {
                                  return DropdownMenuItem(
                                    value: brand,
                                    child: Text(brand),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text("Average rating: "),
                          Expanded(
                            child: Slider(
                              value: _minRating,
                              min: 0,
                              max: 5,
                              divisions: 5,
                              label: _minRating.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _minRating = value;
                                });
                              },
                            ),
                          ),
                          Text('${_minRating.toString()} ★'),
                        ],
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _productsStream,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue.shade300,
                            ),
                          );
                        }

                        final searchData =
                            snapshot.data!.docs.where((element) {
                              final nameMatch = element['productName']
                                  .toLowerCase()
                                  .contains(_searchValue.toLowerCase());

                              final categoryMatch =
                                  _selectedCategory == 'All' ||
                                  element['category'] == _selectedCategory;

                              final brandMatch =
                                  _selectedBrand == 'All' ||
                                  element['brandName'] == _selectedBrand;

                              final price =
                                  element['productPrice'] *
                                  (1 - element['discount'] / 100);
                              final priceMatch =
                                  price >= _priceRange.start &&
                                  price <= _priceRange.end;

                              final rating =
                                  (element['averageRating'] ?? 0).toDouble();
                              final ratingMatch = rating >= _minRating;

                              return nameMatch &&
                                  categoryMatch &&
                                  brandMatch &&
                                  priceMatch &&
                                  ratingMatch;
                            }).toList();

                        if (searchData.isEmpty) {
                          return Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children:
                                searchData.map((e) {
                                  final priceDiscount =
                                      e['productPrice'] *
                                      (1 - e['discount'] / 100);
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ProductDetailScreen(
                                              productData: e,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Container(
                                                color: Colors.white,
                                                child: Image.network(
                                                  e['imageUrl'][0],
                                                  fit: BoxFit.contain,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 3,
                                                      ),
                                                  child: Text(
                                                    e['productName'],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 3,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '\$' +
                                                            priceDiscount
                                                                .toStringAsFixed(
                                                                  2,
                                                                ),
                                                        style: TextStyle(
                                                          color:
                                                              Colors
                                                                  .yellow
                                                                  .shade900,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        '\$' +
                                                            e['productPrice']
                                                                .toStringAsFixed(
                                                                  2,
                                                                ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color:
                                                          Colors.amber.shade700,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      e['averageRating'] == 0
                                                          ? "0"
                                                          : e['averageRating']
                                                              .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
