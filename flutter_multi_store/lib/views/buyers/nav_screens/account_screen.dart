import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import 'package:flutter_multi_store/provider/cart_provider.dart';
import 'package:flutter_multi_store/utils/show_snackBar.dart';
import 'package:flutter_multi_store/views/auth/login_screen.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/edit_profile.dart';
import 'package:flutter_multi_store/views/buyers/nav_screens/cart_screen.dart';
import 'package:flutter_multi_store/views/buyers/inner_screens/order_screen.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    return _auth.currentUser == null
        ? Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(color: Colors.blue.shade300),
            ),
            title: Text('Profile'),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Center(
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.blue.shade300,
                  child: Icon(Icons.person, color: Colors.white, size: 50),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Login account to access profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 170,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Login Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        : FutureBuilder<DocumentSnapshot>(
          future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Scaffold(
                backgroundColor: Colors.grey.shade300,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(color: Colors.blue.shade300),
                  ),
                  title: Text(
                    'Profile',
                    //style: TextStyle(letterSpacing: 4),
                  ),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    SizedBox(height: 30),
                    Center(
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.blue.shade300,
                        backgroundImage: NetworkImage(data['profileImage']),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      data['fullName'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data['email'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditProfileScreen(userData: data),
                          ),
                        );

                        if (result == 'updated') {
                          setState(() {
                            FutureBuilder<DocumentSnapshot>(
                              future:
                                  users
                                      .doc(
                                        FirebaseAuth.instance.currentUser!.uid,
                                      )
                                      .get(),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot,
                              ) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData &&
                                    !snapshot.data!.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data =
                                      snapshot.data!.data()
                                          as Map<String, dynamic>;
                                  return Scaffold(
                                    backgroundColor: Colors.grey.shade300,
                                    appBar: AppBar(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      flexibleSpace: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade300,
                                        ),
                                      ),
                                      title: Text(
                                        'Profile',
                                        //style: TextStyle(letterSpacing: 4),
                                      ),
                                      centerTitle: true,
                                    ),
                                    body: Column(
                                      children: [
                                        SizedBox(height: 30),
                                        Center(
                                          child: CircleAvatar(
                                            radius: 64,
                                            backgroundColor:
                                                Colors.blue.shade300,
                                            backgroundImage: NetworkImage(
                                              data['profileImage'],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          data['fullName'],
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          data['email'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        InkWell(
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        EditProfileScreen(
                                                          userData: data,
                                                        ),
                                              ),
                                            );

                                            if (result == 'updated') {
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width -
                                                150,
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Edit Profile',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.settings),
                                          title: Text('Settings'),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.phone),
                                          title: Text(
                                            'Phone',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            data['phoneNumber'],
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return CartScreen();
                                                },
                                              ),
                                            );
                                          },
                                          leading: Badge(
                                            showBadge:
                                                context
                                                    .read<CartProvider>()
                                                    .getCartItem
                                                    .isNotEmpty,
                                            badgeStyle: const BadgeStyle(
                                              badgeColor: Colors.red,
                                            ),
                                            position: BadgePosition.topEnd(
                                              top: -12,
                                              end: -8,
                                            ),
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
                                            child: const Icon(
                                              Icons.shopping_cart,
                                              color: Colors.black,
                                            ),
                                          ),
                                          title: Text('Cart'),
                                        ),
                                        ListTile(
                                          onTap: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return OrdersScreen();
                                                },
                                              ),
                                            );
                                          },
                                          leading: Icon(CupertinoIcons.cart),
                                          title: Text('Order'),
                                        ),
                                        ListTile(
                                          onTap: () async {
                                            bool
                                            confirmLogout = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Confirm Logout'),
                                                  content: Text(
                                                    'Are you sure you want to log out?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        );
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        );
                                                      },
                                                      child: Text('Yes'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (confirmLogout == true) {
                                              await _auth
                                                  .signOut()
                                                  .whenComplete(() {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return LoginScreen();
                                                        },
                                                      ),
                                                    );
                                                    showSnackDialog(
                                                      context,
                                                      'Log out successfully',
                                                    );
                                                  });
                                            }
                                          },
                                          leading: Icon(Icons.logout),
                                          title: Text('Log out'),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                          });
                        }
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width - 150,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Divider(thickness: 1, color: Colors.grey),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(
                        'Phone',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        data['phoneNumber'],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CartScreen();
                            },
                          ),
                        );
                      },
                      leading: Badge(
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
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                        ),
                      ),
                      title: Text('Cart'),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return OrdersScreen();
                            },
                          ),
                        );
                      },
                      leading: Icon(CupertinoIcons.cart),
                      title: Text('Order'),
                    ),
                    ListTile(
                      onTap: () async {
                        bool confirmLogout = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Logout'),
                              content: Text(
                                'Are you sure you want to log out?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmLogout == true) {
                          await _auth.signOut().whenComplete(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                            showSnackDialog(context, 'Log out successfully');
                          });
                        }
                      },
                      leading: Icon(Icons.logout),
                      title: Text('Log out'),
                    ),
                  ],
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        );
  }
}
