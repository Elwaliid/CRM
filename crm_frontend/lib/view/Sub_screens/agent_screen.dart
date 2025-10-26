// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, library_prefixes, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crm_frontend/models/user_model.dart';
import 'package:crm_frontend/ustils/config.dart';
import 'package:crm_frontend/ustils/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  List<UserModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    List<UserModel> allUsers = await UserModel.fetchAgents();
    // Filter out admins
    users = allUsers.where((user) => user.role != 'admin').toList();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteUser(String userId, String userName) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete $userName? This action cannot be undone.',
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
      final success = await _deleteUserById(userId);
      if (success) {
        Get.snackbar(
          'User Deleted',
          '$userName has been removed.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        super.initState();
        _fetchUsers();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete user',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<bool> _deleteUserById(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse(deleteUserURL),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'isAdmin': true}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          return true;
        }
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
    return false;
  }

  String formatDate(String? isoString) {
    if (isoString == null) return 'Unknown';
    try {
      DateTime dateTime = DateTime.parse(isoString);
      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (e) {
      return isoString;
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
          'Agents',
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
      body: users.isEmpty
          ? Center(
              child: Text(
                'No agents found.',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                Uint8List? avatarBytes;
                if (user.avatar != null && user.avatar!.isNotEmpty) {
                  try {
                    avatarBytes = base64Decode(user.avatar!);
                  } catch (e) {
                    avatarBytes = null;
                  }
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 50,
                        height: 50,
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
                        ),
                        child: avatarBytes != null
                            ? ClipOval(
                                child: Image.memory(
                                  avatarBytes,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  user.name?.isNotEmpty == true
                                      ? user.name![0].toUpperCase()
                                      : 'U',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 16),
                      // Name and Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name ?? 'Unknown',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Created: ${formatDate(user.createdAt)}', // Assuming createdAt is added to UserModel
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteUser(user.id!, user.name ?? 'User'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
