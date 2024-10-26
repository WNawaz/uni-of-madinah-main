import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

class VolunteerService with ListenableServiceMixin {
  final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  bool isVolunteer = false;

  VolunteerService() {
    listenToReactiveValues([isVolunteer]);
  }

  Future<void> addVolunteerEmail(String email) async {
    try {
      // Trim and validate email
      email = email.trim();
      if (email.isEmpty) {
        print('Error: Email is empty');
        return;
      }
      CollectionReference volunteers =
          _firebaseFirestoreInstance.collection('volunteer');
      await volunteers.add({
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Email added to Firebase collection "volunteer"');
    } catch (e) {
      print('Error adding email to Firebase: $e');
    }
  }

  Future<void> deleteVolunteerEmail(String email) async {
    try {
      await _firebaseFirestoreInstance
          .collection('volunteer')
          .where('email', isEqualTo: email)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      print('Volunteer with email $email deleted from Firestore');
    } catch (e) {
      print('Error deleting volunteer from Firestore: $e');
    }
  }

  Future<bool> checkVolunteer(String userEmail) async {
    try {
      final QuerySnapshot result = await _firebaseFirestoreInstance
          .collection('volunteer')
          .where('email', isEqualTo: userEmail)
          .get();

      isVolunteer = result.docs.isNotEmpty;
      print('Is user a volunteer? $isVolunteer');
      return isVolunteer;
    } catch (e) {
      print('Error checking volunteer status: $e');
      return false;
    }
  }

  Future<List<String>> fetchVolunteers() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestoreInstance
          .collection('volunteer')
          .orderBy('timestamp', descending: true)
          .get();
      List<String> volunteerEmails =
          querySnapshot.docs.map((doc) => doc['email'].toString()).toList();
      return volunteerEmails;
    } catch (e) {
      print('Error fetching volunteers from Firestore: $e');
      return [];
    }
  }
}
