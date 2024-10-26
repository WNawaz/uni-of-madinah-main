// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:stacked/stacked.dart';
// import 'package:uni_of_madinah/dependancy_injection.dart';
// import 'package:uni_of_madinah/presentation/figma_design_Ui/search/search.dart';
// import 'package:uni_of_madinah/presentation/figma_design_Ui/signIn/sign_in.dart';
// import 'package:uni_of_madinah/services/admin_service.dart';
// import 'package:uni_of_madinah/services/user_service.dart';
// import 'package:uni_of_madinah/services/volunteer_service.dart';

// class StartUpViewModel extends BaseViewModel {
//   bool isSignedIn = false;

//   void updateSignedInStatus(bool value) {
//     isSignedIn = value;
//     notifyListeners();
//   }

//   void init() async {
//     try {
//       setBusy(true);
//       handleStartUpLogic();

//       if (isSignedIn) {
//         // User is signed in
//         print("User is signed in");

//         final volunteerService = getIt<VolunteerService>();
//         final adminService = getIt<AdminService>();
//         final userService = getIt<UserService>();

//         final User? user = FirebaseAuth.instance.currentUser;

//         await Future.wait([
//           volunteerService.checkVolunteer(user!.email!),
//           userService.setUserMemebershipStatus(),
//         ]);

//         if (adminService.isAdmin) {
//           volunteerService.isVolunteer = true;
//         }
//       } else {
//         // User is not signed in
//         print("User is not signed in");
//       }

//       setBusy(false);
//     } catch (e) {
//       setBusy(false);
//       print("An error occured while init: $e");
//     }
//   }

//   void handleGetStartedTap() {
//     // Add your logic here
//     if (isSignedIn) {
//       // User is signed in
//       Get.to(const SearchScreen());
//     } else {
//       // User is not signed in
//       print("User is not signed in");
//       Get.to(const SignInView());
//     }
//   }

//   Future handleStartUpLogic() async {
//     try {
//       final FirebaseAuth _auth = FirebaseAuth.instance;
//       final User? user = _auth.currentUser;
//       final volunteerService = getIt<VolunteerService>();
//      final userService = getIt<UserService>();

//       if (user != null) {
//         // User is signed in
//         print("User is signed in");
//         updateSignedInStatus(true);
//         await Future.wait([
//           volunteerService.checkVolunteer(user!.email!),
//           userService.setUserMemebershipStatus(),
//         ]);
//       } else {
//         // User is not signed in
//         print("User is not signed in");
//         updateSignedInStatus(false);
//       }
//     } catch (e) {
//       print("An error occured while init: $e");
//     }
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/search/search.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/signIn/sign_in.dart';
import 'package:uni_of_madinah/services/admin_service.dart';
import 'package:uni_of_madinah/services/revenuecat_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';
import 'package:uni_of_madinah/services/volunteer_service.dart';

class StartUpViewModel extends BaseViewModel {
  bool isSignedIn = false;

  void updateSignedInStatus(bool value) {
    isSignedIn = value;
    notifyListeners();
  }

  Future<void> init() async {
    try {
      setBusy(true);
      await handleStartUpLogic();
      setBusy(false);
    } catch (e) {
      setBusy(false);
      print("An error occurred during init: $e");
    }
  }

  void handleGetStartedTap() {
    if (isSignedIn) {
      // User is signed in
      Get.offAll(const SearchScreen());
    } else {
      // User is not signed in
      Get.to(const SignInView());
    }
  }

  Future<void> handleStartUpLogic() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      if (user != null) {
        // User is signed in
        updateSignedInStatus(true);
        final volunteerService = getIt<VolunteerService>();
        final userService = getIt<UserService>();
        final adminService = getIt<AdminService>();
        final revenuecatService = getIt<RevenuecatService>();

        await Future.wait([
          volunteerService.checkVolunteer(user.email!),
          userService.setUserMembershipStatus(),
          adminService.fetchAdminStatus(),
          revenuecatService.getCurrentSubscription()
        ]);
        userService.updateUserPremiumStatus(
            await revenuecatService.getCustomerPurchaseStatus());

        // Check if the user is an admin and set volunteer status accordingly
        if (adminService.isAdmin) {
          volunteerService.isVolunteer = true;
        }
      } else {
        // User is not signed in
        updateSignedInStatus(false);
      }
    } catch (e) {
      print("An error occurred during startup logic: $e");
    }
  }
}
