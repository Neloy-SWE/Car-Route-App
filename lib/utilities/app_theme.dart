/* 
Created by Neloy on 09 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';
import 'app_font.dart';

class AppTheme {
  static final get = ThemeData(
    scaffoldBackgroundColor: AppColor.colorPrimary,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: AppColor.colorPrimary,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColor.colorPrimary,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: TextStyle(
        fontFamily: AppFont.fontBold,
        color: Colors.white,
        fontSize: 22,
      ),
      iconTheme: IconThemeData(color: AppColor.colorPrimary),
    ),

    textTheme: TextTheme(
      // for title related text
      titleLarge: TextStyle(
        fontFamily: AppFont.fontBold,
        color: Colors.white,
        fontSize: 25,
      ),

      // for option name text
      bodyLarge: TextStyle(
        fontFamily: AppFont.fontBold,
        color: Colors.black,
        fontSize: 14,
      ),

      // for result text
      bodyMedium: TextStyle(
        fontFamily: AppFont.fontRegular,
        color: Colors.black,
        fontSize: 14,
      ),
    ),
  );
}
