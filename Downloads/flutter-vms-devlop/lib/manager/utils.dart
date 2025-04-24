import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

showToast(String msg, {Color? backgroundColor}) {
  Fluttertoast.showToast(
    gravity: ToastGravity.CENTER,
    backgroundColor: backgroundColor ?? Colors.black,
    msg: msg == "null"
        ? "Something went wrong! please try again later"
        : msg.toString().contains("subtype")
            ? "Something went wrong! please try again later"
            : msg,
  );
}

extension StringEx on String {
  String png({String ext = 'png'}) {
    return 'assets/images/$this.$ext';
  }

  String get svg {
    return 'assets/images/$this.svg';
  }

  String get lottie {
    return 'assets/animation/$this.json';
  }

  String gif(String name) {
    return 'assets/animation/$name.gif';
  }
}

class SessionManager {
  static const initialUrl = 'initialUrl';

  static late SharedPreferences prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void clear() {
    prefs.clear();
  }

  static void remove(String key) {
    prefs.remove(key);
  }

  static void setString(String key, String value) {
    prefs.setString(key, value);
  }

  static String? getString(String key) {
    return prefs.getString(key);
  }
}
