import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/services/firebase_service.dart';

class AdminService {
  bool isAdmin = false;

  bool getAdmin() {
    return isAdmin;
  }

  void setAdmin(bool value) {
    isAdmin = value;
  }

  Future<void> fetchAdminStatus() async {
    try {
      print('Fetching admin status');

      final firebaseService = getIt<FirebaseFirestoreService>();

      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User is not logged in');
      }

      final bool response = await firebaseService.getIsUserAdmin(user.email!);

      setAdmin(response);

      print('Admin status fetched, isAdmin: $isAdmin');
    } catch (e) {
      rethrow;
    }
  }
}
