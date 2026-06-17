import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HappyTopBar extends StatelessWidget {
  const HappyTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.happyBlue : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              isDark ? AppColors.happyGreen : AppColors.happyBlue,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'lib/assets/images/logo_happy.png',
              height: 52,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  'HAPPY',
                  style: TextStyle(
                    color: isDark ? AppColors.happyGreen : AppColors.happyBlue,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                );
              },
            ),
          ),

          const Spacer(),

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : AppColors.happyBlueSoft,
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.16)
                    : AppColors.borderLight,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'lib/assets/images/happy_face.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.sentiment_satisfied_alt_rounded,
                    color: isDark ? AppColors.happyGreen : AppColors.happyBlue,
                    size: 30,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}