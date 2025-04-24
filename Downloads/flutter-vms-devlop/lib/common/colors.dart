import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class AppColors {
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color lightGrey = Color(0xFFF4F4F4);
  static Color darkBlue = const Color(0xFF050F41);
  static Color moksaBlue = const Color(0xFF030229);
  static Color lightBlue = const Color(0xFF3D81FC);
  static Color pink = const Color(0xFFFF003D);
  static Color yellow = const Color(0xFFEBE60B);
  static Color green = const Color(0xFF07E1A4);
  static Color splashbg = "#061149".toColor();
  static Color gb1 = "#02A7FD".toColor();
  static Color gb2 = "#141C64".toColor();
  static Color gy1 = "#E4DF00".toColor();
  static Color gy2 = "#7E7C00".toColor();
  static Color gsb1 = "#007077".toColor();
  static Color gsb2 = "#00D0DD".toColor();
  static Color gp1 = "#FF007A".toColor();
  static Color gp2 = "#990049".toColor();
  static Color profilecardbg = "#F4F4F4".toColor();
}

Color primaryBlue = Color(0xff2972ff);
Color textBlack = Color(0xff222222);
Color textGrey = Color(0xff94959b);
Color textWhiteGrey = Color(0xfff1f1f5);

TextStyle heading2 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

TextStyle heading5 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle heading6 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle regular16pt = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);
