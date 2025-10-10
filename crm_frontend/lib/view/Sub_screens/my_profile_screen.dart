import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crm_frontend/models/user_model.dart';

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
      // Assume name is "First Last"
      final nameParts = user!.name?.split(' ') ?? [];
      firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
      lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';
      // Nickname not in model, leave empty
      emailController.text = user!.email ?? '';
      phoneController.text = user!.phone ?? '';
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    if (user == null) return;

    final updates = {
      'name': '${firstNameController.text} ${lastNameController.text}'.trim(),
      'phone': phoneController.text,
      // Add nickname if backend supports
    };

    final success = await UserModel.updateUser(updates);
    if (success) {
      Get.snackbar('Success', 'Profile updated successfully');
      _loadUser(); // Reload
    } else {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }

  Future<void> _deleteProfile() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text(
          'Are you sure you want to delete your profile? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await UserModel.deleteUser();
      if (success) {
        Get.snackbar('Success', 'Profile deleted');
        Get.offAllNamed('/login'); // Assuming login route
      } else {
        Get.snackbar('Error', 'Failed to delete profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(labelText: 'Nickname'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 20),
            Text('Role: ${user?.role ?? 'N/A'}'),
            const Spacer(),
            ElevatedButton(
              onPressed: _deleteProfile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
