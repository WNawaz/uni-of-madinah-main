import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/authentication_service.dart';
import 'package:uni_of_madinah/services/database_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';

class SignupService with ListenableServiceMixin {
  String fullName = "";
  String email = "";
  String password = "";
  String? imageUrl;
  File? filePicked;
  bool requiresEmailVerification = false;

  SignupService() {
    listenToReactiveValues([filePicked]);
  }

  setFullName(String name) {
    print("Setting full name: $name");
    fullName = name;
  }

  setEmail(String mail) {
    print("Setting email: $mail");

    email = mail;
  }

  setPassword(String pass) {
    print("Setting password $pass");

    password = pass;
  }

  setImageUrl(String image) {
    print("Setting image url name");
    imageUrl = image;
  }

  Future<bool> signUpWithEmailAndPassword() async {
    final AuthenticationService authenticationService =
        getIt<AuthenticationService>();
    final DatabaseService databaseService = getIt<DatabaseService>();
    final UserService userService = getIt<UserService>();

    try {
      print("Signing up user");

      final UserCredential? creds =
          await authenticationService.signUpWithEmailPassword(
        email: email,
        password: password,
      );

      if (creds == null) {
        return false;
      }

      await creds.user!.updateDisplayName(fullName);

      final UserCredential? updatedCreds =
          await authenticationService.signInWithEmailPassword(email, password);

      if (updatedCreds == null) {
        return false;
      }

      final bool isDocCreated =
          await databaseService.createUserDocument(updatedCreds);

      if (!isDocCreated) {
        return false;
      }

      userService.setUser(updatedCreds);

      requiresEmailVerification = true;

      print("Signup successful");
      return true;
    } catch (e) {
      print("An error occurred while signing up user $e");
      return false;
    }
  }

  Future<bool> signUpWithGoogle() async {
    final AuthenticationService authenticationService =
        getIt<AuthenticationService>();
    final DatabaseService databaseService = getIt<DatabaseService>();
    final UserService userService = getIt<UserService>();

    try {
      print("Signing up user using google");

      final UserCredential? creds =
          await authenticationService.signInWithGoogle();

      if (creds == null) {
        return false;
      }
      final User user = creds.user!;
      fullName = user.displayName!;
      final bool isDocCreated = await databaseService.createUserDocument(creds);

      if (!isDocCreated) {
        return false;
      }

      userService.setUser(creds);

      print("Signup successful");
      return true;
    } catch (e) {
      print("An error occurred while signing up user $e");
      return false;
    }
  }

  Future<bool> signUpWithApple() async {
    final AuthenticationService authenticationService =
        getIt<AuthenticationService>();
    final DatabaseService databaseService = getIt<DatabaseService>();
    final UserService userService = getIt<UserService>();

    try {
      print("Signing up user with apple");

      final UserCredential? creds =
          await authenticationService.signInWithApple();

      if (creds == null) {
        return false;
      }

      final bool isDocCreated = await databaseService.createUserDocument(creds);

      if (!isDocCreated) {
        return false;
      }

      userService.setUser(creds);

      print("Signup successful");
      return true;
    } catch (e) {
      print("An error occurred while signing up user $e");
      return false;
    }
  }
}
