import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class CustomEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? imagePath;

  const CustomEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.search_off_rounded,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < 250;
        final iconSize = isCompact ? 36.0 : 80.0;
        final padding = isCompact ? 12.0 : 20.0;
        final verticalSpacing = isCompact ? 8.0 : 24.0;

        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imagePath != null
                      ? Image.asset(
                          imagePath!,
                          height: isCompact ? 80.0 : 120.0,
                          fit: BoxFit.contain,
                        )
                      : Container(
                          padding: EdgeInsets.all(padding),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: iconSize,
                            color: AppColors.primary,
                          ),
                        ),
                  SizedBox(height: verticalSpacing),
                  Text(
                    title,
                    style: (isCompact ? AppStyles.h4 : AppStyles.h3).copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: isCompact ? 16 : 18,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                  ),
                  SizedBox(height: isCompact ? 4 : 12),
                  Text(
                    subtitle,
                    style: (isCompact ? AppStyles.caption : AppStyles.bodyMedium).copyWith(
                      color: AppColors.textSecondary,
                      height: 1.3,
                      fontSize: isCompact ? 12 : 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
