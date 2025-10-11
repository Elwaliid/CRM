// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, library_prefixes, prefer_typing_uninitialized_variables, deprecated_member_use

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
  late final pickedFile;

  late final bytes;
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
      nicknameController.text = user!.nickname ?? '';
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
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: const SafeArea(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 3),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 3000),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Profile Picture
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: PickUpdateProfileImage,
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
                          Container(
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
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
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Personal Info
              Text(
                'Personal Information',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade300),
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
                icon: Icons.tag_outlined,
              ),

              const SizedBox(height: 30),

              // 🔹 Contact Info
              Text(
                'Contact Information',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade300),
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

              const SizedBox(height: 30),

              // 🔹 Save Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save_rounded, color: Colors.white),
                  label: Text(
                    'Save Changes',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 8,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 🔹 Delete Button
              Center(
                child: TextButton.icon(
                  onPressed: _deleteProfile,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: Text(
                    'Delete Profile',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
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
          if (dataUrl != null) {
            try {
              final Uint8List bytes = base64Decode(dataUrl);
              setState(() {
                imageBytes = bytes;
              });
              return;
            } catch (e) {
              Get.snackbar('Error', 'Failed to decode image data');
            }
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
    pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }
}
