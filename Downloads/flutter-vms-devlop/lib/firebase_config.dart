import 'package:flutter_dotenv/flutter_dotenv.dart';

// This file contains sensitive Firebase configuration.
// Do not commit this file to version control.

class FirebaseConfig {
  static String get webApiKey => dotenv.env['WEB_API_KEY'] ?? '';
  static String get webAppId => dotenv.env['WEB_APP_ID'] ?? '';
  static String get messagingSenderId => dotenv.env['MESSAGING_SENDER_ID'] ?? '';
  static String get projectId => dotenv.env['PROJECT_ID'] ?? '';
  static String get webAuthDomain => dotenv.env['WEB_AUTH_DOMAIN'] ?? '';
  static String get storageBucket => dotenv.env['STORAGE_BUCKET'] ?? '';
  static String get webMeasurementId => dotenv.env['WEB_MEASUREMENT_ID'] ?? '';
  static String get windowsMeasurementId => dotenv.env['WINDOWS_MEASUREMENT_ID'] ?? '';
  
  static String get androidApiKey => dotenv.env['ANDROID_API_KEY'] ?? '';
  static String get androidAppId => dotenv.env['ANDROID_APP_ID'] ?? '';
  
  static String get iosApiKey => dotenv.env['IOS_API_KEY'] ?? '';
  static String get iosAppId => dotenv.env['IOS_APP_ID'] ?? '';
  static String get iosBundleId => dotenv.env['IOS_BUNDLE_ID'] ?? '';
  
  static String get macosApiKey => dotenv.env['MACOS_API_KEY'] ?? '';
  static String get macosAppId => dotenv.env['MACOS_APP_ID'] ?? '';
  static String get macosBundleId => dotenv.env['MACOS_BUNDLE_ID'] ?? '';
  
  static String get windowsAppId => dotenv.env['WINDOWS_APP_ID'] ?? '';
}