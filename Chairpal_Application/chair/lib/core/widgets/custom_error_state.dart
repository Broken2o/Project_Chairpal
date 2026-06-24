import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class CustomErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? imagePath;

  const CustomErrorState({
    super.key,
    this.title = 'Oops',
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
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
                            color: Colors.redAccent.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: iconSize,
                            color: Colors.redAccent,
                          ),
                        ),
                  SizedBox(height: verticalSpacing),
                  Text(
                    title,
                    style: (isCompact ? AppStyles.h4Bold : AppStyles.h3Bold).copyWith(
                      color: AppColors.primaryDark,
                      fontSize: isCompact ? 16 : 18,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                  ),
                  SizedBox(height: isCompact ? 4 : 12),
                  Text(
                    message,
                    style: (isCompact ? AppStyles.caption : AppStyles.bodyMediumSecondary).copyWith(
                      color: AppColors.textSecondary,
                      height: 1.3,
                      fontSize: isCompact ? 12 : 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (onRetry != null && !isCompact) ...[
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      label: Text('Try Again', style: AppStyles.button),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                        shadowColor: AppColors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ] else if (onRetry != null && isCompact)...[
                     SizedBox(height: verticalSpacing),
                     TextButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text('Try Again', style: AppStyles.buttonPrimary),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                     ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
