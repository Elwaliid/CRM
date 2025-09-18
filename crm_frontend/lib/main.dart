import 'package:crm_frontend/view/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
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

        // ✅ Custom color scheme for date picker + app
        colorScheme: ColorScheme.light(
          primary: Colors.blueGrey.shade900, // header background
          onPrimary: Colors.white, // header text
          onSurface: Colors.black87, // body text
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
