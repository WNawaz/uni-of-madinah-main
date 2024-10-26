import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addVolunteer(String email) async {
    try {
      await _firestore.collection('volunteers').add({
        'email': email,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchVolunteers() async {
    try {
      await _firestore.collection('volunteers').get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteVolunteer(String id) async {
    try {
      await _firestore.collection('volunteers').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateVolunteer(String id, String email) async {
    try {
      await _firestore.collection('volunteers').doc(id).update({
        'email': email,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getIsUserAdmin(String email) async {
    try {
      final response = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .get();

      return response.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
