import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/signIn/sign_in.dart';

import 'package:uni_of_madinah/services/search_content_service.dart';

import '../../welcome screen/welcome.dart';

class ProfileVm extends ReactiveViewModel {
  final TextEditingController searchController = TextEditingController();
  final SearchContentService searchContentService =
      getIt<SearchContentService>();

  String userName = "";
  String password = "";
  String email = "";
  bool isDeletingAccount = false;

  void init() async {
    try {
      setUserData();
    } catch (e) {
      print("An error occured while init: $e");
    }
  }

  void setUserData() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null && user.displayName != null && user.email != null) {
      userName = user.displayName!;
      email = user.email!;
      notifyListeners();
    }
  }

  Future<void> handleDeleteAccountTap(BuildContext context) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      if (user != null) {
        // Existing confirmation dialog code
        bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Account'),
              content: const Text(
                'Are you sure you want to delete your account? This action cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );

        if (confirm == true) {
          isDeletingAccount = true;
          notifyListeners();

          // Deleting user data from Firestore
          final firestore = FirebaseFirestore.instance;
          final userId = user.uid;

          await firestore.collection('users').doc(userId).delete();
          await user.delete(); // Delete the Firebase user account

          await _auth.signOut();
          Get.offAll(
              const WelcomeScreen()); // Navigate to welcome screen after sign out
        }
      } else {
        // Show dialog for sign in
        bool? signInConfirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Not Signed In'),
              content: const Text(
                  'You are not signed in as any account. Would you like to sign in?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Get.to(const SignInView());
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );

        if (signInConfirmed == true) {
          // User chose to sign in, handle any additional logic if needed
        }
      }
    } catch (e) {
      print('Error in ProfileVm.handleDeleteAccountTap: $e');
    } finally {
      isDeletingAccount = false;
      notifyListeners();
    }
  }
}
