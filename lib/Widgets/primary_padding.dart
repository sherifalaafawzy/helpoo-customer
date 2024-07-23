import 'package:flutter/material.dart';

class PrimaryPadding extends StatelessWidget {
  final Widget child;

  const PrimaryPadding({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        40.0,
      ),
      child: child,
    );
  }
}