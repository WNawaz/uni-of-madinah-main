// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/welcome%20screen/welcome.dart';
import 'package:uni_of_madinah/services/user_service.dart';

class EmailVerficationViewModel extends BaseViewModel {
  final UserService userService = getIt<UserService>();
  late Stream<User?> userStream;
  bool isVerifyingEmail = false;

  Future<void> sendVerificationEmail() async {
    try {
      User? user = userService.user;
      if (user!.emailVerified) {
        print("User's email is verified");
      } else {
        print("Sending email for verification");
        await user.sendEmailVerification();
      }
    } catch (e) {
      print("An error occurred while sending email for verification $e");
    }
  }

  hanldeNextTap() async {
    try {
      updateIsVerifyingEmail();
      await FirebaseAuth.instance.currentUser!.reload();
      final bool isEmailVerified =
          FirebaseAuth.instance.currentUser!.emailVerified;
      if (isEmailVerified) {
        updateIsVerifyingEmail();
        Get.offAll(const WelcomeScreen());
      } else {
        updateIsVerifyingEmail();

        Get.showSnackbar(const GetSnackBar(
          message: "Please verify your email email address",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          snackStyle: SnackStyle.GROUNDED,
        ));
      }
    } catch (e) {
      print("An error occurred while getting the account verification $e");
      updateIsVerifyingEmail();

      Get.showSnackbar(GetSnackBar(
        message: "Error: $e",
        snackStyle: SnackStyle.GROUNDED,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ));
    }
  }

  updateIsVerifyingEmail() {
    isVerifyingEmail = !isVerifyingEmail;
    notifyListeners();
  }
}
