// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Sign up with email & password
  Future<UserCredential?> signUpWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final bool isEmailDeleted = await isEmailDeletedPreviously(email);

      if (isEmailDeleted) {
        _showDeletedSnackbar();
        return null;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.showSnackbar(const GetSnackBar(
        message:
            "An account has already been created with this email, please sign in using google",
        snackStyle: SnackStyle.GROUNDED,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return null;
    }
  }

  // Sign up with email & password
  Future<UserCredential?> signInWithGoogleAndRegister() async {
    try {
      final UserCredential? userCredential = await signInWithGoogle();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  // Sign In with email & password
  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      // Request Apple ID
      final AuthorizationCredentialAppleID result =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("apple data: email ${result.email}, fullName: ${result.givenName}");

      // Create an OAuth credential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: result.identityToken,
        accessToken: result.authorizationCode,
      );

      UserCredential? creds = await _auth.signInWithCredential(oauthCredential);

      if (result.email != null && result.familyName != null) {
        print("User creds are: $creds");
        print("User is: ${creds.user}");

        await creds.user!.updateDisplayName(result.givenName);
        await creds.user!.updateEmail(result.email!);
        await creds.user!.reload();
      }

      final String appleEmail = creds.user!.email!;
      final bool isEmailDeleted = await isEmailDeletedPreviously(appleEmail);

      if (isEmailDeleted) {
        _showDeletedSnackbar();
        return null;
      }

      // Sign in with Firebase
      return creds;
    } catch (e) {
      print('Failed to sign in with Apple: $e');
      return null;
    }
  }

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final bool isEmailDeleted = await isEmailDeletedPreviously(
        googleUser.email,
      );

      if (isEmailDeleted) {
        _showDeletedSnackbar();
        return null;
      }

      UserCredential user = await _auth.signInWithCredential(credential);

      if (user.user!.displayName == null) {
        print("User is null after firebase sign in");
        print(user);
        return null;
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> signoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print("An error occurred while signing out user $e");
      return false;
    }
  }

  Future<bool> isEmailDeletedPreviously(String email) async {
    try {
      print("Checking if email is deleted: $email");

      final deletedAccountReferece =
          FirebaseFirestore.instance.collection("deleted_accounts");

      final snapshot =
          await deletedAccountReferece.where("email", isEqualTo: email).get();

      if (snapshot.docs.isNotEmpty) {
        print("Email was found in deleted accounts");
        return true;
      }

      print("Email was not found in deleted accounts");
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("User not found");
        return false;
      }
      return false;
    }
  }

  _showDeletedSnackbar() {
    Get.showSnackbar(const GetSnackBar(
      message:
          "An account with this email has already been deleted, please sign up using a different email or contact support",
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}
