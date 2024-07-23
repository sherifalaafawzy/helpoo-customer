import 'package:flutter/material.dart';

import '../../Configurations/Constants/constants.dart';

class FadeIn extends StatefulWidget {
  final Widget child;
  final bool start;
  final Duration? duration;

  const FadeIn({
    Key? key,
    required this.child,
    this.duration,
    this.start = true,
  }) : super(key: key);

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: widget.duration ?? duration500,
        reverseDuration: widget.duration ?? duration500)
      ..addListener(() {
        setState(() {});
      });
    _curve = CurvedAnimation(curve: Curves.easeOut, parent: _controller);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1,
    ).animate(_curve);
    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.start ? _controller.forward() : _controller.reverse();
    return Opacity(
      opacity: _animation.value,
      child: widget.child,
    );
  }
}
