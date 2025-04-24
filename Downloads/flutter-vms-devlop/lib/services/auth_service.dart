import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/controller/fcm_controller.dart';
import 'package:vms/data/login_data.dart';
import 'package:vms/data/param/auth_param.dart';
import 'package:vms/manager/api_manager/requests/auth_request.dart';

import '../manager/api_manager/api_controller.dart';
import '../manager/utils.dart';
import '../routes/pages.dart';

class AuthStorage {
  static const String _authDataKey = 'auth_data';
  static AuthStorage to = AuthStorage();

  Future<void> _saveAuthData(UserData authData) async {
    final prefs = SessionManager.prefs;
    final authDataJson = loginDataToJson(authData);
    await prefs.setString(_authDataKey, authDataJson);
  }

  String? getAuthToken() {
    final authData = _getAuthData();
    if (authData != null) {
      if (authData.isTokenExpired) {
        Future.delayed(Duration.zero, () {
          _clearAuthToken();
        });
        return null;
      } else {
        return authData.token;
      }
    }
    return null;
  }

  UserData? _getAuthData() {
    final prefs = SessionManager.prefs;
    final authDataJson = prefs.getString(_authDataKey);

    return authDataJson != null ? loginDataFromJson(authDataJson) : null;
  }

  Future<void> _clearAuthToken() async {
    final prefs = SessionManager.prefs;
    await prefs.remove(_authDataKey);
  }

  User? getUserData() {
    final authData = _getAuthData();
    return authData?.user;
  }
}

class AuthService {
  final AuthStorage _authStorage = AuthStorage.to;

  AuthService();

  Future<bool> login(String email, String password) async {
    var param = ParamLogin(email: email, password: password);
    final res = await APIController.to.request(
      AuthRequest.login(param),
    );

    if (res.isSuccess) {
      UserData? data = res.data?.dataModel;
      if (data != null) {
        await _authStorage._saveAuthData(data);
      }
      return true;
    } else {
      res.showApiToast(backgroundColor: Colors.red);
      return false;
    }
  }

  bool isLoggedIn() {
    final token = _authStorage.getAuthToken();
    return token != null;
  }

  Future<void> logout({int statusCode = 200}) async {
    if (statusCode == 200) {
      Get.find<FcmController>().removeToken();
    }

    await _authStorage._clearAuthToken();
    Get.offAndToNamed(AppScreens.login);
  }

  String? getToken() {
    return _authStorage.getAuthToken();
  }

  int? getUserId() {
    final user = _authStorage.getUserData();
    return user?.id;
  }
}
