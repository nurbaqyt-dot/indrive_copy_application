import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF7209B7);
  static const Color secondary = Color(0xFF9D4EDD);
  static const Color primaryDark = Color(0xFF560BAD);
  static const Color background = Color(0xFF0D0013);
  static const Color surface = Color(0xFF1A0030);
  static const Color surfaceTint = Color(0xFF250044);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE0AAFF);
  static const Color textHint = Color(0xFFB986E8);
  static const Color danger = Color(0xFFFF3B30);
  static const Color divider = Color(0xFF3C096C);
  static const Color success = Color(0xFF9D4EDD);
  static const Color info = Color(0xFF2D0052);
  static const Color sky = Color(0xFF24003F);
  static const Color link = Color(0xFFE0AAFF);
  static const Color routeFrom = Color(0xFF9D4EDD);
  static const Color routeTo = Color(0xFFE0AAFF);
  static const Color dark = Color(0xFF0D0013);

  static const LinearGradient royalGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
