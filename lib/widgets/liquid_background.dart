import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class LiquidBackground extends StatefulWidget {
  final Widget child;
  const LiquidBackground({super.key, required this.child});

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final Random _rnd = Random();

  // configuration: change to add/remove blobs or tweak sizes
  final List<_BlobConfig> _blobs = [
    _BlobConfig(color: Color(0xFFB3E5FC), size: 300, duration: 8000, dx: -0.6, dy: -0.3, blur: 40),
    _BlobConfig(color: Color(0xFF81D4FA), size: 260, duration: 9000, dx: 0.8, dy: -0.5, blur: 36),
    _BlobConfig(color: Color(0xFF4FC3F7), size: 360, duration: 10000, dx: -0.2, dy: 0.7, blur: 46),
    _BlobConfig(color: Colors.white, size: 220, duration: 7000, dx: 0.4, dy: 0.4, blur: 28),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // helper: gives a smooth periodic offset for blob movement
  Offset _blobOffset(_BlobConfig b, double t, Size size) {
    // t is 0..1 from controller
    final phase = (t * (b.duration / 1000)) % 1.0;
    final dx = b.dx + 0.15 * sin(2 * pi * (phase + b.seed));
    final dy = b.dy + 0.12 * cos(2 * pi * (phase * 1.3 + b.seed));
    return Offset(size.width * (0.5 + dx), size.height * (0.5 + dy));
  }

  double _blobScale(_BlobConfig b, double t) {
    final phase = sin(2 * pi * (t + b.seed));
    return 0.85 + 0.25 * (phase + 1) / 2; // between 0.85 and 1.1
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);

      return Stack(
        children: [
          // base soft gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8F7FF), Color(0xFFFFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // animated blobs
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              final t = _ctrl.value; // 0..1
              return Stack(
                children: _blobs.map((b) {
                  final pos = _blobOffset(b, t, size);
                  final scale = _blobScale(b, t);
                  final left = pos.dx - (b.size * scale) / 2;
                  final top = pos.dy - (b.size * scale) / 2;

                  return Positioned(
                    left: left,
                    top: top,
                    width: b.size * scale,
                    height: b.size * scale,
                    child: _BlurredBlob(
                      color: b.color,
                      blur: b.blur,
                      seed: b.seed,
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // subtle overlay to improve blending
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // the child (login card etc.)
          widget.child,
        ],
      );
    });
  }
}

class _BlobConfig {
  final Color color;
  final double size;
  final int duration;
  final double dx;
  final double dy;
  final double blur;
  final double seed;

  _BlobConfig({
    required this.color,
    required this.size,
    required this.duration,
    required this.dx,
    required this.dy,
    required this.blur,
  }) : seed = Random().nextDouble();
}

class _BlurredBlob extends StatelessWidget {
  final Color color;
  final double blur;
  final double seed;

  const _BlurredBlob({
    super.key,
    required this.color,
    this.blur = 30,
    this.seed = 0,
  });

  @override
  Widget build(BuildContext context) {
    // radial gradient circle
    final grad = RadialGradient(
      center: const Alignment(0.0, -0.1),
      radius: 0.8,
      colors: [
        color.withOpacity(0.95),
        color.withOpacity(0.7),
        color.withOpacity(0.25),
        color.withOpacity(0.0),
      ],
      stops: const [0.0, 0.45, 0.75, 1.0],
    );

    // use ImageFiltered to blur the blob itself (not the whole screen)
    return Transform.rotate(
      angle: (seed - 0.5) * 0.4,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: grad,
          ),
        ),
      ),
    );
  }
}
