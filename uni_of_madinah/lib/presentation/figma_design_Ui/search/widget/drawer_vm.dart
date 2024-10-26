import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/acknowledgements/acknowledgements.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/add_volunteer/add_volunteer.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/paywall/paywall.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/profile/profile.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/subscription/subscription_view.dart';
import 'package:uni_of_madinah/presentation/welcome%20screen/welcome.dart';
import 'package:uni_of_madinah/services/admin_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerVM extends BaseViewModel {
  bool isAdmin = false;
  bool isPremium = false;
  int selectedIndex = -1;
  bool isLoggingOut = false;
  final UserService userService = getIt<UserService>();

  void init() {
    try {
      setBusy(true);
      final adminService = getIt<AdminService>();

      isAdmin = adminService.getAdmin();
      isPremium = userService.isPremium;
      notifyListeners();
      setBusy(false);
    } catch (e) {
      print(
        'Error in DrawerVM.init: $e',
      );
    }
  }

  void handleSelectTap(int index) async {
    selectedIndex = index;
    notifyListeners();

    Get.back();

    if (index == 0) {
      Get.to(const AddVolunteer());
    } else if (index == 1) {
      const termsUrl =
          'https://docs.google.com/document/d/1kSBeeAPumLpsO7Q6WwTMqMbAeXtw1p7gFihxhZn2qAo/edit?usp=sharing';
      if (await canLaunch(termsUrl)) {
        await launch(termsUrl);
      } else {
        throw 'Could not launch $termsUrl';
      }
    } else if (index == 2) {
      const privacyUrl =
          'https://docs.google.com/document/d/15MI5-a0_5SrATpoXLFsDOSoqY-Fbqeg8Hxn7sQIl88I/edit?usp=sharing';
      if (await canLaunch(privacyUrl)) {
        await launch(privacyUrl);
      } else {
        throw 'Could not launch $privacyUrl';
      }
    } else if (index == 3) {
      Get.to(const AcknowledgementsScreen());
    } else if (index == 4) {
      if (isPremium) {
        Get.to(const SubscriptionView());
      } else {
        showCupertinoModalBottomSheet(
          context: Get.overlayContext!,
          builder: (BuildContext context) {
            return const MyBottomSheet();
          },
          expand: false,
          useRootNavigator: true,
        );
      }
    } else if (index == 5) {
      Get.to(const ProfileScreen());
    }
  }

  Future<void> handleLogoutTap() async {
    try {
      isLoggingOut = true;
      notifyListeners();
      await Future.delayed(Duration(seconds: 2));

      final FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signOut();

      if (_auth.currentUser == null) {
        print('User logged out successfully');
        Get.offAll(const WelcomeScreen());
      } else {
        print('Error logging out user');
      }
    } catch (e) {
      print('Error in DrawerVM.handleLogoutTap: $e');
    } finally {
      isLoggingOut = false;
      notifyListeners();
    }
  }
}
