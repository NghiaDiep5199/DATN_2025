import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_admin_store/models/user_model.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('buyers').snapshots();

  Widget vendorData(Widget widget, int? flex) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(padding: const EdgeInsets.all(8.0), child: widget),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: ((context, index) {
            UserModel users = UserModel.fromJson(
              snapshot.data!.docs[index].data() as Map<String, dynamic>,
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                vendorData(
                  Container(
                    height: 50,
                    width: 50,
                    child: Image.network(
                      users.profileImage.toString(),
                      width: 50,
                      height: 50,
                    ),
                  ),
                  1,
                ),
                vendorData(
                  Text(
                    users.fullName.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  2,
                ),
                vendorData(
                  Text(
                    users.address.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  2,
                ),
                vendorData(
                  Text(
                    users.email.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  2,
                ),

                vendorData(
                  Text(
                    users.phoneNumber.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  1,
                ),
                vendorData(
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('More', style: TextStyle(color: Colors.grey)),
                  ),
                  1,
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
