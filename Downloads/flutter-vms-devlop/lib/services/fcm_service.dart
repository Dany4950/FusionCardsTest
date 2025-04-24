import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms/manager/api_manager/url.dart';

class FcmService {
  final Dio _dio;
  static const String _tokenKey = 'fcm_token';

  FcmService() : _dio = Dio();

  Future<void> updateToken(String newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final oldToken = prefs.getString(_tokenKey) ?? '';

      await _dio.post(
        '${BaseURL.baseURL}/auth/updateFcmToken',
        data: {
          'newToken': newToken,
          'oldToken': oldToken,
        },
      );

      // Save new token after successful update
      await prefs.setString(_tokenKey, newToken);
    } catch (e) {
      debugPrint('Failed to update FCM token: $e');
      rethrow;
    }
  }
}
