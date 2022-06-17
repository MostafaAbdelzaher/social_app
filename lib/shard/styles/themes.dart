import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import '../component/constants.dart';

ThemeData them = ThemeData(
  primarySwatch: secondaryColor,
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 25,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: secondaryColor),
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      bodyText2: TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
      caption: TextStyle(
          color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
);
