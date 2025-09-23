import 'dart:convert';

import 'package:crm_frontend/config.dart' as Config;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoogleSigninProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn(
    clientId:
        "885141582672-tb97ps21m1gjlg7rd2nt94orhbseu228.apps.googleusercontent.com",
  );
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<String?> oauthAndGetToken() async {
    try {
      final googleUser = await googleSignIn.signInSilently();
      if (googleUser == null) {
        return null;
      }

      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Send to backend to get JWT token
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/google-signin'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': googleUser.email,
          'name': googleUser.displayName,
          'googleId': googleUser.id,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      }

      return null;
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }
}
