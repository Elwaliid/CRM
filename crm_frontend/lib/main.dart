// ignore_for_file: avoid_print

import 'package:crm_frontend/view/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(CRMApp(token: prefs.getString('token')));
}

class CRMApp extends StatelessWidget {
  final token;
  const CRMApp({@required this.token, super.key});

  // Example fetch (not relevant for UI)
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/data'),
    );
    if (response.statusCode == 200) {
      print('Riglou: ${response.body}');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

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
