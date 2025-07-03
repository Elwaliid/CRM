// ignore_for_file: deprecated_member_use, duplicate_ignore, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController(
    text: 'walid@gmail.com',
  );
  final _passwordTextEditingController = TextEditingController(
    text: 'walid123',
  );
  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF6F6F7),
          image: DecorationImage(
            image: AssetImage('lib/images/login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            // App Title
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 8.0),
              child: Text(
                'mybusiness',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.blueGrey[900],
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: const Color.fromARGB(66, 121, 120, 120),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Subtitle
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                'Your best business partner.',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[700],
                    letterSpacing: 1.2,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /////////////////////////////////////////Email field
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          hintText: "Please enter your email",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20.0,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(fontSize: 24),
                        controller: _emailTextEditingController,
                        validator: (valueEmail) {
                          if (!valueEmail!.contains('@')) {
                            return "please enter a valid email";
                          }
                          return null;
                        },
                      ),
                    ),
                    ////////////////////////////////////////password field
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                          ),
                          hintText: "Please enter your password",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20.0,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(fontSize: 24),
                        controller: _passwordTextEditingController,
                        validator: (valuePasssword) {
                          if (valuePasssword!.length < 5) {
                            return "Password must be at least 6 or more characters";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
