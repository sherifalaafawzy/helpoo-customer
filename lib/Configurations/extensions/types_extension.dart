import 'package:flutter/material.dart';

import '../Constants/constants.dart';


extension LocaleExtension on Locale {
  ///* Return `true` if it's [English]
  bool get isEnglish => this == localizeLanguages.first;

  ///* Return `true` if it's [Arabic]
  bool get isArabic => this == localizeLanguages.last;
}
