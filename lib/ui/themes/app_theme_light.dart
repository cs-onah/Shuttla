import 'package:flutter/material.dart';

ThemeData appThemeLight = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Color(0xffF7F9FC),
  scaffoldBackgroundColor: Color(0xffFAF6FE),
  hintColor: Color(0xff888888),
  primaryColor: Color(0xffCF87FD),
  primaryColorLight: Color(0xffffffff),
  accentColor: Color(0xffF86F50),
  primaryColorDark: Color(0xff000000),
  // splashColor: Color(0xff994B74),
  textTheme: TextTheme().apply(
    bodyColor: Color(0xff454F5B),
    displayColor: Color(0xff454F5B),
  ),
  fontFamily: 'Brown',
  primaryTextTheme: TextTheme(
    headline1: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xff7C45A5)),
    headline2: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff4D4D4D)),
    headline3: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff222B45)),
    subtitle1: TextStyle(fontSize: 14, color: Color(0xff222B45)),
  ),
);
