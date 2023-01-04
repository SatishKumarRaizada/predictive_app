import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  static final bookingTheme = ThemeData(
    scaffoldBackgroundColor: AppColor.whiteColor,
    primarySwatch: AppColor.lightThemeColors,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'FontRegular',
    textTheme: const TextTheme(
      bodyText2: TextStyle(
        fontSize: 16,
        fontFamily: 'FontRegular',
      ),
    ),
    primaryIconTheme: IconThemeData(color: AppColor.appColor, size: 25),
    inputDecorationTheme: InputDecorationTheme(
      iconColor: AppColor.appColor,
      prefixIconColor: AppColor.appColor,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      errorStyle: const TextStyle(fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColor.blackColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColor.appColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColor.blackColor, width: 0.2),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.whiteColor,
      centerTitle: false,
      elevation: 0.0,
      iconTheme: IconThemeData(color: AppColor.appColor),
      foregroundColor: AppColor.blackColor,
      titleTextStyle: TextStyle(
        fontFamily: 'FontRegular',
        fontSize: 20,
        color: AppColor.blackColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColor.appColor,
        elevation: 0.0,
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 18, fontFamily: 'FontRegular'),
        foregroundColor: AppColor.whiteColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: TextButton.styleFrom(
        animationDuration: const Duration(milliseconds: 400),
        elevation: 0.0,
        backgroundColor: AppColor.whiteColor,
        side: BorderSide(color: AppColor.appColor, width: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'FontRegular'),
      ),
    ),
    iconTheme: IconThemeData(color: AppColor.appColor),
    cardTheme: CardTheme(
      shadowColor: Colors.grey[400],
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xffd7d8da), width: 0.4),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColor.appColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      minLeadingWidth: 10,
      dense: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColor.appColor,
      selectedLabelStyle: const TextStyle(fontSize: 16),
      enableFeedback: true,
      type: BottomNavigationBarType.shifting,
      elevation: 0.0,
      selectedIconTheme: IconThemeData(color: AppColor.appColor),
      unselectedIconTheme: IconThemeData(color: AppColor.greyDarkColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: AppColor.whiteColor,
    ),
    backgroundColor: AppColor.whiteColor,
  );
}
