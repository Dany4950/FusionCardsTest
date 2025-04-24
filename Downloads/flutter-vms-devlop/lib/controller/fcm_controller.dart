import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms/manager/api_manager/api_controller.dart';
import 'package:vms/manager/api_manager/requests/fcm_request.dart';

class FcmController extends GetxController {
  static const String _tokenKey = 'fcm_token';
  RxString currentToken = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    currentToken.value = await _getSavedToken();
  }

  /// Retrieves the Firebase Cloud Messaging (FCM) token.
  ///
  /// If the current token is empty it fetches a new token via Firebase Messaging's [getToken] method.
  ///
  /// Returns a [Future<String>] that completes with the current FCM token.

  Future<String> getFCMToken() async {
    if (currentToken.value.isEmpty) {
      currentToken.value = await FirebaseMessaging.instance.getToken() ?? '';
      debugPrint('New FCM Token: ${currentToken.value}');
      await sendTokenToBackend(currentToken.value);
    }
    return currentToken.value;
  }

  /// Loads the saved FCM token from SharedPreferences.
  Future<String> _getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  // update token to the backend
  Future<void> sendTokenToBackend(String newToken) async {
    try {
      final response = await APIController.to.request(
        FcmRequest.updateToken(newToken, currentToken.value),
      );

      if (response.isSuccess) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, newToken);
        currentToken.value = newToken;
        if (kDebugMode) {
          response.showApiToast();
        }
      } else {
        if (kDebugMode) {
          response.showApiToast();
        }
      }
    } catch (e) {
      debugPrint('Failed to update FCM token: $e');
      rethrow;
    }
  }

  void removeToken() async {
    try {
      await APIController.to.request(
        FcmRequest.removeToken(currentToken.value),
      );
    } catch (e) {
      debugPrint('Failed to remove FCM token: $e');
      rethrow;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    currentToken.value = '';
  }
}
