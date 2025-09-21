import 'package:crm_frontend/view/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  runApp(const CRMApp());
}

class CRMApp extends StatelessWidget {
  @override
  const CRMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      home: const SplashScreen(),
    );
  }
}
