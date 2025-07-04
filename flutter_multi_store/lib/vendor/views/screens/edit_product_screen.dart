import 'package:flutter/material.dart';
import 'package:flutter_multi_store/vendor/views/screens/edit_products_tabs/published_tab.dart';
import 'package:flutter_multi_store/vendor/views/screens/edit_products_tabs/unpublished_tab.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(color: Colors.blue.shade300),
          title: Text(
            'Manager Products',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            indicatorWeight: 1,
            tabs: [
              Tab(
                child: Text(
                  'Published',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Unpublished',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [PublishedTab(), UnPublishedTab()]),
      ),
    );
  }
}
