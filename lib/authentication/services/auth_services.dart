import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fureverhome/users/registered_user.dart';

class AuthService {
  Future<bool> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create user
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Hide loading dialog
      Navigator.pop(context);

      if (userCredential.user != null) {
        // Successfully created user
        Fluttertoast.showToast(msg: "Account created successfully!");
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      // Hide loading dialog
      Navigator.pop(context);

      String message = '';
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak';
          break;
        case 'email-already-in-use':
          message = 'An account already exists with that email';
          break;
        case 'invalid-email':
          message = 'The email address is not valid';
          break;
        default:
          message = 'An error occurred during registration';
      }
      Fluttertoast.showToast(msg: message);
      return false;
    } catch (e) {
      // Hide loading dialog
      Navigator.pop(context);

      Fluttertoast.showToast(msg: "An unexpected error occurred");
      return false;
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create user
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Hide loading dialog
      Navigator.pop(context);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RegisteredUser()));

    } on FirebaseAuthException catch (e) {
      // Hide loading dialog
      Navigator.pop(context);

      String message = '';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found in that email';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user';
          break;
        case 'invalid-email':
          message = 'The email address is not valid';
          break;
        default:
          message = 'An error occurred during Logging in';
      }
      Fluttertoast.showToast(msg: message);
    } catch (e) {
      // Hide loading dialog
      Navigator.pop(context);

      Fluttertoast.showToast(msg: "An unexpected error occurred");
    }
  }
}