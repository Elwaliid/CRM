// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, non_constant_identifier_names
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:crm_frontend/models/user_model.dart';
import 'package:crm_frontend/ustils/config.dart';
import 'package:crm_frontend/view/Sub_screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
          //////////////////////////// profile image
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
                GestureDetector(
                  onTap: PickUpdateProfileImage,
                  child: Container(
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
                          imageBytes != null
                              ? ClipOval(
                                  child: SizedBox(
                                    width: 160,
                                    height: 160,
                                    child: Image.memory(
                                      imageBytes!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            print('Image load error: $error');
                                            return CircleAvatar(
                                              radius: 80,
                                              backgroundColor: primaryColor,
                                              child: const Icon(
                                                Icons.error,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundColor: primaryColor,
                                  child: Text(
                                    userName.isNotEmpty
                                        ? userName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 60,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade800,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
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
          if (dataUrl != null && dataUrl.startsWith('data:image/')) {
            final List<String> parts = dataUrl.split(',');
            if (parts.length == 2) {
              try {
                final Uint8List bytes = base64Decode(parts[1]);
                setState(() {
                  imageBytes = bytes;
                });
                _showSnack('Profile image loaded successfully');
                return; // Exit early on success
              } catch (e) {
                _showSnack('Failed to decode image data');
                print('Base64 decode error: $e');
              }
            } else {
              _showSnack('Invalid image data format');
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

  Future<void> PickUpdateProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });

      if (userId != null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token == null) {
            _showSnack('No authentication token found');
            return;
          }

          var request = http.MultipartRequest(
            'POST',
            Uri.parse(addUpdateProfileImage),
          );
          request.headers['Authorization'] = 'Bearer $token';
          request.fields['userId'] = userId!;
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: pickedFile.name,
            ),
          );

          var response = await request.send();

          if (response.statusCode == 200) {
            _showSnack('Profile image updated successfully');
          } else {
            _showSnack(
              'Failed to update profile image (Status: ${response.statusCode})',
            );
          }
        } catch (e) {
          _showSnack('Error uploading image: $e');
        }
      } else {
        _showSnack('User ID is null');
      }
    } else {
      _showSnack('No image selected');
    }
  }
}
