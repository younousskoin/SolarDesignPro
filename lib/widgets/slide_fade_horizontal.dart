import 'package:flutter/material.dart';

class SlideFadeHorizontal extends StatefulWidget {
  final Widget child;
  final int delay;
  final double offsetX;

  const SlideFadeHorizontal({
    super.key,
    required this.child,
    this.delay = 0,
    this.offsetX = 40,
  });

  @override
  State<SlideFadeHorizontal> createState() => _SlideFadeHorizontalState();
}

class _SlideFadeHorizontalState extends State<SlideFadeHorizontal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _offset = Tween<double>(
      begin: widget.offsetX,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(_offset.value, 0),
            child: child,
          ),
        );
      },
    );
  }
}
