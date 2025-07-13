// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable

import 'dart:ui';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
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
                BlurryContainer(
                  blur: 25,
                  width: 320,
                  height: 270,
                  elevation: 6,
                  color: Colors.white.withOpacity(0.15),
                  padding: const EdgeInsets.all(12),
                  borderRadius: BorderRadius.circular(30),
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
                BlurryContainer(
                  blur: 8,
                  width: 360,
                  height: 70,
                  elevation: 4,
                  color: Colors.white.withOpacity(0.15),

                  borderRadius: BorderRadius.circular(24),
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
                      onTap: () => _showSnack('Settings tapped'),
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
                      primaryColor: primaryColor,
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

  /// Reusable BlurryContainer menu item
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return BlurryContainer(
      blur: 8,
      elevation: 4,
      color: Colors.white.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      borderRadius: BorderRadius.circular(24),
      child: ListTile(
        leading: Icon(icon, color: primaryColor, size: 26),
        title: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 20,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
