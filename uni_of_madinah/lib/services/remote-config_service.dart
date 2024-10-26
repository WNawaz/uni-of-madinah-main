import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.fetchAndActivate();
  }

  String get serverBaseUrl {
    return _remoteConfig.getString('server_base_url');
  }
}
