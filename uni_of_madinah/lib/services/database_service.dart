// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/user_service.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  final String uid;
  DatabaseService({required this.uid});
  Future<bool> createUserDocument(UserCredential creds) async {
    final User? user = creds.user;
    try {
      print("Creating user document with email: ${user!.email}");
      final userData = await getUserDocumentWithId(user.uid);

      if (userData != null) {
        Get.showSnackbar(
          const GetSnackBar(
            message:
                "An account has already been created with this email, please sign in using google",
            snackStyle: SnackStyle.GROUNDED,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      DocumentReference docRef =
          _firebaseFirestoreInstance.collection("users").doc(user.uid);

      docRef.set({
        "fullName": user.displayName,
        "userId": user.uid,
        "createdAt": Timestamp.now(),
        "email": user.email,
        "isUsingProfileImage": true,
      });
      print("user document created successfully");
      return true;
    } catch (e) {
      print("An error occurred error while creating user document $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserDocumentWithId(String uid) async {
    try {
      print("Getting user document with userId: $uid");
      final results =
          await _firebaseFirestoreInstance.collection("users").doc(uid).get();

      if (!results.exists) {
        return null;
      }
      print("user document get with id successfully");
      return results.data();
    } catch (e) {
      print("An error occurred error while creating user document $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDocument(String email) async {
    try {
      print("Getting user document with userId: $email");
      final results = await _firebaseFirestoreInstance
          .collection("users")
          .where(
            "email",
            isEqualTo: email,
          )
          .get();

      if (results.docs.isEmpty) {
        return null;
      }
      print("user document get successfully");
      return results.docs.first.data();
    } catch (e) {
      print("An error occurred error while creating user document $e");
      return null;
    }
  }

  Future<void> deleteUserAccountAndData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      try {
        // Delete user data from Firestore
        FirebaseAuth.instance.currentUser!.delete();

        var userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        // Add logic to delete sub-collections and documents as needed
        await userDocRef.delete();

        // Delete user from Firebase Auth
        await FirebaseAuth.instance.currentUser?.delete();
      } catch (e) {
        print('An error occurred while deleting the user account and data: $e');
        // Optionally, you can handle the error here or show an error message to the user.
      }
    }
  }

  String? _getUserId() {
    final UserService userService = getIt<UserService>();

    try {
      final User? user = userService.user;
      if (user == null) {
        print("User is null cannot get user id");
        return null;
      }

      final String userId = user.uid;
      print("User id: $userId");
      return userId;
    } catch (e) {
      throw "An error occurred while getting user id: $e";
    }
  }

  Future<void> updateUserData(
      {required Map<String, dynamic> newData, required String uid}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(newData, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserProfileExists(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        print('User profile exists for userId: $userId');
        return true;
      } else {
        print('User profile does not exist for userId: $userId');
        return false;
      }
    } catch (e) {
      print('An error occurred while checking user profile: $e');
      return false;
    }
  }
}
