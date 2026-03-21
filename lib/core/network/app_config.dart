import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _apiBaseUrlFromEnv = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get apiBaseUrl {
    if (_apiBaseUrlFromEnv.isNotEmpty) {
      return _apiBaseUrlFromEnv;
    }

    if (kIsWeb) {
      return 'http://localhost:5200';
    }

    // Android emulator uses 10.0.2.2 to reach host machine.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5200';
    }

    return 'http://localhost:5200';
  }
}
