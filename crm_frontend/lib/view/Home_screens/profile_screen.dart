// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable

import 'dart:ui';
import 'package:crm_frontend/view/Sub_screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String userName = "Wilou dilaw";
  final String email = "wilou@gmail.com";
  final String phone = "05 34 56 78 90";

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ////////////////////////////////////////////////////////////////////////// Avatar
                Container(
                  width: MediaQuery.of(context).size.width * 0.48,
                  height: MediaQuery.of(context).size.width * 0.48,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.48 / 2,
                    ),
                  ),
                  child: Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage('lib/images/a1.jpeg'),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade800,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                //////////////////////////////////////////////////////////////////////// Name
                Container(
                  height: 50,
                  width: 480,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                //////////////////////////////////////////////////////////////////////// Menu Items
                Column(
                  children: [
                    //////////////////////////////////////////////////////////////////// My Profile
                    _buildMenuItem(
                      icon: Icons.person,
                      label: 'My Profile',
                      primaryColor: primaryColor,
                      onTap: () => _showSnack('My Profile tapped'),
                    ),
                    const SizedBox(height: 20),

                    //////////////////////////////////////////////////////////////////// Settings
                    _buildMenuItem(
                      icon: Icons.settings,
                      label: 'Settings',
                      primaryColor: primaryColor,
                      onTap: () => Get.to(SettingScreen()),
                    ),
                    const SizedBox(height: 20),

                    //////////////////////////////////////////////////////////////////// History
                    _buildMenuItem(
                      icon: Icons.history,
                      label: 'History',
                      primaryColor: primaryColor,
                      onTap: () => _showSnack('History tapped'),
                    ),
                    const SizedBox(height: 20),

                    //////////////////////////////////////////////////////////////////// Agents
                    _buildMenuItem(
                      icon: Icons.group,
                      label: 'Agents',
                      primaryColor: primaryColor,
                      onTap: () => _showSnack('Agents tapped'),
                    ),
                    const SizedBox(height: 20),

                    //////////////////////////////////////////////////////////////////// About
                    _buildMenuItem(
                      icon: Icons.info,
                      label: 'About',
                      primaryColor: primaryColor,
                      onTap: () => _showSnack('About tapped'),
                    ),
                    const SizedBox(height: 20),

                    //////////////////////////////////////////////////////////////////// Logout
                    _buildMenuItem(
                      icon: Icons.logout,
                      label: 'Logout',
                      primaryColor: const Color.fromARGB(255, 255, 93, 93),
                      onTap: () => _showSnack('Logout tapped'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper for showing SnackBars
  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// menu item
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
}
