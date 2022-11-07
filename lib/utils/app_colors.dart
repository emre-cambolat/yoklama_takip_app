import 'package:flutter/material.dart';

class AppColors {
  static Color hexToColor(String color) {
    return Color(
        int.parse("0xFF${color.split("#").last.toLowerCase().trim()}"));
  }

  static Color _primaryColor = hexToColor("2C9AFF");
  static Color _backgroundColor1 = hexToColor("2C294B");
  static Color _backgroundColor2 = hexToColor("F5F8FA");
  
  
  static Color _company1Color = hexToColor("19c6c2");
  static Color _company2Color = hexToColor("f64e60");
  static Color _userAvatarColor1 = hexToColor("3699ff");
  static Color _userAvatarColor2 = hexToColor("e1f0ff");

  static Color _black = hexToColor("181C32");
  static Color _lightGrey = Color.fromRGBO(243, 246, 249, 1);
  static Color _grey = hexToColor("A1A5B7");
  

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
