import 'package:flutter/material.dart';

void showSnack(BuildContext context, String title, {int durationSeconds = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(seconds: durationSeconds),
    ),
  );
}

void showSnackDialog(BuildContext context, String title,
    {int durationSeconds = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(seconds: durationSeconds),
    ),
  );
}
