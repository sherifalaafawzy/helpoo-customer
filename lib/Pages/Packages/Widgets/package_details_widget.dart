import 'package:flutter/material.dart';

class PackageDetailsWidget extends StatelessWidget {
  final Widget? firstWidget;
  final Widget? secondWidget;
  final Widget? thirdWidget;
  const PackageDetailsWidget(
      {super.key, this.firstWidget, this.secondWidget, this.thirdWidget});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        width: MediaQuery.of(context).size.width - 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: Offset(0, 4),
                  blurRadius: 14,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.normal)
            ],
            color: Color(0xffECECEC)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [firstWidget!, secondWidget!, thirdWidget!],
        ),
      ),
    );
  }
}
