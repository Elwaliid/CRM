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
      // Use signInSilently first (recommended for web)
      final silentUser = await googleSignIn.signInSilently();
      if (silentUser != null) {
        _user = silentUser;
        return await _processGoogleUser(silentUser);
      }

      // If silent sign-in fails, use signIn
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('Google Sign-In: User cancelled sign-in');
        return null;
      }

      _user = googleUser;
      return await _processGoogleUser(googleUser);
    } catch (e) {
      print('Google Sign-In Error: $e');
      // Handle specific errors
      if (e.toString().contains('unknown_reason')) {
        print(
          'Google Sign-In failed due to unknown reason. This might be due to client ID configuration or CORS issues.',
        );
      } else if (e.toString().contains('popup_closed_by_user')) {
        print('User closed the popup before completing sign-in');
      } else if (e.toString().contains('network_error')) {
        print('Network error during Google Sign-In');
      }
      rethrow;
    }
  }

  Future<String?> _processGoogleUser(GoogleSignInAccount googleUser) async {
    try {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Send to backend to get JWT token
      final response = await http.post(
        Uri.parse(OauthUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': googleUser.email,
          'name': googleUser.displayName,
          'googleId': googleUser.id,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          return data['token'];
        } else {
          print('Backend error: ${response.body}');
          return null;
        }
      } else {
        print('Backend error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error processing Google user: $e');
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
