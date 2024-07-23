import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/types_extension.dart';
import 'package:helpooappclient/Services/navigation_service.dart';
import 'colors.dart';
import '../../Configurations/extensions/size_extension.dart';
import '../../main.dart';

class TextStyles {
  static String cairoFamilyName = "Cairo";
  static String tajawalFamilyName = "Tajawal";
  static String poppinsFamilyName = "Poppins";

  static String arabicFontFamilyName = cairoFamilyName;
  static String englishFontFamilyName = poppinsFamilyName;
  static String fontFamilyName = cairoFamilyName;

  ///* Font fontFamilyName
 // static String get fontFamilyName => NavigationService.navigatorKey.currentContext!.locale.isArabic ? arabicFontFamilyName : englishFontFamilyName;

  /// Regular text styles
  static TextStyle get regular11 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 11.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular12 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 12.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular13 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 13.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular14 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 14.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular15 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 15.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular16 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 16.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular18 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 18.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular20 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 20.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular22 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 22.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle get regular24 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 24.0.rSp,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  /// Medium text styles

  static TextStyle get medium10 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 10.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium11 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 11.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium12 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 12.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium13 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 13.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium14 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 14.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium15 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 15.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium16 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 16.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium18 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 18.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium22 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 22.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle get medium24 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 24.0.rSp,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  /// Semi-bold text styles
  static TextStyle get semiBold10 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 10.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold12 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 12.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold14 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 14.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold15 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 15.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold16 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 16.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold18 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 18.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold20 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 20.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold22 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 22.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold24 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 24.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold26 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 26.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold28 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 28.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold32 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 32.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold34 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 34.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  static TextStyle get semiBold36 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 36.0.rSp,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamilyName,
      );

  ///* Bold Styles
  static TextStyle get bold10 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 10.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold12 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 12.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold14 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 14.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold14Location => TextStyle(
        color: ColorsManager.cyan,
        fontSize: 14.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold15 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 15.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold16 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 16.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );
  static TextStyle get whiteBold16 => TextStyle(
        color: ColorsManager.white,
        fontSize: 16.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold18 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 18.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold20 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 20.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold22 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 22.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold24 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 24.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold26 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 26.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold28 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 28.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );

  static TextStyle get bold30 => TextStyle(
        color: ColorsManager.textColor,
        fontSize: 30.0.rSp,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );
}
