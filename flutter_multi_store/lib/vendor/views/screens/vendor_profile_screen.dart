import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_store/utils/show_snackBar.dart';
import 'package:flutter_multi_store/vendor/views/screens/edit_profile_vendor.dart';
import 'package:flutter_multi_store/views/auth/login_screen.dart';

class VendorProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection(
      'vendors',
    );
    return FutureBuilder<DocumentSnapshot>(
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
                    backgroundImage: NetworkImage(data['storeImage']),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  data['bussinessName'],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  data['email'],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditProfileVendor(vendorData: data);
                        },
                      ),
                    );
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
                  leading: Icon(Icons.location_on),
                  title: Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    data['countryValue'] +
                        ', ' +
                        data['cityValue'] +
                        ', ' +
                        data['stateValue'],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ListTile(
                //   leading: SvgPicture.asset('assets/icons/tax.svg', width: 24),
                //   title: Text(
                //     'Tax Number',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   subtitle: Text(
                //     data['taxNumber'],
                //     style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 13,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                ListTile(
                  onTap: () async {
                    bool confirmLogout = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to log out?'),
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
