// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crm_frontend/models/user_model.dart';
import 'package:crm_frontend/view/Widgets/wilou_textfield.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  UserModel? user;
  bool isLoading = true;

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
      final nameParts = user!.name?.split(' ') ?? [];
      firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
      lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';
      emailController.text = user!.email ?? '';
      phoneController.text = user!.phone ?? '';
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
            color: primaryColor,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
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
                // Profile picture placeholder
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.blueGrey.shade100,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: primaryColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${firstNameController.text} ${lastNameController.text}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        user?.role ?? 'User',
                        style: GoogleFonts.poppins(
                          color: secondaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                WilouTextField(
                  label: 'First Name',
                  controller: firstNameController,
                  textColor: primaryColor,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: WilouTextField(
                        label: 'Last Name',
                        controller: lastNameController,
                        textColor: primaryColor,
                      ),
                    ),

                    Expanded(
                      child: WilouTextField(
                        label: 'Nickname',
                        controller: nicknameController,
                        textColor: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                WilouTextField(
                  label: 'Email',
                  controller: emailController,
                  readOnly: true,
                  textColor: primaryColor,
                ),
                const SizedBox(height: 16),

                WilouTextField(
                  label: 'Phone Number',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textColor: primaryColor,
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
}
