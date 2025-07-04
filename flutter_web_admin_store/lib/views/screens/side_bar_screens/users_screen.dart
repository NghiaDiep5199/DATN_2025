import 'package:flutter/material.dart';
import 'package:flutter_web_admin_store/views/widgets/users_list.dart';

class UsersScreen extends StatefulWidget {
  static const String routeName = '\UsersScreen';

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Widget _rowHeader(int flex, String text) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Manage Users',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
            ),
          ),
          // SizedBox(height: 15),
          Row(
            children: [
              _rowHeader(1, 'IMAGE'),
              _rowHeader(2, 'FULL NAME'),
              _rowHeader(2, 'ADDRESS'),
              _rowHeader(2, 'EMAIL'),
              _rowHeader(1, 'PHONE'),
              _rowHeader(1, 'VIEW MORE'),
            ],
          ),
          UsersList(),
        ],
      ),
    );
  }
}
