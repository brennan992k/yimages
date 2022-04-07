import 'package:flutter/material.dart';
import '../alignments.dart';

class AnimatedOffset extends StatelessWidget {
  const AnimatedOffset({
    required this.child,
    required this.duration,
    this.begin,
    required this.end,
    this.curve = Curves.easeOut,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final Duration duration;
  final Offset? begin;
  final Offset end;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: begin ?? end, end: end),
      builder: (context, offset, _) => Transform.translate(
        offset: offset,
        child: TopLeft(child: child),
      ),
    );
  }
}
