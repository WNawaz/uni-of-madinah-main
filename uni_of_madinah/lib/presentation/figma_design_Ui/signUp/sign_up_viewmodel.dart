import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/signIn/sign_in.dart';
import 'package:uni_of_madinah/presentation/welcome%20screen/welcome.dart';
import 'package:uni_of_madinah/services/signup_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';

class SignUpViewModel extends BaseViewModel {
  final SignupService signupService = getIt<SignupService>();

  final UserService userService = getIt<UserService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool signingUp = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<bool> signupWithGoogle() async {
    try {
      signingUp = true;
      notifyListeners();
      final bool signedUp = await signupService.signUpWithGoogle();

      signingUp = false;
      notifyListeners();
      signupService.requiresEmailVerification = true;

      if (signedUp) {
        Get.offAll(const WelcomeScreen());
      } else {
        print('Failed to sign up with Google.');
      }

      return true;
    } catch (e) {
      print('Failed to sign in with Google: $e');
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword() async {
    try {
      signupService.setEmail(emailController.text);
      signupService.setFullName(nameController.text);
      signupService.setPassword(passwordController.text);

      signingUp = true;
      notifyListeners();

      print("Validating form");
      if (!formKey.currentState!.validate()) {
        // Form is valid, you can perform your submission logic here
        Get.showSnackbar(const GetSnackBar(
          message: "Form values are wrong",
          duration: Duration(seconds: 2),
        ));
        signingUp = false;
        notifyListeners();
        return false;
      }

      final bool singedUp = await signupService.signUpWithEmailAndPassword();

      signingUp = false;
      notifyListeners();

      if (singedUp) {
        //Set email verification status in Firestore to false
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userService.user!.uid)
            .set({
          'emailVerifiedInApp': false,
        }, SetOptions(merge: true));

        Get.offAll(const WelcomeScreen());
      }

      return true;
    } catch (e) {
      signingUp = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithApple() async {
    try {
      signingUp = true;
      notifyListeners();
      final bool response = await signupService.signUpWithApple();

      signingUp = false;
      notifyListeners();

      signupService.requiresEmailVerification = true;

      if (response) {
        Get.offAll(const WelcomeScreen());
      } else {
        print('Failed to sign up with Apple.');
      }
      return true;
    } catch (e) {
      print('Failed to sign up with Apple: $e');
      return false;
    }
  }
}
