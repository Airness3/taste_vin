import 'dart:math';
import 'package:flutter/material.dart';

class TasteVinLoader extends StatefulWidget {
  final bool isDone;
  final int? robeIndex; // 0..11

  const TasteVinLoader({
    super.key,
    this.isDone = false,
    this.robeIndex,
  });

  @override
  State<TasteVinLoader> createState() => _TasteVinLoaderState();
}

class _TasteVinLoaderState extends State<TasteVinLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    if (widget.isDone) {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(covariant TasteVinLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isDone && _controller.isAnimating) {
      _controller.stop();
    } else if (!widget.isDone && !_controller.isAnimating) {
      _controller.repeat();
    }
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
      builder: (context, child) {
        final double t = _controller.value;
        return CustomPaint(
          painter: TasteVinPainter(
            progress: t,
            isDone: widget.isDone,
            robeIndex: widget.robeIndex,
          ),
          child: const SizedBox(
            width: 160,
            height: 160,
          ),
        );
      },
    );
  }
}

class TasteVinPainter extends CustomPainter {
  final double progress;
  final bool isDone;
  final int? robeIndex;

  TasteVinPainter({
    required this.progress,
    required this.isDone,
    required this.robeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2.4;

    final cupuleCount = 12;
    final baseCupuleRadius = 6.0;

    final Paint cupulePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFC0C0C0);

    final Paint activePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: const [
          Color(0xFFD9A441),
          Color(0xFFA00020),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..shader = SweepGradient(
        colors: const [
          Color(0xFFEEEEEE),
          Color(0xFF999999),
          Color(0xFFCCCCCC),
          Color(0xFFEEEEEE),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 10));

    canvas.drawCircle(center, radius + 10, ringPaint);

    for (int i = 0; i < cupuleCount; i++) {
      final double angle = (2 * pi * i / cupuleCount) - pi / 2;

      final Offset cupuleCenter = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      bool isActive;

      if (!isDone) {
        final activeIndex = (progress * cupuleCount).floor() % cupuleCount;
        isActive = (i == activeIndex);
      } else {
        isActive = (robeIndex != null && i == robeIndex);
      }

      final double r = isActive ? baseCupuleRadius + 2 : baseCupuleRadius;

      canvas.drawCircle(
        cupuleCenter,
        r,
        isActive ? activePaint : cupulePaint,
      );
    }

    final Paint centerPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: const [
          Color(0xFF300000),
          Color(0xFFA00020),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius / 2));

    canvas.drawCircle(center, radius / 2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant TasteVinPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDone != isDone ||
        oldDelegate.robeIndex != robeIndex;
  }
}
