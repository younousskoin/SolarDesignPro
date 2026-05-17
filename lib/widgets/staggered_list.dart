import 'package:flutter/material.dart';
import 'fade_slide.dart';

class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final int initialDelay;
  final int step;

  const StaggeredList({
    super.key,
    required this.children,
    this.initialDelay = 200,
    this.step = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.length, (i) {
        return FadeSlide(delay: initialDelay + (i * step), child: children[i]);
      }),
    );
  }
}
