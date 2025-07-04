import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_web_admin_store/views/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        kIsWeb || Platform.isAndroid
            ? FirebaseOptions(
              apiKey: "AIzaSyDWUXGOs9uMtUwZ3Hn54GKEPQloLXh1XC0",
              appId: "1:195971740928:web:23a016e720dfbecac3afe5",
              messagingSenderId: "195971740928",
              projectId: "flutter-store-app-1c9ac",
              storageBucket: "gs://flutter-store-app-1c9ac.appspot.com",
            )
            : null,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}
