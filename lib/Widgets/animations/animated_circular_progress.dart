
import 'package:flutter/material.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../Configurations/Constants/constants.dart';
import '../../Style/theme/colors.dart';
import '../../Configurations/extensions/size_extension.dart';

class AnimatedCircularProgress extends StatefulWidget {
  final int total;
  final int currentValue;
  final Duration? duration;
  final Color? color;
  final Color? unSelectedColor;
  final double? widthOfLine;
  final double? size;
  final Widget? child;
  const AnimatedCircularProgress({
    Key? key,
    required this.total,
    required this.currentValue,
    this.duration,
    this.color,
    this.unSelectedColor,
    this.widthOfLine,
    this.size,
    this.child,
  }) : super(key: key);

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;
  late Animation<double> _animation;
  // Duration duration = DesignSystem.kDurationSecond;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? durationSecond,
    )..addListener(() {
        setState(() {});
      });
    _curve = CurvedAnimation(curve: Curves.easeOut, parent: _controller);

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.currentValue.toDouble(),
    ).animate(_curve);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularStepProgressIndicator(
      totalSteps: widget.total,
      currentStep: _animation.value.toInt(),
      stepSize: widget.widthOfLine ?? 2.5.rw,
      selectedStepSize: widget.widthOfLine ?? 2.5.rw,
      height: widget.size ?? 15.rSp,
      width: widget.size ?? 15.rSp,
      selectedColor: widget.color ?? ColorsManager.red,
      unselectedColor: widget.unSelectedColor ?? ColorsManager.gray40,
      padding: 0,
      roundedCap: (_, __) => true,
      child: widget.child,
    );
  }
}
