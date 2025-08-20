// ignore_for_file: deprecated_member_use, duplicate_ignore, avoid_print, unnecessary_import

import 'package:crm_frontend/view/Screens/home_screen.dart';
import 'package:crm_frontend/view/Screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('lib/images/login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ////////////////////////////////////////////////////////////// Title
                Text(
                  'mybusiness',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 48,
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
                const SizedBox(height: 8),

                /////////////////////////////////////////////////////////// phrase
                Text(
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
                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //////////////////////////////////////////////////////////////////////////// Email field
                      TextFormField(
                        controller: _emailTextEditingController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.blueGrey[700],
                          ),
                          hintText: "Please enter your email",
                          hintStyle: TextStyle(
                            color: Colors.blueGrey[400],
                            fontSize: 18.0,
                          ),
                          filled: true,
                          fillColor: Colors.blueGrey[50],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.shade200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade400,
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey[900],
                        ),
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      ////////////////////////////////////////////////////////////////////// Password field
                      TextFormField(
                        controller: _passwordTextEditingController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.blueGrey[700],
                          ),
                          hintText: "Please enter your password",
                          hintStyle: TextStyle(
                            color: Colors.blueGrey[400],
                            fontSize: 18.0,
                          ),
                          filled: true,
                          fillColor: Colors.blueGrey[50],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.shade200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade400,
                              width: 2.0,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.blueGrey[700],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey[900],
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      /////////////////////////////////////////////////////////////////////////////////// Forgot password
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Forgot password
                          },
                          child: Text(
                            'Forgot password? Press here.',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey[700],
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),

                      ///////////////////////////////////////////////////////////////////////////////// Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[900],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Get.to(HomeScreen());
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      //////////////////////////////////////////////////////////////////////////// Register link
                      TextButton(
                        onPressed: () {
                          Get.to(RegisterScreen());
                          // TODO: Go to register
                        },
                        child: Text(
                          "Don't have an account? Register here.",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey[700],
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 17),
                      /////////////////////////////////////////////////////////////////////////////////// OR
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 148,
                            height: 1,
                            color: Colors.blueGrey[700],
                            margin: const EdgeInsets.only(top: 4),
                          ),
                          Text(
                            ' or continue with ',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey[700],
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            width: 148,
                            height: 1,
                            color: Colors.blueGrey[700],
                            margin: const EdgeInsets.only(top: 4),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///////////////////////////////////////////////////////////////////////////////// google login
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Ink(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      // TODO: Google login logic
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'lib/images/google1.png',
                                        width: 70,
                                        height: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          /////////////////////////////////////////////////////////////////////////////// Apple login button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Ink(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      // TODO: Google login logic
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'lib/images/apple2.png',
                                        width: 70,
                                        height: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
