/* 
Created by Neloy on 09 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:car_route_app/utilities/app_text.dart';
import 'package:flutter/material.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppText.welcome)),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_transportation_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                  Text(AppText.title, style: TextTheme.of(context).titleLarge),
                  Text(
                    AppText.subtitle,
                    style: TextTheme.of(
                      context,
                    ).bodyMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
