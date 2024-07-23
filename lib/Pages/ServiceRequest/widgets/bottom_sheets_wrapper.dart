import 'package:flutter/material.dart';
import 'package:helpooappclient/Configurations/extensions/size_extension.dart';

class BottomSheetsWrapper extends StatelessWidget {
  final Widget sheetBody;

  const BottomSheetsWrapper({required this.sheetBody, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.rh, horizontal: 14.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0.rSp),
          topRight: Radius.circular(40.0.rSp),
        ),
      ),
      child: sheetBody,
    );
  }
}
