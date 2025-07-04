import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_multi_store/provider/cart_provider.dart';
import 'package:flutter_multi_store/provider/product_provider.dart';
import 'package:flutter_multi_store/provider/stripe_id.dart';
import 'package:flutter_multi_store/utils/consts.dart';
import 'package:flutter_multi_store/vendor/views/screens/landing_screen.dart';
import 'package:flutter_multi_store/views/auth/login_screen.dart';
import 'package:flutter_multi_store/views/buyers/main_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  Gemini.init(apiKey: GEMINI_API_KEY, enableDebugging: true);

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
        name: 'flutter-store-app-1c9ac',
        options: FirebaseOptions(
          apiKey: 'AIzaSyDtK660B6FRifJfcKcqoySSZqzzwQWEkzc',
          appId: '1:195971740928:android:388f30cd7d0f37a7c3afe5',
          messagingSenderId: '195971740928',
          projectId: 'flutter-store-app-1c9ac',
          storageBucket: 'gs://flutter-store-app-1c9ac.appspot.com',
        ),
      )
      : await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ProductProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return CartProvider();
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Brand-Bold'),
      initialRoute: '/mainscreen',
      routes: {
        '/landingscreen': (context) => LandingScreen(),
        '/loginscreen': (context) => LoginScreen(),
        '/mainscreen': (context) => MainScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
