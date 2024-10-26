// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';

// class ChangePasswordViewModel extends BaseViewModel {
//   TextEditingController previousPasswordController = TextEditingController();
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmNewPasswordController = TextEditingController();

//   bool obscurePreviousPassword = true;
//   bool obscureNewPassword = true;
//   bool obscureConfirmNewPassword = true;

//   void toggleObscurePreviousPassword() {
//     obscurePreviousPassword = !obscurePreviousPassword;
//     notifyListeners();
//   }

//   void toggleObscureNewPassword() {
//     obscureNewPassword = !obscureNewPassword;
//     notifyListeners();
//   }

//   void toggleObscureConfirmNewPassword() {
//     obscureConfirmNewPassword = !obscureConfirmNewPassword;
//     notifyListeners();
//   }

//   void changePassword() {
//     // Implement password change logic here
//     String previousPassword = previousPasswordController.text;
//     String newPassword = newPasswordController.text;
//     String confirmNewPassword = confirmNewPasswordController.text;

//     // Add your logic for changing the password
//   }

//   @override
//   void dispose() {
//     previousPasswordController.dispose();
//     newPasswordController.dispose();
//     confirmNewPasswordController.dispose();
//     super.dispose();
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}
