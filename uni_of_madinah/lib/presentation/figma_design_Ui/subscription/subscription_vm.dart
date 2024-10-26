// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/revenuecat_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionVM extends ReactiveViewModel {
  final UserService userService = getIt<UserService>();

  final RevenuecatService revenuecatService = getIt<RevenuecatService>();
  int selectedPlan = 0;
  bool isProcessing = false;
  bool isSettingUp = true;

  PayWallVM() {
    revenuecatService.checkForMembership = true;
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [userService];

  setupActivePackages() async {
    try {
      await revenuecatService.getAllSubscriptionOfferings();
      isSettingUp = false;
      notifyListeners();
    } catch (e) {
      isSettingUp = false;

      notifyListeners();
      print("An error occurred while getting all subscription offersings $e");
    }
  }

  handlePackageSelection(int index) {
    try {
      selectedPlan = index;
      notifyListeners();

      // handlePaymentTap();
    } catch (e) {
      print("An error occurred while selecting the package $e");
    }
  }

  handlePaymentTap() async {
    try {
      print("Selected plan: $selectedPlan");
      updateIsProcessing();
      print("Purchasing subscription");

      // Purchase subscription

      final bool isPurchased =
          await revenuecatService.purchaseSubscriptionPlan(selectedPlan);

      updateIsProcessing();
      print("Purchase status: $isPurchased");

      if (isPurchased) {
        final UserService userService = getIt<UserService>();

        // Update user membership status and subscribed plan index
        await userService.setUserMembershipStatus();
        notifyListeners();
        userService.updateUserPremiumStatus;
        notifyListeners();
        print("Membership status updated");
        userService.planNameSubscription;
        print("Subscribe plan index updated");

        notifyListeners();

        Get.back();
      }
    } catch (e) {
      updateIsProcessing();
      print("An error occurred while purchasing the subscription $e");
      Get.showSnackbar(
        const GetSnackBar(
          message: "An error occurred while purchasing subscription",
          backgroundColor: Colors.red,
          snackStyle: SnackStyle.GROUNDED,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String getBillingPeriodString(int index) {
    try {
      String isoBillingPeriod = revenuecatService
          .activeOfferings[index].storeProduct.subscriptionPeriod!;
      print("isoBillingPeriod: $isoBillingPeriod");

      switch (isoBillingPeriod) {
        case "P1M":
          return "Monthly Subscription";
        case "P1Y":
          return "Yearly Subscription";
        default:
          return "Unknown";
      }
    } catch (e) {
      print("An error occurred while getting the billing period string: $e");
      return "Unknown";
    }
  }

  handleRestorePurchaseButtonTap() async {
    final RevenuecatService revenuecatService = getIt<RevenuecatService>();
    try {
      print("Restoring purchase");
      await revenuecatService.restorePurchase();
      print("Purchase restored completed");
    } catch (e) {
      print("An error occurred during restore purchase $e");
    }
  }

  updateIsProcessing() {
    isProcessing = !isProcessing;
    notifyListeners();
  }

  void showCancelSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text("Are you sure you want to cancel your subscription?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                // Check the platform and open the respective URLs
                if (Platform.isIOS) {
                  await launch('https://apps.apple.com/account/subscriptions');
                } else if (Platform.isAndroid) {
                  await launch(
                      'https://play.google.com/store/account/subscriptions');
                }
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Method to cancel the subscription
  Future<void> cancelSubscription() async {
    // Add your code here to handle the cancellation logic
    print("Subscription cancelled");
    // You can call the necessary methods from your revenuecatService or other services
  }

  String getSubscriptionPackageDetails(String planName) {
    switch (planName) {
      case "Monthly":
        return '''
Subscribe and pay 20.00/month
Billed monthly
          ''';
      case "Yearly":
        return '''
Pay one time yealry
Billed yearly
''';
      case "Weekly":
        return '''
Unlimited, chat request
Unlimited, chat response
Unlimited use of prompts
Continue conversation from history
          ''';
      case "Every 3 Months":
        print("Every 3 Months plan details");
        return "";
      case "Every 6 Months":
        print("Every 6 Months plan details");
        return "";
      default:
        print("No plan details found");
        return "";
    }
  }
}
