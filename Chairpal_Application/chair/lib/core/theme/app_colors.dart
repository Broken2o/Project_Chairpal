import 'package:flutter/material.dart';

/// App color palette based on ChairPal design
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF14908E);
  static const Color primaryDark = Color(0xFF26525B);
  static const Color primaryLight = Color(0xFF5FCFBF);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textHint = Color(0xFFA0AEC0);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFF3EBAAA);

  // Status Colors
  static const Color error = Color(0xFFE53E3E);
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFED8936);
  static const Color info = Color(0xFF3182CE);

  // Social Auth Colors
  static const Color google = Color(0xFFDB4437);
  static const Color facebook = Color(0xFF4267B2);
  static const Color apple = Color(0xFF000000);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFFE0E0E0);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
