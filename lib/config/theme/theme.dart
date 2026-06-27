import 'package:flutter/material.dart';

final themeData = ThemeData(
  fontFamily: 'Inter',
  textTheme: TextTheme(labelLarge: TextStyle(color: Colors.white)),
  appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0.0),
);

final Map<String, Color> appColors = {
  "neutral": Color(0xff777681),
  "primary": Color(0xff3f49e0),
  "secondary": Color(0xff5FBFF9),
  "tertiary": Color(0xffBE5700),
  "background": Color(0xffe0e0ff),
};
