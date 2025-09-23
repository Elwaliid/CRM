import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSigninProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn(
    clientId:
        "885141582672-tb97ps21m1gjlg7rd2nt94orhbseu228.apps.googleusercontent.com",
  );
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign-In: User cancelled the sign-in process');
        return;
      }

      _user = googleUser;
      print('Google Sign-In: User signed in: ${googleUser.email}');

      final googleAuth = await googleUser.authentication;
      print('Google Sign-In: Got authentication tokens');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      print('Google Sign-In: Successfully signed in with Firebase');
      notifyListeners();
    } catch (e) {
      print('Google Sign-In Error: $e');
      // You can show a snackbar or dialog here to inform the user
      rethrow; // Re-throw to let the UI handle it
    }
  }
}
