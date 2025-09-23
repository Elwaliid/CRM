// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:crm_frontend/google_signin_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm_frontend/config.dart';
import 'package:crm_frontend/view/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  // Add controllers for new fields
  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _phoneNumberTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('lib/images/register.jpg', fit: BoxFit.cover),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /////////////////////////////////////////////////////////// Title
                  Text(
                    'Register',
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

                  ///////////////////////////////////////////////////////////////// Subtitle
                  Text(
                    'Please fill in the details to create your account',
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
                        Row(
                          children: [
                            Expanded(
                              /////////////////////////////////////////////////////////////////////////////////////////// first name field
                              child: TextFormField(
                                controller: _firstNameTextEditingController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.blueGrey[700],
                                  ),
                                  hintText: "First Name",
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
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your first name";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              /////////////////////////////////////////////////////////// last name field
                              child: TextFormField(
                                controller: _lastNameTextEditingController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.blueGrey[700],
                                  ),
                                  hintText: "Last Name",
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
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your last name";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ///////////////////////////////////////////////////////////////////////////////////////// Email field
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

                        /////////////////////////////////////////////////////////////////////////// Password field
                        TextFormField(
                          controller: _passwordTextEditingController,
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
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey[900],
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        ////////////////////////////////////////////////////////////////// Confirm Password field
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.blueGrey[700],
                            ),
                            hintText: "Please confirm your password",
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
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value != _passwordTextEditingController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        ///////////////////////////////////////////////////////////////////// phone number field
                        TextFormField(
                          controller: _phoneNumberTextEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: Colors.blueGrey[700],
                            ),
                            hintText: "Please enter your phone number",
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

                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            // phone number is not required, so no validation for empty
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ///////////////////////////////////////////////////////// register button
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var logBody = {
                                  'email': _emailTextEditingController.text,
                                  'password':
                                      _passwordTextEditingController.text,
                                };

                                var response = await http.post(
                                  Uri.parse(registerUrl),
                                  headers: {"Content-Type": "application/json"},
                                  body: jsonEncode(logBody),
                                );

                                if (response.statusCode == 201) {
                                  // ✅ check for 201 Created
                                  var responseBody = jsonDecode(response.body);

                                  var token = responseBody['token'] as String?;
                                  if (token != null) {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('token', token);

                                    // ✅ Go directly to HomeScreen with token
                                    Get.to(HomeScreen(token: token));
                                  }
                                } else {
                                  // ❌ registration failed
                                  var responseBody = jsonDecode(response.body);
                                  Get.snackbar(
                                    'Registration Failed',
                                    responseBody['message'] ??
                                        'Please try again',
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      128,
                                      78,
                                      74,
                                    ),
                                    colorText: Colors.white,
                                  );
                                }
                              }
                            },

                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                              ' or register with ',
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
                                      ///////////////////////////// GoogleSigninProvider
                                      onTap: () async {
                                        try {
                                          final provider =
                                              Provider.of<GoogleSigninProvider>(
                                                context,
                                                listen: false,
                                              );
                                          await provider.googleLogin();
                                          // If successful, navigate to home screen
                                          Get.to(
                                            HomeScreen(
                                              token: 'google_auth_token',
                                            ),
                                          );
                                        } catch (e) {
                                          Get.snackbar(
                                            'Google Sign-In Failed',
                                            'Please check your Google account and try again: $e',
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  128,
                                                  78,
                                                  74,
                                                ),
                                            colorText: Colors.white,
                                          );
                                        }
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
                                        ///// waiting for AppleAuthService
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
        ],
      ),
    );
  }
}
