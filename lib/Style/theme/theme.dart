import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Configurations/Constants/constants.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  ///* Light Theme
  static ThemeData get lightTheme => ThemeData(
        fontFamily: TextStyles.cairoFamilyName,
        scaffoldBackgroundColor: ColorsManager.white,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorsManager.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: ColorsManager.white,
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(
            color: ColorsManager.black,
            size: 20.0,
          ),
          titleTextStyle: TextStyle(
            color: ColorsManager.black,
            fontWeight: FontWeight.bold,
            fontFamily: TextStyles.cairoFamilyName,
          ),
        ),
        hoverColor: ColorsManager.transparent,
        highlightColor: ColorsManager.transparent,
        splashColor: ColorsManager.transparent,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: ColorsManager.white,
          elevation: 50.0,
          selectedItemColor: ColorsManager.primaryBlack,
          unselectedItemColor: ColorsManager.gray40,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            height: 1.5,
          ),
        ),
        primarySwatch: ColorsManager.primaryGreenSwatch,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: ColorsManager.black,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: ColorsManager.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: ColorsManager.red,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: ColorsManager.red,
              width: 1.0,
            ),
          ),
          errorStyle: const TextStyle(
            color: ColorsManager.red,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(
            color: ColorsManager.gray40,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: const TextStyle(
            color: ColorsManager.gray40,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  ///* Dark Theme
  static ThemeData get darkTheme => ThemeData(
        fontFamily: TextStyles.cairoFamilyName,
        scaffoldBackgroundColor: ColorsManager.black,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorsManager.black,
            statusBarIconBrightness: Brightness.light,
          ),
          backgroundColor: ColorsManager.black,
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(
            color: ColorsManager.white,
            size: 20.0,
          ),
          titleTextStyle: TextStyle(
            color: ColorsManager.white,
            fontWeight: FontWeight.bold,
            fontFamily: TextStyles.cairoFamilyName,
          ),
        ),
        hoverColor: ColorsManager.transparent,
        highlightColor: ColorsManager.transparent,
        splashColor: ColorsManager.transparent,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: ColorsManager.black,
          elevation: 50.0,
          selectedItemColor: ColorsManager.primaryGreen,
          unselectedItemColor: ColorsManager.gray40,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            height: 1.5,
          ),
        ),
        primarySwatch: ColorsManager.primaryGreenSwatch,
      );

  static Locale setLocale = localizeLanguages.first;

  static Locale get currentLocale => setLocale;
}
