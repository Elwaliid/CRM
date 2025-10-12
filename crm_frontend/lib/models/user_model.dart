import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ustils/config.dart';

class UserModel {
  String? id;
  String? email;
  String? name;
  String? nickname;
  String? phone;
  String? avatar;
  String? role;
  List<String>? history;
  String? profileImageURL;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.nickname,
    this.phone,
    this.avatar,
    this.role,
    this.history,
    this.profileImageURL,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      nickname: json['nickname'],
      phone: json['phone'],
      avatar: json['avatar'],
      role: json['role'],
    );
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          return UserModel.fromJson(data['user']);
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<List<UserModel>> fetchAgents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse(getAllUsersUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          List<UserModel> users = (data['users'] as List)
              .map((userJson) => UserModel.fromJson(userJson))
              .toList();
          return users;
        }
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  static Future<bool> updateUser(Map<String, dynamic> updates) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse(updateUserURL),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          print("User updated successfully");
          return true;
        }
      }
      print("Failed to update user: ${response.statusCode}");
    } catch (e) {
      print("Error updating user: $e");
    }
    return false;
  }

  static Future<bool> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return false;

    try {
      final response = await http.delete(
        Uri.parse(deleteUserURL),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          print("User deleted successfully");
          return true;
        }
      }
      print("Failed to delete user: ${response.statusCode}");
    } catch (e) {
      print("Error deleting user: $e");
    }
    return false;
  }
}
