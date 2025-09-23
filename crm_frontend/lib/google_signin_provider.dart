import 'dart:convert';

import 'package:crm_frontend/config.dart' as Config;
import 'package:crm_frontend/config.dart';
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
      // Try silent sign-in first
      final googleUser = await googleSignIn.signInSilently();

      // If silent sign-in fails, try interactive sign-in
      final finalGoogleUser = googleUser ?? await googleSignIn.signIn();

      if (finalGoogleUser == null) {
        print('Google Sign-In: User cancelled sign-in');
        return null;
      }

      _user = finalGoogleUser;
      final googleAuth = await finalGoogleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Send to backend to get JWT token
      final response = await http.post(
        Uri.parse(OauthUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': finalGoogleUser.email,
          'name': finalGoogleUser.displayName,
          'googleId': finalGoogleUser.id,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        print('Backend error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      // Handle specific errors
      if (e.toString().contains('unknown_reason')) {
        print(
          'Google Sign-In failed due to unknown reason. This might be due to client ID configuration or CORS issues.',
        );
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Google Sign-Out Error: $e');
      rethrow;
    }
  }
}
