// ignore_for_file: sized_box_for_whitespace, unused_import

import 'package:crm_frontend/view/Home_screens/tasks_screen.dart';
import 'package:crm_frontend/view/Screens/home_screen.dart';
import 'package:crm_frontend/view/Screens/login_screen.dart';
import 'package:crm_frontend/view/Sub_screens/Task_Details_screen.dart';
import 'package:crm_frontend/view/Sub_screens/contact_details_screen.dart';
import 'package:crm_frontend/google_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1500)); // Splash delay
    final provider = Provider.of<GoogleSigninProvider>(context, listen: false);
    String? token = await provider.getTokenSilently();
    if (token != null && !JwtDecoder.isExpired(token)) {
      Get.to(() => HomeScreen(token: token));
    } else {
      Get.to(() => const LoginScreen());
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/data'),
    );
    if (response.statusCode == 200) {
      print("Splash Data: ${response.body}");
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset("lib/images/5.jpeg", fit: BoxFit.cover),
      ),
    );
  }
}
