import 'package:flutter/material.dart';

class PulseOnTap extends StatefulWidget {
  final Widget child;
  final Color pulseColor;
  final Duration duration;
  final double radius;

  const PulseOnTap({
    super.key,
    required this.child,
    this.pulseColor = Colors.white,
    this.duration = const Duration(milliseconds: 600),
    this.radius = 80,
  });

  @override
  State<PulseOnTap> createState() => _PulseOnTapState();
}

class _PulseOnTapState extends State<PulseOnTap>
    with SingleTickerProviderStateMixin {
  Offset? _tapPosition;
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _radiusAnimation = Tween<double>(
      begin: 0,
      end: widget.radius,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.5,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _tapPosition = null);
        _controller.reset();
      }
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _tapPosition = null);
    _controller.reset();

    final renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_tapPosition != null)
            Positioned(
              left: _tapPosition!.dx - widget.radius,
              top: _tapPosition!.dy - widget.radius,
              child: IgnorePointer(
                child: SizedBox(
                  width: widget.radius * 2,
                  height: widget.radius * 2,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder:
                          (_, __) => Container(
                            width: _radiusAnimation.value * 2,
                            height: _radiusAnimation.value * 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.pulseColor.withValues(
                                alpha: _opacityAnimation.value,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
