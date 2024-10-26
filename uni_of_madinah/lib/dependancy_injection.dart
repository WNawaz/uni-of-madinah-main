import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:uni_of_madinah/services/admin_service.dart';
import 'package:uni_of_madinah/services/api_service.dart';
import 'package:uni_of_madinah/services/authentication_service.dart';
import 'package:uni_of_madinah/services/content_deletion_service.dart';
import 'package:uni_of_madinah/services/content_detail_service.dart';
import 'package:uni_of_madinah/services/content_edit_service.dart';
import 'package:uni_of_madinah/services/database_service.dart';
import 'package:uni_of_madinah/services/edit_content_service.dart';
import 'package:uni_of_madinah/services/explore_content_edit_service.dart';
import 'package:uni_of_madinah/services/explore_content_service.dart';
import 'package:uni_of_madinah/services/firebase_service.dart';
import 'package:uni_of_madinah/services/remote-config_service.dart';
import 'package:uni_of_madinah/services/revenuecat_service.dart';
import 'package:uni_of_madinah/services/search_content_service.dart';
import 'package:uni_of_madinah/services/signin_service.dart';
import 'package:uni_of_madinah/services/signup_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';
import 'package:uni_of_madinah/services/volunteer_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServices(FirebaseRemoteConfig remoteConfig) async {
  await remoteConfig.fetchAndActivate();

  getIt.registerSingleton<RemoteConfigService>(
    RemoteConfigService(remoteConfig),
  );

  getIt.registerSingleton<ApiService>(
    ApiService(remoteConfig),
  );

  getIt.registerSingleton<VolunteerService>(VolunteerService());
  getIt.registerSingleton<AuthenticationService>(AuthenticationService());
  getIt.registerSingleton<DatabaseService>(DatabaseService(uid: 'uid'));
  getIt.registerSingleton<UserService>(UserService());
  getIt.registerSingleton<SignupService>(SignupService());
  getIt.registerSingleton<SignInService>(SignInService());
  getIt.registerSingleton<ContentDetailService>(ContentDetailService());
  getIt.registerSingleton<EditContentService>(EditContentService());
  getIt.registerSingleton<ContentEdittingService>(ContentEdittingService());
  getIt.registerSingleton<ExploreContentService>(ExploreContentService());
  getIt.registerSingleton<AdminService>(AdminService());
  getIt.registerSingleton<FirebaseFirestoreService>(FirebaseFirestoreService());
  getIt.registerSingleton<SearchContentService>(SearchContentService());
  getIt.registerSingleton<RevenuecatService>(RevenuecatService());
  getIt.registerSingleton<ExploreContentEdittingService>(
      ExploreContentEdittingService());
}
