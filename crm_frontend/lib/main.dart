import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CRMApp());
}

class CRMApp extends StatelessWidget {
  const CRMApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRM App',
      home: Scaffold(
        appBar: AppBar(title: const Text('CRM App')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final response = await http.get(
                Uri.parse('http://localhost:3000/api/data'),
              );
              // ignore: avoid_print
              print('Riglou: ${response.body}');
            },
            child: const Text('Click'),
          ),
        ),
      ),
    );
  }
}
