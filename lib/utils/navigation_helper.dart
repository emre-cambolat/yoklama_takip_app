import 'package:flutter/material.dart';

class NavigatorHelper {
  static Future<void> push(BuildContext context,
      {required Widget child}) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => child));
  }

  static Future<void> pushReplacement(BuildContext context,
      {required Widget child}) async {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => child));
  }

  static Future<void> pushAndRemoveUntil(BuildContext context,
      {required Widget page}) async {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => page,
      ),
      (route) => false,
    );
  }
}
