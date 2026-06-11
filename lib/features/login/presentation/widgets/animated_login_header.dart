import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedLoginHeader extends StatefulWidget {
  final bool isDark;

  const AnimatedLoginHeader({
    super.key,
    required this.isDark,
  });

  @override
  State<AnimatedLoginHeader> createState() => _AnimatedLoginHeaderState();
}

class _AnimatedLoginHeaderState extends State<AnimatedLoginHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.isDark
        ? const [
            Color(0xFF071B2D),
            Color(0xFF0D47A1),
            Color(0xFF00AEEF),
          ]
        : const [
            Color(0xFF123B63),
            Color(0xFF1677FF),
            Color(0xFF00C2FF),
          ];

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _WaveHeaderPainter(
                progress: _controller.value,
                colors: gradientColors,
                isDark: widget.isDark,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 22,
                    left: 22,
                    child: _glowCircle(
                      size: 58,
                      color: Colors.white.withOpacity(0.10),
                    ),
                  ),

                  Positioned(
                    top: 48,
                    right: 26,
                    child: _glowCircle(
                      size: 34,
                      color: const Color(0xFFBFCF03).withOpacity(0.25),
                    ),
                  ),

                  Positioned(
                    bottom: 54,
                    right: 70,
                    child: _glowCircle(
                      size: 18,
                      color: Colors.white.withOpacity(0.20),
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 34),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'lib/assets/images/logo_happy.png',
                            height: 72,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text(
                                'HAPPY',
                                style: TextStyle(
                                  color: Color(0xFFBFCF03),
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'IronSeller',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Plataforma Comercial',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.78),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _glowCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _WaveHeaderPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final bool isDark;

  _WaveHeaderPainter({
    required this.progress,
    required this.colors,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(rect);

    final backgroundPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.72);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.72 +
          sin((x / size.width * 2 * pi) + (progress * 2 * pi)) * 18;

      backgroundPath.lineTo(x, y);
    }

    backgroundPath
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(backgroundPath, backgroundPaint);

    final secondWavePaint = Paint()
      ..color = const Color(0xFFBFCF03).withOpacity(isDark ? 0.20 : 0.24);

    final secondWavePath = Path()
      ..moveTo(0, size.height * 0.65);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.65 +
          sin((x / size.width * 2 * pi) + (progress * 2 * pi) + 1.2) * 16;

      secondWavePath.lineTo(x, y);
    }

    secondWavePath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(secondWavePath, secondWavePaint);

    final whiteWavePaint = Paint()
      ..color = Colors.white.withOpacity(isDark ? 0.20 : 0.58);

    final whiteWavePath = Path()
      ..moveTo(0, size.height * 0.76);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.76 +
          sin((x / size.width * 2 * pi) + (progress * 2 * pi) + 2.2) * 14;

      whiteWavePath.lineTo(x, y);
    }

    whiteWavePath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(whiteWavePath, whiteWavePaint);
  }

  @override
  bool shouldRepaint(covariant _WaveHeaderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDark != isDark ||
        oldDelegate.colors != colors;
  }
}