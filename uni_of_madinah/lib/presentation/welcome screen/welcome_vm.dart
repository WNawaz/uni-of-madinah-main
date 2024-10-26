import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/volunteer_service.dart';

class WelcomeScreenViewModel extends BaseViewModel {
  bool isVolunteer = false;
  bool isSignedIn = false;

  void initialise() {
    // Add your initialisation code here
    final volunteerService = getIt<VolunteerService>();
    setIsVolunteer(volunteerService.isVolunteer);
  }

  void setIsVolunteer(bool value) {
    isVolunteer = value;
    notifyListeners();
  }
}
