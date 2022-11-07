import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppWillPopScope extends StatefulWidget {
  const AppWillPopScope({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<AppWillPopScope> createState() => _AppWillPopScopeState();
}

class _AppWillPopScopeState extends State<AppWillPopScope> {
  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: widget.child,
      onWillPop: () async {
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 2);
        final isWarning =
            lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          lastPressed = DateTime.now();

          Fluttertoast.showToast(
            msg: "Çıkmak için tekrar basın",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );

          return false;

        } else {
          // debugPrint("Exiting...");
          return true;
        }
      },
    );
  }
}

