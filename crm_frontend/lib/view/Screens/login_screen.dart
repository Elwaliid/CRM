// ignore_for_file: deprecated_member_use, duplicate_ignore, avoid_print, unnecessary_import, use_build_context_synchronously
import 'dart:convert';
import 'package:crm_frontend/config.dart';
import 'package:crm_frontend/view/Screens/home_screen.dart';
import 'package:crm_frontend/view/Screens/register_screen.dart';
import 'package:crm_frontend/google_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _otpTextEditingController = TextEditingController();
  final _newPasswordTextEditingController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

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
                          onPressed: () async {
                            String email = _emailTextEditingController.text
                                .trim();
                            if (email.isEmpty || !email.contains('@')) {
                              Get.snackbar(
                                'Invalid Email',
                                'Please enter a valid email address.',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            try {
                              var forgotBody = {'email': email};
                              var response = await http.post(
                                Uri.parse(forgotPasswordUrl),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode(forgotBody),
                              );

                              print(
                                'Forgot Password Response Status: ${response.statusCode}',
                              );
                              print(
                                'Forgot Password Response Body: ${response.body}',
                              );

                              if (response.statusCode == 200) {
                                var responseBody = jsonDecode(response.body);
                                if (responseBody['status'] == true) {
                                  Get.snackbar(
                                    'OTP Sent',
                                    'Check your email for the OTP.',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                  _showResetPasswordDialog();
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    responseBody['message'] ??
                                        'Failed to send OTP',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Failed to send OTP',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Failed to connect to server',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              print('Forgot password error: $e');
                            }
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                var logBody = {
                                  'email': _emailTextEditingController.text,
                                  'password':
                                      _passwordTextEditingController.text,
                                };
                                var response = await http.post(
                                  Uri.parse(loginUrl),
                                  headers: {"Content-Type": "application/json"},
                                  body: jsonEncode(logBody),
                                );

                                print(
                                  'Login Response status: ${response.statusCode}',
                                );
                                print('Login Response body: ${response.body}');

                                // Check if response is JSON
                                if (response.headers['content-type']?.contains(
                                      'application/json',
                                    ) ??
                                    false) {
                                  var responseBody = jsonDecode(response.body);
                                  var token = responseBody['token'] as String?;

                                  print('Parsed token: $token');

                                  if (token != null) {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('token', token);
                                    print('Token saved to SharedPreferences');

                                    // ✅ Go directly to HomeScreen with token
                                    Get.to(HomeScreen(token: token));
                                  } else {
                                    // Show error message from server
                                    Get.snackbar(
                                      'Login Failed',
                                      responseBody['message'] ??
                                          'Invalid credentials',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                } else {
                                  // Handle non-JSON response (likely HTML error page)
                                  Get.snackbar(
                                    'Server Error',
                                    'Server returned an unexpected response. Please try again later.',
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      170,
                                      119,
                                      115,
                                    ),
                                    colorText: Colors.white,
                                  );
                                  print('Non-JSON response: ${response.body}');
                                }
                              } catch (e) {
                                // Handle network errors or JSON parsing errors
                                Get.snackbar(
                                  'Error',
                                  'Failed to connect to server. Please check your connection.',
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    158,
                                    109,
                                    105,
                                  ),
                                  colorText: Colors.white,
                                );
                                print('Login error: $e');
                              }
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
                                    ///////////////////  GoogleLoginProvider
                                    onTap: () async {
                                      try {
                                        final provider =
                                            Provider.of<GoogleSigninProvider>(
                                              context,
                                              listen: false,
                                            );
                                        final token = await provider
                                            .oauthAndGetToken();

                                        if (token != null) {
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.setString('token', token);
                                          Get.to(HomeScreen(token: token));
                                        } else {
                                          Get.snackbar(
                                            'Google Sign-In Failed',
                                            'Unable to authenticate with server',
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
                                      } catch (e) {
                                        Get.snackbar(
                                          'Google Sign-In Failed',
                                          'Please check your Google account and try again: $e',
                                          backgroundColor: const Color.fromARGB(
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
                      const SizedBox(height: 20),

                      ///////////////////////////////////////////////////////////////////////////////// Sign Out button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              final provider =
                                  Provider.of<GoogleSigninProvider>(
                                    context,
                                    listen: false,
                                  );
                              await provider.signOut();
                              Get.snackbar(
                                'Signed Out',
                                'You have been signed out successfully.',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            } catch (e) {
                              Get.snackbar(
                                'Sign Out Failed',
                                'Error signing out: $e',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: const Text(
                            'Sign Out',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
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

  //////////////////////////////////////////////////////////////////////////////// reset dialog
  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(
              right: 20.0,
              left: 20.0,
              top: 40.0,
              bottom: 30.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Reset Password',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // OTP Field
                TextField(
                  controller: _otpTextEditingController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_clock_outlined,
                      color: Colors.blueGrey[700],
                    ),
                    hintText: "Enter the code sent to your email",
                    hintStyle: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 16.0,
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
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[900]),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // New Password Field
                TextField(
                  controller: _newPasswordTextEditingController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.blueGrey[700],
                    ),
                    hintText: "new password",
                    hintStyle: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 16.0,
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
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[900]),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Confirm Button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[900],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            var resetBody = {
                              'email': _emailTextEditingController.text,
                              'otp': _otpTextEditingController.text,
                              'newPassword':
                                  _newPasswordTextEditingController.text,
                            };
                            var response = await http.post(
                              Uri.parse(resetPasswordUrl),
                              headers: {"Content-Type": "application/json"},
                              body: jsonEncode(resetBody),
                            );

                            if (response.statusCode == 200) {
                              var responseBody = jsonDecode(response.body);
                              if (responseBody['status'] == true) {
                                Get.snackbar(
                                  'Success',
                                  'Password reset successfully',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                                Navigator.of(context).pop();
                                _otpTextEditingController.clear();
                                _newPasswordTextEditingController.clear();
                              } else {
                                Get.snackbar(
                                  'Error',
                                  responseBody['message'] ??
                                      'Failed to reset password',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to reset password',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to connect to server',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            print('Reset password error: $e');
                          }
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
