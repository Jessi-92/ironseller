import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import 'dart:math';

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
    return SizedBox(
      height: 255,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WaveHeaderPainter(
              progress: _controller.value,
              isDark: widget.isDark,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 22,
                  left: 24,
                  child: _decorativeCircle(
                    size: 52,
                    color: AppColors.happyBlue.withOpacity(0.08),
                  ),
                ),

                Positioned(
                  top: 58,
                  right: 28,
                  child: _decorativeCircle(
                    size: 34,
                    color: AppColors.happyGreen.withOpacity(0.30),
                  ),
                ),

                Positioned(
                  bottom: 78,
                  right: 86,
                  child: _decorativeCircle(
                    size: 18,
                    color: AppColors.happyBlue.withOpacity(0.18),
                  ),
                ),

                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Builder(
                          builder: (_) {
                            final horizontal =
                                sin(_controller.value * 2 * pi) * 35;

                            final vertical =
                                sin((_controller.value * 4 * pi) + 1.4) * 4;

                            final rotation =
                                cos(_controller.value * 2 * pi) * 0.05;

                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..translate(horizontal, vertical)
                                ..rotateZ(rotation),
                              child: Image.asset(
                                'lib/assets/images/logo_happy.png',
                                height: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'HAPPY',
                                    style: TextStyle(
                                      color: AppColors.happyGreen,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.happyBlue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'IronSeller',
                            style: TextStyle(
                              color: AppColors.happyBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
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
    );
  }

  Widget _decorativeCircle({
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
  final bool isDark;

  _WaveHeaderPainter({
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final backgroundPaint = Paint()
      ..color = isDark ? AppColors.backgroundDark : Colors.white;

    canvas.drawRect(rect, backgroundPaint);

    final blueWavePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.happyBlue,
          AppColors.happyBlueDark,
        ],
      ).createShader(rect);

    final blueWavePath = Path()
      ..moveTo(0, size.height * 0.58);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.58 +
          sin((x / size.width * 2 * pi) + (progress * 2 * pi)) * 18;

      blueWavePath.lineTo(x, y);
    }

    blueWavePath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(blueWavePath, blueWavePaint);

    final greenWavePaint = Paint()
      ..color = AppColors.happyGreen.withOpacity(0.92);

    final greenWavePath = Path()
      ..moveTo(0, size.height * 0.66);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.66 +
          sin((x / size.width * 2 * pi) + (progress * 2 * pi) + 1.4) * 14;

      greenWavePath.lineTo(x, y);
    }

    greenWavePath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(greenWavePath, greenWavePaint);

    final whiteWavePaint = Paint()
      ..color = Colors.white.withOpacity(isDark ? 0.18 : 0.70);

    final whiteWavePath = Path()
      ..moveTo(0, size.height * 0.73);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.73 +
          sin((x / size.width * 2 * pi) + (progress * 2 * pi) + 2.1) * 12;

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
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}