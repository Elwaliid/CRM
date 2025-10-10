// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../Widgets/wilou_textfield.dart';
import '../../ustils/config.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  @override
  State<SettingScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingScreen> {
  final Color primaryColor = Colors.blueGrey.shade900;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: ///////////////////////////////////////////////////////////////////////////// Title
                        Text(
                          'Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildMenuItem(
                      icon: Icons.language,
                      label: 'Languages',
                      primaryColor: primaryColor,
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    _buildMenuItem(
                      icon: Icons.brightness_6,
                      label: 'Night/Day mode',
                      primaryColor: primaryColor,
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    _buildMenuItem(
                      icon: Icons.lock,
                      label: 'Change Password',
                      primaryColor: primaryColor,
                      onTap: _showChangePasswordDialog,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Change Password',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WilouTextField(
                label: 'Old Password',
                controller: _oldPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              WilouTextField(
                label: 'New Password',
                controller: _newPasswordController,
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _oldPasswordController.clear();
                _newPasswordController.clear();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.roboto(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text(
                'Change',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _changePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Not authenticated',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      var response = await http.post(
        Uri.parse(changePasswordUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == true) {
          Get.snackbar(
            'Success',
            'Password changed successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Navigator.of(context).pop();
          _oldPasswordController.clear();
          _newPasswordController.clear();
        } else {
          Get.snackbar(
            'Error',
            responseBody['message'] ?? 'Failed to change password',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to change password',
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
    }
  }
}
