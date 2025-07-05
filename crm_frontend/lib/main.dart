import 'package:crm_frontend/view/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CRMApp());
}

class CRMApp extends StatelessWidget {
  @override
  /*void initState() {
    super.initState();
    fetchData();
  }*/
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
