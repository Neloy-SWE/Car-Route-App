/*
Created by Neloy on 09 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:car_route_app/utilities/app_text.dart';
import 'package:car_route_app/utilities/app_theme.dart';
import 'package:car_route_app/view/screen/screen_splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppText.title,
      theme: AppTheme.get,
      home: ScreenSplash(),
    );
  }
}
