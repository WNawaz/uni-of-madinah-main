import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/admin_service.dart';
import 'package:uni_of_madinah/services/authentication_service.dart';
import 'package:uni_of_madinah/services/database_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';
import 'package:uni_of_madinah/services/volunteer_service.dart';

enum SignInProvider {
  emailAndPassword,
  google,
  apple,
}

class SignInService {
  final String serviceIdentifier = "SignInService |";
  final AuthenticationService authenticationService =
      getIt<AuthenticationService>();
  final DatabaseService databaseService = getIt<DatabaseService>();
  final UserService userService = getIt<UserService>();
  final VolunteerService volunteerService = getIt<VolunteerService>();

  Future<bool> signInUser(
      {required SignInProvider provider,
      String? email,
      String? password}) async {
    print("$serviceIdentifier signing in ${provider.name}");
    try {
      UserCredential? userData;

      switch (provider) {
        case SignInProvider.emailAndPassword:
          if (email == null || password == null) {
            return false;
          }
          userData = await authenticationService.signInWithEmailPassword(
              email, password);
          break;

        case SignInProvider.google:
          userData = await authenticationService.signInWithGoogle();
          break;

        case SignInProvider.apple:
          userData = await authenticationService.signInWithApple();
          break;

        default:
          print("no provider compatible provider was specified");
          return false;
      }

      if (userData == null) {
        await authenticationService.signoutUser();
        throw "User sign in failed";
      }

      final AdminService adminService = getIt<AdminService>();
      await Future.wait([
        adminService.fetchAdminStatus(),
        volunteerService.checkVolunteer(userData.user!.email!),
      ]);
      return true;
    } catch (e) {
      String errorMessage = e.toString();

      if (errorMessage.contains("firebase_auth/")) {
        errorMessage = errorMessage.replaceAll("firebase_auth/", "");
      }

      print("An error occurred while signing in user $e");
      Get.showSnackbar(
        GetSnackBar(
          message: errorMessage,
          snackStyle: SnackStyle.GROUNDED,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}
