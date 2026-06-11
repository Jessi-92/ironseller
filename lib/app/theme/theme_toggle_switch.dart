import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_controller.dart';

class ThemeToggleSwitch extends StatelessWidget {
  final bool compact;

  const ThemeToggleSwitch({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.isDarkMode;

    final double width = compact ? 52 : 62;
    final double height = compact ? 30 : 34;
    final double circleSize = compact ? 22 : 26;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: themeController.toggleTheme,
        borderRadius: BorderRadius.circular(40),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: width,
          height: height,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF0284C7),
                      const Color(0xFF0EA5E9),
                    ]
                  : [
                      const Color(0xFFE5E7EB),
                      const Color(0xFFF8FAFC),
                    ],
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.18)
                  : Colors.black.withOpacity(0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.30 : 0.16),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                alignment:
                    isDark ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    size: compact ? 15 : 17,
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}