import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/chat_bot_ai_screen.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/account_screen.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/category_screen.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/home_screen.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/store_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    CategoryScreen(),
    StoreScreen(),
    // CartScreen(),
    // SearchScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        // type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },

        items: [
          SalomonBottomBarItem(
            icon: Icon(CupertinoIcons.home, size: 22, color: Colors.black),
            title: Text('Home'),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: SvgPicture.asset('assets/icons/explore.svg', width: 24),
            title: Text('Categories'),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: SvgPicture.asset('assets/icons/shop.svg', width: 24),
            title: Text('Store'),
            selectedColor: Colors.blue,
          ),
          // BottomNavigationBarItem(
          //   icon: SvgPicture.asset('assets/icons/cart.svg', width: 21),
          //   label: 'Cart',
          // ),
          // BottomNavigationBarItem(
          //   icon: SvgPicture.asset('assets/icons/search.svg', width: 21),
          //   label: 'Search',
          // ),
          SalomonBottomBarItem(
            icon: SvgPicture.asset('assets/icons/account.svg', width: 18),
            title: Text('Profile'),
            selectedColor: Colors.blue,
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     try {
      //       dynamic conversationObject = {
      //         'appId': '1d77836ed830953841092a343bdfef08f',
      //       };
      //       dynamic result = await KommunicateFlutterPlugin.buildConversation(
      //         conversationObject,
      //       );
      //       print("Conversation builder success :" + result.toString());
      //     } on Exception catch (e) {
      //       print("Conversation build error occurred :" + e.toString());
      //     }
      //   },
      //   backgroundColor: Colors.blue.shade100,
      //   tooltip: 'Increment',
      //   child: ClipOval(child: Icon(Icons.chat, size: 40, color: Colors.blue)),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatBoxScreen();
              },
            ),
          );
        },
        backgroundColor: Colors.blue.shade100,
        tooltip: 'Increment',
        child: ClipOval(child: Icon(Icons.chat, size: 40, color: Colors.blue)),
      ),
      body: _pages[_pageIndex],
    );
  }
}
