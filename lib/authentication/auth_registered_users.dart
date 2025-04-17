import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<User?> signInWithEmailPassword(String email, String password) async {
  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.getIdToken(true);
    return userCredential.user;
  } catch (e) {
    print('Error signing in: $e');
    return null;
  }
}
// Make sure this function is correctly implemented in auth_registered_users.dart
Future<String?> getIdToken() async {
  try {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in");
      return null;
    }

    // Force refresh the token to ensure it's valid
    final token = await user.getIdToken(true);
    return token;
  } catch (e) {
    print("Error getting token: $e");
    return null;
  }
}
