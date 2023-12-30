import 'package:flutter/material.dart';
import 'package:silent/screens/home_screen.dart';

class MyTheme {
  static ThemeData appTheme(BuildContext context) => ThemeData(
      brightness: Brightness.light,
      primaryColor: accentColour,
      backgroundColor: backgroundColour,
      iconTheme: IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 19),
        backgroundColor: color,
      ));

  static Color accentColour = color;
  static Color backgroundColour = Colors.white;
}
