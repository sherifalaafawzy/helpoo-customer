import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Style/theme/colors.dart';

class PrimaryLoading extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final isExpanded;
  const PrimaryLoading({
    Key? key,
    required this.isLoading,
    required this.child,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final child = const Center(
        child: CircularProgressIndicator(color: ColorsManager.mainColor),
      );
      if (isExpanded) return Expanded(child: child);

      return child;
    }

    return child;
  }
}
