import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../generated/locale_keys.g.dart';

class BoardingModel {
 // String image;
  String backgroundImage;
  String json;
  String title;
  String content;

  BoardingModel(
      {
       /// required this.image,
      required this.content,
      required this.title,
      required this.json,
      required this.backgroundImage});
}
