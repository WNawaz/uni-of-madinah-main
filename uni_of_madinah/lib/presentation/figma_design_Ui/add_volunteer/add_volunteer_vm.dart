import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/volunteer_service.dart';

class AddVolunteerViewModel extends BaseViewModel {
  List<String> volunteers = [];
  final VolunteerService _volunteerService = getIt<VolunteerService>();

  bool isValidEmail = false;

  final TextEditingController emailController = TextEditingController();

  void deleteVolunteer(int index) async {
    if (index >= 0 && index < volunteers.length) {
      final emailToDelete = volunteers[index];
      // Remove from Firestore
      await _volunteerService.deleteVolunteerEmail(emailToDelete);
      volunteers.removeAt(index);
      notifyListeners();
    }
  }

  void handleEmailFieldChange(String email) {
    if (email.isEmpty) {
      return;
    }

    // valid if the email is a valid email
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(email)) {
      isValidEmail = false;
      notifyListeners();

      return;
    }

    isValidEmail = true;
    notifyListeners();
  }

  Future<void> addVolunteerEmail(String email) async {
    await _volunteerService.addVolunteerEmail(email);
    volunteers.add(email);
    notifyListeners();
  }

  Future<void> fetchVolunteers() async {
    try {
      // Fetch volunteers from Firestore
      List<String> fetchedVolunteers =
          await _volunteerService.fetchVolunteers();
      // Update local list
      volunteers.clear();
      volunteers.addAll(fetchedVolunteers);
      notifyListeners();

      print('Fetched volunteers: $volunteers');
    } catch (e) {
      print('Error fetching volunteers: $e');
    }
  }
}
