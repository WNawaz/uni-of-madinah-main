// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/email_verification/email_verification.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/search/search.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/signUp/sign_up_viewmodel.dart';
import 'package:uni_of_madinah/presentation/welcome%20screen/welcome.dart';
import 'package:uni_of_madinah/services/database_service.dart';
import 'package:uni_of_madinah/services/signin_service.dart';
import 'package:uni_of_madinah/services/signup_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';

class SignInViewModel extends BaseViewModel {
  final SignInService signInService = getIt<SignInService>();
  final UserService userService = getIt<UserService>();
  final SignupService signupService = getIt<SignupService>();
  final DatabaseService dataBaseService = getIt<DatabaseService>();
  final SignUpViewModel viewModel = SignUpViewModel();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSigningIn = false;
  Future<void> signIn() async {
    updateSiginStatus();

    final email = emailController.text;
    final password = passwordController.text;
    try {
      print("Validating form");
      if (!formKey.currentState!.validate()) {
        Get.showSnackbar(const GetSnackBar(
          message: "Form values are wrong",
          duration: Duration(seconds: 2),
        ));
        isSigningIn = false;
        notifyListeners();
        return;
      }

      print("Signing in with email and password");
      final bool isSignedIn = await signInService.signInUser(
        provider: SignInProvider.emailAndPassword,
        email: email,
        password: password,
      );

      updateSiginStatus();

      if (isSignedIn) {
        if (signupService.requiresEmailVerification) {
          // If email verification is required, navigate to EmailVerification
          Get.to(const SearchScreen());
        } else {
          // Otherwise, navigate to SmartAiView
          Get.offAll(const SearchScreen());
        }
      } else {
        print('Failed to sign in.');
      }
    } catch (e) {
      updateSiginStatus();
      print('Failed to sign in: $e');
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      updateSiginStatus();

      // check the user is signed in before proceeding
      final bool signedIn =
          await signInService.signInUser(provider: SignInProvider.google);

      if (!signedIn) {
        print('Failed to sign in with Google.');
        updateSiginStatus();
        return false;
      }

      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String userId = user.uid;

        // Check if the user's profile exists in the database
        final bool profileExists =
            await dataBaseService.checkUserProfileExists(userId);

        if (profileExists) {
          Get.offAll(SearchScreen());
        } else {
          // Create a new account since the profile doesn't exist
          bool signUpSuccess = await viewModel.signupWithGoogle();
          if (signUpSuccess) {
            Get.offAll(SearchScreen());
          } else {
            print('Failed to sign up with Google.');
          }
        }

        updateSiginStatus();
        return true;
      } else {
        print('User object is null.');
        updateSiginStatus();
        return false;
      }
    } catch (e) {
      updateSiginStatus();
      print('Failed to sign in with Google: $e');
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      print("Signing in with Apple");
      updateSiginStatus();

      // Check if the user is signed in before proceeding
      final bool signedIn =
          await signInService.signInUser(provider: SignInProvider.apple);

      if (!signedIn) {
        print('Failed to sign in with Apple.');
        updateSiginStatus();
        return false;
      }

      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String userId = user.uid;

        // Check if the user's profile exists in the database
        final bool profileExists =
            await dataBaseService.checkUserProfileExists(userId);

        if (profileExists) {
          Get.offAll(const SearchScreen());
        } else {
          // Create a new account since the profile doesn't exist
          bool signUpSuccess = await viewModel.signUpWithApple();
          if (signUpSuccess) {
            Get.offAll(const SearchScreen());
          } else {
            print('Failed to sign up with Apple.');
          }
        }

        updateSiginStatus();
        return true;
      } else {
        print('User object is null.');
        updateSiginStatus();
        return false;
      }
    } catch (e) {
      updateSiginStatus();
      print('Failed to sign in with Apple: $e');
      return false;
    }
  }

  updateSiginStatus() {
    isSigningIn = !isSigningIn;
    notifyListeners();
  }
}
