import 'package:flutter/material.dart';

Color? greyColor = Colors.grey[600];
ThemeData appThemeData = ThemeData(
    primaryColor: Colors.orange[800],
    textTheme: TextTheme(
        headlineSmall: const TextStyle(fontSize: 15, color: Colors.white),
        bodyMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(fontSize: 15, color: greyColor),
        displayLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.orange[800]),
        displayMedium: TextStyle(
            fontSize: 18,
            color: greyColor,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.fade),
        headlineLarge:
            const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        displaySmall:
            const TextStyle(fontSize: 15, overflow: TextOverflow.fade)));
