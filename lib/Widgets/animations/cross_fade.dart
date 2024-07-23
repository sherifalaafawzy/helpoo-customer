import 'package:flutter/material.dart';

import '../../Configurations/Constants/constants.dart';


class CrossFade extends StatelessWidget {
  final bool condition;
  final Widget shownIfFalse;
  final Widget shownIfTrue;
  final VoidCallback? onPressed;
  final Duration? duration;
  final Curve firstCurve;
  final Curve sizeCurve;
  const CrossFade({
    Key? key,
    required this.condition,
    required this.shownIfFalse,
    required this.shownIfTrue,
    this.onPressed,
    this.duration,
    this.firstCurve = Curves.easeIn,
    this.sizeCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: AnimatedCrossFade(
        firstChild: shownIfFalse,
        secondChild: shownIfTrue,
        crossFadeState: condition
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: duration ?? duration300,
        reverseDuration: duration ?? duration300,
        alignment: Alignment.center,
        firstCurve: firstCurve,
        sizeCurve: sizeCurve,
        secondCurve: firstCurve,
      ),
    );
  }
}
