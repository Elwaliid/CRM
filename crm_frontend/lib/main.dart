// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables, use_super_parameters

import 'dart:html' as html;
import 'package:crm_frontend/view/Screens/home_screen.dart';
import 'package:crm_frontend/view/Screens/splash_screen.dart';
import 'package:crm_frontend/google_signin_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token;
  if (kIsWeb) {
    token = html.window.localStorage['token'];
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }
  print('Retrieved token: $token');
  if (token != null) {
    bool isExpired = JwtDecoder.isExpired(token);
    print('Token is expired: $isExpired');
    DateTime? expiryDate = JwtDecoder.getExpirationDate(token);
    print('Token expiry date: $expiryDate');
  }
  // Initialize Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB_40UPcCNLppkv4uArk216zeP5k7i2MPU",
        authDomain: "wilou-crm.firebaseapp.com",
        projectId: "wilou-crm",
        storageBucket: "wilou-crm.firebasestorage.app",
        messagingSenderId: "885141582672",
        appId: "1:885141582672:web:b6149dd2cf7d9846b37255",
        measurementId: "G-8PNE7LD3YB",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(CRMApp(token: token));
}

class CRMApp extends StatelessWidget {
  final token;

  const CRMApp({@required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSigninProvider(),
      child: GetMaterialApp(
        title: 'CRM App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Colors.black,
          ),

          // ✅ Custom calender
          colorScheme: ColorScheme.light(
            primary: Colors.blueGrey.shade900,
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
          dialogBackgroundColor: Colors.white,
          datePickerTheme: DatePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          useMaterial3: true,
        ),

        home: (token != null && JwtDecoder.isExpired(token) == false)
            ? HomeScreen(token: token)
            : SplashScreen(),
      ),
    );
  }
}
