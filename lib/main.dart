import 'package:flutter/material.dart';
import 'package:yoklama_takip/pages/splash.dart';
import 'package:yoklama_takip/utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.grey,
        ),
      ),
      home: SplashUI(),
    );
  }
}
