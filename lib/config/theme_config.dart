import 'package:flutter/material.dart';

ThemeData buildThemeData() {
  return ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
