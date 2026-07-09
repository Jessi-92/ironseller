import 'package:flutter/foundation.dart';

class AppConfig {
  static String get serverBaseUrl {
    const envUrl = String.fromEnvironment('SERVER_BASE_URL');

    if (envUrl.isNotEmpty) return envUrl;

    if (kIsWeb) {
      return 'http://localhost:8080';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }

    if (defaultTargetPlatform == TargetPlatform.windows) {
      return 'http://localhost:8080';
    }

    return 'http://localhost:8080';
  }

  static String get apiBaseUrl {
    return '$serverBaseUrl/api';
  }
}