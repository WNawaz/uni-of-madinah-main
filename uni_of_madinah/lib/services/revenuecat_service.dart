import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/user_service.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenuecatService {
  List<Package> activeOfferings = [];
  bool checkForMembership = false;
  late String subscriptionType;

  RevenuecatService() {
    initialiseRevenuecatSDK().then((value) {
      setupCustomerInfoUpdateListener();

      getSubscriptionPeriodType();
      // add a delay before navigating, the flow can be improved to check membership earlier
      Future.delayed(const Duration(seconds: 1))
          .then((_) => setCustomerUpdates());
    });
  }

  Future<void> initialiseRevenuecatSDK() async {
    try {
      late PurchasesConfiguration configuration;
      if (Platform.isAndroid) {
        configuration =
            PurchasesConfiguration("goog_BozMPRnVuUvBgdNkWEeRsxiToqe");
      } else if (Platform.isIOS) {
        configuration =
            PurchasesConfiguration("appl_OPQTcLpmpGXdMzxvpiofILFNOft");
      }

      await Purchases.configure(configuration);
      // Later log in provided user Id

      await Purchases.logIn(FirebaseAuth.instance.currentUser!.uid);

      await Purchases.setDebugLogsEnabled(true);
    } catch (e) {
      print("An error occurred while initialising Revenuecat sdk  $e");
    }
  }

  void setupCustomerInfoUpdateListener() {
    try {
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        setCustomerUpdates();
      });
      print("Customer info update listener setup");
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setCustomerUpdates() async {
    final UserService userService = getIt<UserService>();

    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final EntitlementInfo? entitlement =
          customerInfo.entitlements.active['premium'];

      if (entitlement != null) {
        print("**** User has premium access *****");
        userService.isPremium = true;
        return true;
      } else {
        print("**** User does not have premium access *****");
        userService.isPremium = false;
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllSubscriptionOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        print("Offering fetched: ");
        offerings.current!.availablePackages.forEach((package) {
          print(package);
        });
        activeOfferings = offerings.current!.availablePackages;
      } else {
        print("No active offerings found");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> getAllSubscriptionOfferings() async {
  //   try {
  //     Offerings offerings = await Purchases.getOfferings();
  //     if (offerings.current != null &&
  //         offerings.current!.availablePackages.isNotEmpty) {
  //       // Display packages for sale
  //       print("Offering fetched: ");
  //       print(offerings.current!.availablePackages);
  //       activeOfferings = offerings.current!.availablePackages;

  //       // add dummy data to active offerings
  //       // activeOfferings.add(
  //       //   Package.fromJson(
  //       //     {"identifier": "weekly", "product": "com.islamQ.weekly"},
  //       //   ),
  //       // );
  //     } else {
  //       print("No active offerings found");
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<bool> purchaseSubscriptionPlan(int index) async {
    try {
      print("Purchasing package ${activeOfferings[index]}");
      await Purchases.purchaseStoreProduct(activeOfferings[index].storeProduct);
      print("purchased weekly package");
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> restorePurchase() async {
    final UserService userService = getIt<UserService>();

    try {
      print("Purchasing weekly package");
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      print("purchased weekly package");
      final EntitlementInfo? entitlement =
          customerInfo.entitlements.active['premium'];
      if (entitlement == null) {
        print("**** User does not have premium access *****");
        userService.isPremium = false;

        return false;
      }

      print("**** User has premium access *****");
      userService.isPremium = true;
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // Future<String> getCurrentSubscription() async {
  //   try {
  //     final CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
  //     final EntitlementInfo? entitlement =
  //         purchaserInfo.entitlements.active['premium'];
  //     if (entitlement != null) {
  //       final String subscrtipon = purchaserInfo.activeSubscriptions.last;
  //       print("Latest subscription: ${subscrtipon}");
  //       // final expirationDate = entitlement.expiresDate;
  //       // final isCancelled = entitlement.isSandbox &&
  //       //     purchaserInfo.entitlements.all['premium']!.isSandbox;
  //       // if (expirationDate != null && !isCancelled) {
  //       return "$subscrtipon ${entitlement.periodType.name}";
  //       // }
  //     }
  //     return 'Free';
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<String> getCurrentSubscription() async {
    try {
      final CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
      final EntitlementInfo? entitlement =
          purchaserInfo.entitlements.active['premium'];

      if (entitlement != null) {
        final String subscription = purchaserInfo.activeSubscriptions.last;
        print("Latest subscription: $subscription");

        if (subscription == 'premium_monthly_p1m:islamq-monthly-p1m' ||
            subscription == 'premium_monthly_p1m') {
          return 'Monthly';
        } else if (subscription == 'premium_yealry_p1y:islamq-yearly' ||
            subscription == 'premium_yearly_p1y') {
          return 'Yearly';
        } else {
          return 'Unknown';
        }
      }

      return 'Free';
    } catch (e) {
      print("Error fetching current subscription: $e");
      return 'Free';
    }
  }

  Future<String> getSubscriptionPeriodType() async {
    try {
      final CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
      final EntitlementInfo? entitlement =
          purchaserInfo.entitlements.active['premium'];
      if (entitlement != null) {
        subscriptionType = entitlement.periodType.name;
        // subscriptionType = 'normal';
        return subscriptionType;
      }

      return 'free';
    } catch (e) {
      rethrow;
    }
  }

  bool isUserInTrialOrIntro() {
    print("Subscrtipon Type is: $subscriptionType");
    if (subscriptionType == 'trial' || subscriptionType == 'intro') return true;

    return false;
  }

  Future<bool> getCustomerPurchaseStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final EntitlementInfo? entitlement =
          customerInfo.entitlements.active['premium'];
      //  entitlement.

      if (entitlement == null) {
        print("**** User does not have premium access *****");
        return false;
      }

      print("**** User has premium access *****");
      return true;
    } catch (e) {
      rethrow;
    }
  }

  String getSubscriptionDetails(String planName) {
    switch (planName) {
      case "premium_yearly_p1y":
        return '''
        Yearly
      ''';
      case "premium_monthly_p1m":
        return '''
        Monthly
      ''';
      default:
        return '';
    }
  }
}
