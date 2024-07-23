import 'package:flutter/material.dart';

class ColorsManager {
  ///* Transparent colors
  static const Color transparent = Colors.transparent;
  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.mirror,
  );
  ///* Contrast colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFE50000);
  static const Color purple = Color(0xFF8A559B);
  static const Color cyan = Color(0xFF0BAFFF);
  static const Color green = Color(0xFF48B779);
  static const Color yellow = Color(0xFFFFBA00);
  static const Color orange = Color(0xFFF67127);
  static const Color mainColor = Color(0xFF44B649);
  static const Color mainColor2 = Color(0xFF53A948);
  static const Color textColor = Color(0xFF0B141F);
  static Color secondary = const Color.fromRGBO(5, 16, 39, 1.0);
  static Color secondaryVariant = const Color.fromRGBO(5, 16, 39, 0.6);
  static Color secondaryGrey = const Color.fromRGBO(5, 16, 39, 0.4);
  static Color borderGrey = const Color.fromRGBO(45, 45, 45, 0.13);
  static const Color darkerGreyColor = Color(0xFF989898);
  static const Color darkGreyColor = Color(0xFFD9D9D9);
  static const Color greyColor = Color(0xFFE9E8E7);
  static const Color lightGreyColor = Color(0xFFECECEC);
  static Color regularBlack = const Color.fromRGBO(45, 49, 66, 1.0);
  static Color backgroundColor = const Color(0xfff7f7f9);
  static Color textGrayColor = const Color(0xffa9a1a4);
  static Color brownColor = const Color(0xff595858);
  static String greenColor = '07B055';
  static const Color blueColor = Color(0xFF0E72ED);
  static String transparentBg = 'F2F4F7';
  static Color whiteColor = Colors.white;
  static Color grey = Color(0xffC2C3C4);

  ///`Primary colors`
  static const Color primaryGreen = Color(0xFF7BC44B);
  static const Color primaryBlack = Color(0xFF161816);

  ///`Medium colors`
  static const Color mediumAquamarine = Color(0xFF7CC99E);

  ///`Scaffold background`
  static const Color scaffoldBackground = Color(0xFFF5F5F5);

  ///`Shades of gray`
  static const Color gray10 = Color(0xFFF2F4F0);
  static const Color gray15 = Color(0xffFAFBF9);
  static const Color gray20 = Color(0xFFEBEEEA);
  static const Color gray30 = Color(0xFFC8CCC7);
  static const Color gray40 = Color(0xFFAEB4AC);
  static const Color gray50 = Color(0xFF949B91);
  static const Color gray60 = Color(0xFF7A8377);
  static const Color gray70 = Color(0xFF61685F);
  static const Color gray80 = Color(0xFF484D46);
  static const Color gray85 = Color(0xFF3A4235);
  static const Color gray90 = Color(0xFF2F332E);
  static const Color gray100 = Color(0xFF161816);

  ///`Shades of radio button`
  static const Color radioButtonColor = Color(0xFFE0E2DF);
  static const Color counterColor = Color(0xFFE8ECE5);

  ///`Linear gradient colors`

  static const LinearGradient primaryLinearGradient = LinearGradient(
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
    colors: [
      Color(0xFF9FD03C),
      Color(0xFF7BC44B),
    ],
  );
  static const LinearGradient primaryGrayGradientWholeColor = LinearGradient(
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
    colors: [
      gray10,
      gray10,
    ],
  );
  static LinearGradient primaryLightGrayGradientWholeColor = LinearGradient(
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
    colors: [
      gray10.withOpacity(0.4),
      gray10.withOpacity(0.4),
    ],
  );

  static LinearGradient lightGrayGradientWholeColor = const LinearGradient(
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
    colors: [
      ColorsManager.counterColor,
      ColorsManager.counterColor,
    ],
  );

  ///`Primary color swatches`

  static MaterialColor primaryGreenSwatch = MaterialColor(
    primaryGreen.value,
    <int, Color>{
      50: primaryGreen.withOpacity(.1),
      100: primaryGreen.withOpacity(.2),
      200: primaryGreen.withOpacity(.3),
      300: primaryGreen.withOpacity(.4),
      400: primaryGreen.withOpacity(.5),
      500: primaryGreen.withOpacity(.6),
      600: primaryGreen.withOpacity(.7),
      700: primaryGreen.withOpacity(.8),
      800: primaryGreen.withOpacity(.9),
    },
  );
}
