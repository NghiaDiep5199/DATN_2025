import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_web_admin_store/views/screens/side_bar_screens/categories_screen.dart';
import 'package:flutter_web_admin_store/views/screens/side_bar_screens/upload_banner_screen.dart';
import 'package:flutter_web_admin_store/views/screens/side_bar_screens/users_screen.dart';
import 'package:flutter_web_admin_store/views/screens/side_bar_screens/vendors_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = VendorScreen();

  screenSlector(item) {
    switch (item.route) {
      case VendorScreen.routeName:
        setState(() {
          _selectedItem = VendorScreen();
        });
        break;
      case UsersScreen.routeName:
        setState(() {
          _selectedItem = UsersScreen();
        });
        break;
      // case OrderScreen.routeName:
      //   setState(() {
      //     _selectedItem = OrderScreen();
      //   });
      //   break;
      case CategoriesScreen.routeName:
        setState(() {
          _selectedItem = CategoriesScreen();
        });
        break;
      // case ProductsScreen.routeName:
      //   setState(() {
      //     _selectedItem = ProductsScreen();
      //   });
      //   break;
      case UploadBannerScreen.routeName:
        setState(() {
          _selectedItem = UploadBannerScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text('Management'),
      ),
      sideBar: SideBar(
        items: [
          // AdminMenuItem(
          //   title: 'Dashboard',
          //   icon: Icons.dashboard,
          //   route: DashboardScreen.routeName,
          // ),
          AdminMenuItem(
            title: 'Vendors',
            icon: CupertinoIcons.person_3,
            route: VendorScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Users',
            icon: CupertinoIcons.person,
            route: UsersScreen.routeName,
          ),
          // AdminMenuItem(
          //   title: 'Withdrawal',
          //   icon: CupertinoIcons.money_dollar,
          //   route: WithdrawalScreen.routeName,
          // ),
          // AdminMenuItem(
          //   title: 'Orders',
          //   icon: CupertinoIcons.shopping_cart,
          //   route: OrderScreen.routeName,
          // ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category,
            route: CategoriesScreen.routeName,
          ),
          // AdminMenuItem(
          //   title: 'Products',
          //   icon: Icons.shop,
          //   route: ProductsScreen.routeName,
          // ),
          AdminMenuItem(
            title: 'Upload Banners',
            icon: CupertinoIcons.add,
            route: UploadBannerScreen.routeName,
          ),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSlector(item);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: Colors.blue.shade200,
          child: const Center(
            child: Text(
              'Web Admin Store',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: Colors.blue.shade200,
          child: const Center(
            child: Text(
              'Web Admin Store',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ),
      body: _selectedItem,
    );
  }
}
