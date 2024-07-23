import 'package:flutter/material.dart';
import 'package:helpooappclient/Widgets/spacing.dart';

class PrimaryDividerText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const PrimaryDividerText({required this.text, this.textStyle, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        horizontalSpace20,
        Text(text, style: textStyle),
        horizontalSpace20,
        Expanded(
          child: Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey[300],
          ),
        )
      ],
    );
  }
}