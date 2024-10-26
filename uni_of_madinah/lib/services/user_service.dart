// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/database_service.dart';
import 'package:uni_of_madinah/services/revenuecat_service.dart';

class UserService with ListenableServiceMixin {
  User? _user;
  bool isUsingPhoto = true;
  String? nameInitials;
  bool isPremium = false;
  String planNameSubscription = "";
  String userJoiningData = "";
  int tokensAvailable = 0;

  User? get user => _user;
  int? _subscribedPlanIndex;

  int? get subscribedPlanIndex => _subscribedPlanIndex;

  void setSubscribedPlanIndex(int index) {
    _subscribedPlanIndex = index;
    notifyListeners();
  }

  bool get isPrmium => isPremium;

  UserService() {
    listenToReactiveValues(
        [_user, isUsingPhoto, isPremium, planNameSubscription]);
  }

  updateIsUsingPhoto(bool val) {
    isUsingPhoto = val;
    notifyListeners();
  }

  setUserWithUserObject(User user) {
    _user = user;
    notifyListeners();
  }

  setUser(UserCredential user) {
    _user = user.user;
    print("User set, user details: ");
    printUserProperties(_user!);
  }

  tryAutoLogin(User user) async {
    try {
      setUserWithUserObject(user);
      await setIsUsingNameInitials();
    } catch (e) {
      print("An error has occurred while trying to auto-login: $e");
    }
  }

  final FirebaseAuth instance = FirebaseAuth.instance;
  late SharedPreferences prefs;

  SnackbarController showGetSnackbar(Object e) {
    return Get.showSnackbar(GetSnackBar(
      message: e.toString(),
      snackStyle: SnackStyle.GROUNDED,
      duration: Duration(seconds: 2),
    ));
  }

  // Function to set Firebase Auth user in shared preferences
  Future<void> setFirebaseAuthUser(
    String email,
    String pass,
    String fullName,
    bool isUsingProfileImage,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'firebaseUser',
        jsonEncode(
          {
            // "email": email,
            // "pass": pass,
            // "fullName": fullName,
            "isUsingProfileImage": isUsingProfileImage,
          },
        ),
      );
      print('Firebase Auth user set in shared preferences');
    } catch (e) {
      print(
          "An error occurred while setting Firebase Auth user in shared preferences $e");
      showGetSnackbar(e);
    }
  }

// Function to get Firebase Auth user from shared preferences
  Future<String?> getFirebaseAuthUser() async {
    try {
      prefs = await SharedPreferences.getInstance();

      String? userId = prefs.getString('firebaseUser');

      if (userId == null) return null;

      var userData = jsonDecode(userId);
      print('Firebase Auth user retrieved from shared preferences: $userData');
      return userData;
    } catch (e) {
      print(
          "An error occurred while retrieving Firebase Auth user from shared preferences $e");
      showGetSnackbar(e);
      return null;
    }
  }

  Future<bool> updateUserData(Map<String, dynamic> newData) async {
    try {
      final String uid = _user!.uid;
      print("Uid: $uid");
      final DatabaseService databaseService = getIt<DatabaseService>();
      await databaseService.updateUserData(newData: newData, uid: uid);

      String? firebaseUser = prefs.getString('firebaseUser');
      if (firebaseUser != null) {
        Map<String, dynamic> userData = jsonDecode(firebaseUser);
        userData.addAll(newData);
        await prefs.setString('firebaseUser', jsonEncode(userData));
        print('User data updated in shared preferences');
      }

      isUsingPhoto = newData["isUsingProfileImage"];
      return true;
    } catch (e) {
      print("An error occurred while updating user data: $e");
      return false;
    }
  }

  void printUserProperties(User user) {
    print('User ID: ${user.uid}');
    print('Email: ${user.email}');
    print('Display Name: ${user.displayName}');
    print('Photo URL: ${user.photoURL}');
    print('Email Verified: ${user.emailVerified}');
    print('Is Anonymous: ${user.isAnonymous}');
    print('Provider Data:');
    for (UserInfo userInfo in user.providerData) {
      print('  Provider ID: ${userInfo.providerId}');
      print('  UID: ${userInfo.uid}');
      print('  Display Name: ${userInfo.displayName}');
      print('  Photo URL: ${userInfo.photoURL}');
      print('  Email: ${userInfo.email}');
      print('  Phone Number: ${userInfo.phoneNumber}');
      print('  ');
    }
  }

  Future<bool> setIsUsingNameInitials() async {
    prefs = await SharedPreferences.getInstance();

    String? localData = prefs.getString('firebaseUser');

    if (localData == null) {
      print("localData is null");
      return false;
    }

    print("Local data: $localData");

    Map<String, dynamic> userData = jsonDecode(localData);
    print('Local data decoded: $userData, data type: ${userData.runtimeType}');

    final bool usingProfilePhoto = userData["isUsingProfileImage"];

    print("is using profile photo: $usingProfilePhoto");
    isUsingPhoto = usingProfilePhoto;

    nameInitials = extractInitials(user!.displayName!);

    return true;
  }

  String extractInitials(String fullName) {
    List<String> words = fullName.split(' ');
    String initials = '';

    for (String word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toUpperCase();
      }
    }

    return initials;
  }

  Future<bool> setIsUsingNameInitialsFromSignin(
      bool isUsingNameInitials) async {
    print("is using profile photo: $isUsingNameInitials");

    if (user!.photoURL == null) {
      isUsingPhoto = false;
      notifyListeners();

      return false;
    }

    isUsingPhoto = !isUsingNameInitials;

    if (isUsingNameInitials) {
      print("Setting name initials");
      nameInitials = extractInitials(user!.displayName!);
    }
    notifyListeners();
    return true;
  }

  // write a fucntion which uses Firebase Auth user to issue a change passwordr request for the userFuture<void> changePassword(String newPassword) async {
  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    try {
      // Create a credential
      AuthCredential credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: currentPassword,
      );

      // Re-authenticate the user
      UserCredential result =
          await _user!.reauthenticateWithCredential(credential);

      // Check if re-authentication is successful
      if (result.user != null) {
        // Check if new password equals confirm password
        if (newPassword == confirmPassword) {
          // Update the password
          await _user!.updatePassword(newPassword);
          print('Password updated successfully');
        } else {
          print('New password and confirm password do not match');
          showGetSnackbar('New password and confirm password do not match');
        }
      } else {
        print('Current password is incorrect');
        showGetSnackbar('Current password is incorrect');
      }
    } catch (e) {
      print('An error occurred while changing the password: $e');
      showGetSnackbar(e);
    }
  }

  Future<void> setUserSettingsData() async {
    final DatabaseService databaseService = getIt<DatabaseService>();
    final RevenuecatService revenuecatService = getIt<RevenuecatService>();

    try {
      final data = await databaseService.getUserDocument(user!.email!);

      final Timestamp joiningDate = data!["createdAt"];
      userJoiningData = DateFormat("M/d/y").format(joiningDate.toDate());
      isUsingPhoto = data["isUsingProfileImage"];
      await revenuecatService.setCustomerUpdates();
      notifyListeners();
    } catch (e) {
      print("An error occurred while setting the user settings data $e ");
    }
  }

  // Future<void> setUserMemebershipStatus() async {
  //   final RevenuecatService revenuecatService = getIt<RevenuecatService>();
  //   try {
  //     isPremium = await revenuecatService.getCustomerPurchaseStatus();
  //     print("User purchase status set to: $isPremium");
  //     notifyListeners();
  //   } catch (e) {
  //     print("An error occurred while setting the user purchase status $e ");
  //   }
  // }

  Future<void> setUserMembershipStatus() async {
    final RevenuecatService revenuecatService = getIt<RevenuecatService>();
    try {
      isPremium = await revenuecatService.getCustomerPurchaseStatus();
      print("User purchase status set to: $isPremium");

      planNameSubscription = await revenuecatService.getCurrentSubscription();
      print("User Subscribe to plan: $planNameSubscription");
      notifyListeners();
    } catch (e) {
      print("An error occurred while setting the user purchase status $e ");
    }
  }

  updateUserPremiumStatus(bool val) {
    isPremium = val;
    notifyListeners();
  }
}
