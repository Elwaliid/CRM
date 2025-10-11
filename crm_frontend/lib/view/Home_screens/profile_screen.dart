// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, non_constant_identifier_names
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:crm_frontend/models/user_model.dart';
import 'package:crm_frontend/ustils/config.dart';
import 'package:crm_frontend/ustils/constants.dart' as Constants;
import 'package:crm_frontend/view/Sub_screens/history_screen.dart';
import 'package:crm_frontend/view/Sub_screens/my_profile_screen.dart';
import 'package:crm_frontend/view/Sub_screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  final String? token;

  const ProfileScreen({super.key, this.userId, this.token});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String email = "";
  String? phone;
  String? userId;
  Uint8List? imageBytes;
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    UserModel? user = await UserModel.getUser();

    if (user != null) {
      userId = user.id;
      userName = user.name!;
      email = user.email!;
      imageBytes = null;
      await GetProfileImage();
    }
    setState(() {});
  }

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
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Constants.primaryColor.withOpacity(0.9),
                              Colors.blueGrey.shade300,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: imageBytes != null
                            ? ClipOval(
                                child: Image.memory(
                                  imageBytes!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  userName.isNotEmpty
                                      ? userName[0].toUpperCase()
                                      : 'FUCK',
                                  style: GoogleFonts.poppins(
                                    fontSize: 42,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
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
                      onTap: () => Get.to(() => const MyProfileScreen()),
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
                      onTap: () => Get.to(HistoryScreen()),
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
    print(message);
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

  Future<void> GetProfileImage() async {
    if (userId != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token == null) {
          _showSnack('No authentication token found');
          return;
        }

        final response = await http.get(
          Uri.parse(getProfileImage),
          headers: {'Authorization': 'Bearer $token'},
        );
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['status'] == true) {
          final String? dataUrl = data['profileImageURL'];
          print('Received dataUrl: $dataUrl');
          if (dataUrl != null) {
            try {
              final Uint8List bytes = base64Decode(dataUrl);
              setState(() {
                imageBytes = bytes;
              });
              _showSnack('Profile image loaded successfully');
              return; // Exit early on success
            } catch (e) {
              _showSnack('Failed to decode image data');
              print('Base64 decode error: $e');
            }
          } else if (dataUrl != null) {
            _showSnack('Invalid image format received');
          } else {
            _showSnack('No profile image found on server');
            // Optionally set a default image or keep null
          }
        } else {
          _showSnack(
            'Failed to get profile image (Status: ${response.statusCode})',
          );
        }
      } catch (e) {
        print('Error getting image: $e');
      }
    } else {
      _showSnack('User ID is null');
    }
  }
}
