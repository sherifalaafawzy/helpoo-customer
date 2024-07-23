import 'package:flutter/material.dart';

import '../../../Widgets/spacing.dart';

class HintWidget extends StatelessWidget {
  final String hint;
  Color? hintColor;
  Color? dotColor;
  Size? size;

  HintWidget({
    super.key,
    required this.hint,
    this.hintColor,
    this.dotColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: size?.width ?? 10,
          height: size?.height ?? 10,
          decoration: BoxDecoration(
            color: dotColor ?? Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        horizontalSpace10,
        Text(
          hint,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: hintColor ?? Colors.black,
              ),
        ),
      ],
    );
  }
}
