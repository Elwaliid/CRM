// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crm_frontend/models/user_model.dart';
import 'package:crm_frontend/ustils/config.dart';
import 'package:crm_frontend/ustils/constants.dart' as Constants;
import 'package:crm_frontend/view/Widgets/wilou_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  UserModel? user;
  bool isLoading = true;
  String? userId;
  Uint8List? imageBytes;
  String userName = "";

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    user = await UserModel.getUser();
    if (user != null) {
      userId = user!.id;
      userName = user!.name ?? '';
      final nameParts = user!.name?.split(' ') ?? [];
      firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
      lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';
      emailController.text = user!.email ?? '';
      phoneController.text = user!.phone ?? '';
      imageBytes = null;
      await GetProfileImage();
    }
    setState(() => isLoading = false);
  }

  Future<void> _saveChanges() async {
    if (user == null) return;

    final updates = {
      'name': '${firstNameController.text} ${lastNameController.text}'.trim(),
      'nickname': nicknameController.text.trim(),
      'phone': phoneController.text,
    };

    final success = await UserModel.updateUser(updates);
    if (success) {
      Get.snackbar(
        '✅ Success',
        'Profile updated successfully',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      _loadUser();
      Navigator.pop(context);
    } else {
      Get.snackbar(
        '❌ Error',
        'Failed to update profile',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _deleteProfile() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Profile'),
        content: const Text(
          'Are you sure you want to delete your profile? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await UserModel.deleteUser();
      if (success) {
        Get.snackbar(
          'Profile Deleted',
          'Your account has been removed.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete profile',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: PickUpdateProfileImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: imageBytes != null
                                    ? ClipOval(
                                        child: SizedBox(
                                          width: 112,
                                          height: 112,
                                          child: Image.memory(
                                            imageBytes!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  print(
                                                    'Image load error: $error',
                                                  );
                                                  return CircleAvatar(
                                                    radius: 56,
                                                    backgroundColor:
                                                        primaryColor,
                                                    child: const Icon(
                                                      Icons.error,
                                                      color: Colors.white,
                                                      size: 40,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 56,
                                        backgroundColor: primaryColor,
                                        child: Text(
                                          userName.isNotEmpty
                                              ? userName[0].toUpperCase()
                                              : 'FUCK',
                                          style: const TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Constants.primaryColor,
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
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${firstNameController.text} ${lastNameController.text}'
                                .trim()
                                .isEmpty
                            ? 'User Name'
                            : '${firstNameController.text} ${lastNameController.text}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        user?.role ?? 'User',
                        style: GoogleFonts.poppins(
                          color: secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Personal Information Section
                Text(
                  'Personal Information',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: WilouTextField(
                        label: 'First Name',
                        controller: firstNameController,
                        textColor: primaryColor,
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: WilouTextField(
                        label: 'Last Name',
                        controller: lastNameController,
                        textColor: primaryColor,
                        icon: Icons.person_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                WilouTextField(
                  label: 'Nickname',
                  controller: nicknameController,
                  textColor: primaryColor,
                  icon: Icons.tag,
                ),
                const SizedBox(height: 24),

                // Contact Information Section
                Text(
                  'Contact Information',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 16),

                WilouTextField(
                  label: 'Email',
                  controller: emailController,
                  readOnly: true,
                  textColor: primaryColor,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),

                WilouTextField(
                  label: 'Phone Number',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textColor: primaryColor,
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save_rounded, color: Colors.white),
                  label: Text(
                    'Save Changes',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 6,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: TextButton.icon(
                    onPressed: _deleteProfile,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: Text(
                      'Delete Profile',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          Get.snackbar('Error', 'No authentication token found');
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
              Get.snackbar('Success', 'Profile image loaded successfully');
              return;
            } catch (e) {
              Get.snackbar('Error', 'Failed to decode image data');
              print('Base64 decode error: $e');
            }
          } else if (dataUrl != null) {
            Get.snackbar('Error', 'Invalid image format received');
          } else {
            Get.snackbar('Info', 'No profile image found on server');
          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to get profile image (Status: ${response.statusCode})',
          );
        }
      } catch (e) {
        print('Error getting image: $e');
      }
    } else {
      Get.snackbar('Error', 'User ID is null');
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
            Get.snackbar('Error', 'No authentication token found');
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
            Get.snackbar('Success', 'Profile image updated successfully');
          } else {
            Get.snackbar(
              'Error',
              'Failed to update profile image (Status: ${response.statusCode})',
            );
          }
        } catch (e) {
          Get.snackbar('Error', 'Error uploading image: $e');
        }
      } else {
        Get.snackbar('Error', 'User ID is null');
      }
    } else {
      Get.snackbar('Info', 'No image selected');
    }
  }
}
