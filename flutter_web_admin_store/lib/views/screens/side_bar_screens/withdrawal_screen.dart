import 'package:flutter/material.dart';

class WithdrawalScreen extends StatefulWidget {
  static const String routeName = '\WithdrawalScreen';

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
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
              'Withdrawal',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
            ),
          ),
          Row(
            children: [
              _rowHeader(1, 'NAME'),
              _rowHeader(3, 'AMOUNT'),
              _rowHeader(2, 'BANK NAME'),
              _rowHeader(2, 'BANK ACCOUNT'),
              _rowHeader(1, 'EMAIL'),
              _rowHeader(1, 'PHONE'),
            ],
          ),
        ],
      ),
    );
  }
}
