import 'package:flutter/material.dart';

class PrimaryFlipHorizontalWidget extends StatelessWidget {
  final Widget child;

  const PrimaryFlipHorizontalWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(-1.0, 1.0), // Flip horizontally
      child: child,
    );
  }
}
