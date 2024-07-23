import 'dart:math';
import 'package:flutter/material.dart';

extension UIExtension on num {
  ///* Return [BorderRadius] for widget
  BorderRadius get br => BorderRadius.circular(toDouble());

  ///* Return [Radius] for widget
  Radius get rBr => Radius.circular(toDouble());

  ///* Substract date
  DateTime get pDate => DateTime.now().subtract(Duration(days: toInt()));

  ///* Substract date
  DateTime get fDate => DateTime.now().add(Duration(days: toInt()));

  ///* Substract date
  DateTime get pastMonthDate => (toInt() * 30).pDate;

  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble()).toDouble();
    return ((this * mod).round().toDouble() / mod);
  }

  ///* Get price with vat 15% from total price
  num get includedVat {
    return (this + (this * 15 / 100)).formatted;
  }

  ///* Get vat 15% from total price
  num get vat {
    return (this * 15 / 100).formatted;
  }

  //* Is success
  bool get isSuccess => this == 200;

  ///* Get value like `50.90999 to 50.90` or `50.00 to 50`
  num get formatted {
    if (this % 1 == 0) {
      return toInt();
    } else {
      return double.parse(toStringAsFixed(2));
    }
  }

  int get amountInHalala => (this * 100).formatted.toInt();

  ///* Get price with vat 15% from total price
  num get withOutVat {
    return (this - (this * 15 / 100)).formatted;
  }

  ///* Get price with vat 15% from total price
  num get withOutDelivery {
    return (this - (this * 15 / 100)).formatted;
  }
}

extension TextExtention on TextEditingController {
  ///* Return `String` after trim text from controller
  String get trimText => text.trim();

  ///* Return `int` from controller text
  int toInt() => int.tryParse(text) ?? 0;

  ///* Return `double` from controller text
  double toDouble() => double.tryParse(text) ?? 0;
}

extension StringExtension on String {
  String useCorrectEllipsis() {
    return replaceAll('', '\u200B');
  }
}
