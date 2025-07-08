// ignore_for_file: sized_box_for_whitespace

import 'package:crm_frontend/view/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      // Get.to(const LoginScreen());
      Get.to(const HomeScreen());
    });
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
