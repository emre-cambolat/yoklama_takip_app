import 'package:flutter/material.dart';

class AppColors {
  static Color hexToColor(String color) {
    return Color(
        int.parse("0xFF${color.split("#").last.toLowerCase().trim()}"));
  }

  static const Color _primaryColor = Color(0xff2C9AFF);
  static const Color _backgroundColor1 = Color(0xff2C294B);
  static const Color _backgroundColor2 = Color(0xffF5F8FA);

  static const Color _company1Color = Color(0xff19c6c2);
  static const Color _company2Color = Color(0xfff64e60);
  static const Color _userAvatarColor1 = Color(0xff3699ff);
  static const Color _userAvatarColor2 = Color(0xffe1f0ff);

  static const Color _black = Color(0xff181C32);
  static const Color _lightGrey = Color.fromRGBO(243, 246, 249, 1);
  static const Color _grey = Color(0xffA1A5B7);

  static Color get primaryColor => _primaryColor;
  static Color get backgroundColor1 => _backgroundColor1;
  static Color get backgroundColor2 => _backgroundColor2;
  static Color get company1Color => _company1Color;
  static Color get company2Color => _company2Color;
  static Color get userAvatarColor1 => _userAvatarColor1;
  static Color get userAvatarColor2 => _userAvatarColor2;
  static Color get black => _black;
  static Color get lightGrey => _lightGrey;
  static Color get grey => _grey;
}
